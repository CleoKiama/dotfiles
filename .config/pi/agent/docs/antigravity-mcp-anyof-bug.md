# Bug: `mcp` tool's `anyOf` schema breaks Claude models via Antigravity

**Status:** ROOT-CAUSED + PATCHED locally (2026-08-07). Patch verified live; review verdict appended below.
**Patch history:** 2.20.1 (original) → 2.21.2 (**RE-APPLIED 2026-08-07** after `pi update` bumped
the adapter and wiped the store; block was byte-identical, patch file refreshed for 2.21.2) →
**RE-APPLIED again 12:33 local** (a patch-file validation step clobbered the store copy with a
pristine backup — restore mistakes are the #1 way this fix silently disappears; always re-verify
`grep -c Type.Union` == 1 after any write).
**Affects:** `pi` sessions using `@cortexkit/pi-antigravity-auth` with **Claude-family** wire models
(`antigravity-claude-sonnet-4-6-thinking`, `claude-sonnet-4-6`, `claude-opus-4-6-thinking`, …).
Gemini/GPT-OSS models are unaffected (Gemini API accepts the schema).

---

## 1. Symptom

Every request to a Claude model fails immediately with an Anthropic-side rejection:

```
Antigravity request failed: HTTP 400 ...
"tools.21.custom.input_schema: JSON schema is invalid. It must match JSON Schema draft 2020-12"
```

- `tools.N` = index of the offending tool in the request's tool list (varies by session tool order;
  21 in the original report, 7 in the repro harness).
- `custom` = Anthropic's tool type for this API surface, not a hint about which tool is broken.
- The error comes back wrapped in the proxy's own envelope: `{"error":{"code":400,"message":"{\"type\":\"error\",...}"}}`.
- Backend `req_vrtx_*` (Vertex) — this is the Google Antigravity CLI proxy, not raw Anthropic.

## 2. Root cause chain (fully traced)

1. **`pi-mcp-adapter`** registers the `mcp` gateway tool with
   `args: Type.Optional(Type.Union([Type.String(...), Type.Object({}, {additionalProperties: true})]))`.
   TypeBox compiles `Type.Union` to JSON Schema **`anyOf`** (verified with typebox@1.3.8 directly).
   This `mcp` tool is the **only** tool in the entire 36-tool set containing `anyOf`
   (checked: pi builtins `read/bash/edit/write/grep/find/ls`, `mcpScript`, `Agent`/subagent tools,
   all 7 `Task*` tools, `workflow`, context7 ×2 and codebase-memory ×14 server tools, and all
   TypeBox `Optional` props — TypeBox `Optional` emits *no* null-union, only required-omission).
2. The antigravity extension sends tool schemas to the proxy in **Gemini format**:
   `tools: [{functionDeclarations: [...]}]` → `POST https://daily-cloudcode-pa.googleapis.com/v1internal:streamGenerateContent?alt=sse`.
   Each tool's `parameters` pass through the core's `toGeminiSchema()`: types uppercased
   (`OBJECT`, `STRING`, `NULL`…), `additionalProperties`/`$schema`/`const` stripped, but
   `anyOf`, `default`, `examples`, `uniqueItems` etc. are **kept**.
3. **The proxy's Gemini→Claude schema converter does not handle `anyOf`.** It passes `anyOf`
   through unchanged — including the uppercase type values (`"STRING"`, `"NULL"`). Those are not
   valid JSON Schema 2020-12 type names, so Anthropic's validator rejects the whole
   `input_schema`: *"JSON schema is invalid. It must match JSON Schema draft 2020-12."*
4. Anthropic returns 400 before any completion → every Claude-model request dies.

## 3. Evidence (live probe against the real endpoint, 2026-08-07)

Replaying the exact extension request path (core's own `toGeminiSchema` + `auth.json` token +
proxy + real `claude-sonnet-4-6`), one synthetic tool property per request:

| Schema feature sent | Result |
|---|---|
| baseline `{type: string}` | ✅ 200 |
| `default`, `title`, `format`, `pattern`, `minProperties`, `required`, `const` (stripped), empty schema `{}`, `additionalProperties:false` (stripped), `minimum`, `type:"number"`, `nullable:true` | ✅ 200 |
| `oneOf: [{string},{integer}]` | ✅ 200 |
| **`anyOf: [{string},{integer}]`** (no null!) | ❌ 400 — *exact* user error `tools.N.custom.input_schema` |
| **`anyOf: [{string}]`** (single member) | ❌ 400 — same |
| **`anyOf: [{string},{null}]`** | ❌ 400 — same |
| `examples` / `uniqueItems` | ❌ 400 — *different* proxy-layer error (`Invalid JSON payload received…`), proxy rejects them outright |

Conclusion: **any use of `anyOf` in a tool schema → Claude 400 through this proxy.** `oneOf` is a
safe drop-in replacement. `examples`/`uniqueItems` are a separate, secondary proxy-layer issue
(no installed tool uses them).

## 4. The fix (applied)

File: `~/.config/pi/agent/npm/node_modules/.pnpm/pi-mcp-adapter@2.20.1_typebox@1.3.8/node_modules/pi-mcp-adapter/index.ts`
(that's the copy pi actually loads via jiti; the top-level `node_modules/pi-mcp-adapter` is a symlink into `.pnpm`).

Before:

```ts
args: Type.Optional(Type.Union([
  Type.String({ description: "Arguments as a JSON string (e.g., '{\"key\": \"value\"}')" }),
  Type.Object({}, {
    additionalProperties: true,
    description: 'Arguments as a JSON object (e.g., { "key": "value" })',
  }),
], { description: "Tool arguments as a JSON object, or as a JSON string encoding one" })),
```

After (comment included, object-only schema → no `anyOf`; the execute handler still accepts
JSON strings and parses them):

```ts
// NOTE: local patch (2026-08-07): was Type.Union([...]) which emits `anyOf`.
// The Antigravity proxy mangles `anyOf` when converting Gemini tool schemas to
// Anthropic input_schema, causing "tools.N.custom.input_schema: JSON schema is
// invalid (draft 2020-12)" for Claude models. Object-only schema avoids anyOf;
// the runtime still accepts JSON strings (see execute handler).
args: Type.Optional(Type.Object({}, {
  additionalProperties: true,
  description: 'Tool arguments as a JSON object, or a JSON string encoding one (strings are parsed as JSON)',
})),
```

**Verification:** full 36-tool list rebuilt with the patched `mcp` schema replayed live → **HTTP 200**,
Claude answers. Control probe (`anyOf` + null) still 400 → diagnosis confirmed.
Second verification (2.21.2): TypeBox compile of the patched `args` block → no `anyOf` in output.

**Apply at runtime:** restart pi or `/reload` (reloads extensions).

## 5. Surviving updates

The patch lives inside the pnpm store (`.pnpm/`) — **wiped by `pi update --extensions`, `pi update --all`,
or any reinstall of pi-mcp-adapter**. Re-apply with the companion patch file:

```bash
cd ~/.config/pi/agent/npm && patch -p1 < ~/.config/pi/agent/docs/pi-mcp-adapter-anyof.patch
```

(If the adapter version bumps, re-derive the hunk manually — the patch header embeds the
versioned `.pnpm/pi-mcp-adapter@2.20.1_typebox@1.3.8/` path, so `patch -p1` will reject on a
version bump. The marker comment in the file makes it easy to find. If `pi-mcp-adapter` ever
ships a `oneOf`-based schema upstream, that's the preferred fix — TypeBox 1.3.8 has **no**
native `{ union: 'oneOf' }` option; `Type.Union` always emits `anyOf`.)

## 6. Upstream fixes worth reporting

1. **yusukeshib/pi-mcp-adapter** — replace `Type.Union([...])` in the `mcp` tool's `args`
   with either `Type.Object({}, {additionalProperties: true})` (this patch) or
   `Type.Unsafe({ oneOf: [...] })` (preserves string+object semantics; `oneOf` passes the
   proxy — verified). Defensive: any host using a strict proxy breaks on `anyOf`.
2. **cortexkit/antigravity-auth** — their schema transform could rewrite `anyOf` → `oneOf`
   before sending (proxy-safe), and drop `examples`/`uniqueItems` while at it.
3. **Google (Antigravity proxy)** — the real bug: the Gemini→Claude schema converter must
   lowercase types inside `anyOf` (and translate `NULL`). `anyOf` is valid 2020-12.

## 7. Tooling notes

- `~/.local/bin/agy-status --quota` — live quota/auth health for the `google-antigravity` entry
  in `~/.config/pi/agent/auth.json` (buckets 99–100%, reset ~18:33–18:50 local).
- Watch for `AUTH-FAIL` (401) — package ToS is a Google ToS violation; re-`/login google-antigravity` if revoked.
- Never commit `auth.json` or token material anywhere (this doc is deliberately secret-free).

---

## Review verdict

**Reviewed by subagent (2026-08-07): APPROVE** — verdict `approve`, 36 tool uses, independent
verification of TypeBox output, proxy behavior, and the writeup.

Top 3 risks (as identified by reviewer):

1. **Pnpm store overwrite** — the patch lives in `.pnpm/`; `pi update` / reinstall silently
   reverts it → Claude sessions break again. Mitigated: `docs/pi-mcp-adapter-anyof.patch` +
   AGENTS.md pointer. Watch `agy-status` for the `mcp` tool schema after any update.
2. **Schema/runtime mismatch on string args** — schema now says `object`, runtime still
   accepts JSON strings; a strict pre-validation layer on tool calls could reject string
   args before `execute()` runs. No such layer in pi's current path (extension sends schema
   straight through), but keep in mind if the adapter adds validation.
3. **Versioned patch path** — re-apply needs the `.pnpm/pi-mcp-adapter@2.20.1_typebox@1.3.8/`
   path; version bumps break `patch -p1`. Re-derive the hunk on update.

Alternative noted by reviewer (rejected in favor of this patch): `Type.Unsafe({oneOf: [...]})`
— preserves both string and object forms in the schema and `oneOf` passes the proxy; but
object-only is better for model prompting. Doc corrections from the review were folded into
Sections 5 and 6.
