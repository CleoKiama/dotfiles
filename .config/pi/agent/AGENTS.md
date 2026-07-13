# Dotfiles Pi Config — Setup Reference

## Directory Layout

This directory (`/home/cleo/dotfiles/.config/pi/agent/`) IS the pi config directory.
`PI_CODING_AGENT_DIR=/home/cleo/.config/pi/agent` (symlink → the dotfiles path above).
Any file here is version-controlled in the dotfiles repo.

| Path | Purpose |
|------|---------|
| `AGENTS.md` | This file — setup docs for LLM context |
| `agents/` | Global custom subagent types (pi-subagents) |
| `extensions/` | Global pi extensions (auto-discovered `.ts` files) |
| `skills/` | Local skill directories (git-commit) |
| `prompts/` | Prompt templates |
| `git/github.com/` | Git-based pi packages (pi-skills, superpowers) |
| `npm/` | npm-based pi packages (pi-subagents, pi-wakatime, etc.) |
| `settings.json` | Global pi settings (provider, models, packages) |
| `subagents.json` | pi-subagents persistent settings |

## Key Environment Variables

- **`PI_CODING_AGENT_DIR=/home/cleo/.config/pi/agent`** — tells pi where to find global config.
  This is a symlink to `/home/cleo/dotfiles/.config/pi/agent/` so dotfiles repo is the source of truth.
- **`ANTHROPIC_API_KEY`** / **`OPENAI_API_KEY`** — set externally for those providers if needed.
- **`GIT_TERMINAL_PROMPT=0`**, **`GIT_SSH_COMMAND`** — useful for non-interactive runs.

## Provider & Models

| Setting | Value |
|---------|-------|
| Default Provider | `opencode` |
| Default Model | `deepseek-v4-flash-free` |
| Default Thinking | `high` |
| Allowed Models | `opencode/*-free`, `opencode-go/*` |

All models are free-tier (no API key costs). The `enabledModels` scope limits
Ctrl+P cycling and subagent model selection.

## Custom Subagents (pi-subagents)

pi-subagents is installed via `npm:@tintinweb/pi-subagents`.
Custom agent types live in `agents/` and are auto-discovered as global agents.

| Agent | Type | Model | Purpose |
|-------|------|-------|---------|
| `librarian` | custom | `mimo-v2.5-free` | Web/docs research via MCP + brave-search |
| `planner` | custom | `deepseek-v4-pro` | Implementation planning (read-only) |
| `reviewer` | custom | `kimi-k2.7-code` | Code review (read-only) |
| `scout` | custom | `nemotron-3-ultra-free` | Fast codebase recon |
| `worker` | custom | `deepseek-v4-flash-free` | Full-capability task execution |
| `Explore` | override? | `claude-haiku-4-5`? | Default — can override in `agents/Explore.md` |
| `general-purpose` | default | inherits parent | Parent twin — same rules/prompt |
| `Plan` | default | inherits parent | Software architect (read-only) |

### Override defaults
Create a file in `agents/` with the same name as a built-in type (e.g. `Explore.md`).
Frontmatter fields available: `tools`, `model`, `thinking`, `max_turns`, `extensions`,
`exclude_extensions`, `disallowed_tools`, `skills`, `memory`, `isolation`,
`isolated`, `inherit_context`, `prompt_mode`, `description`, `enabled`.

Frontmatter is **authoritative** — caller params can't override pinned fields.
`prompt_mode: append` makes the agent a "parent twin" (inherits parent's full prompt).

### MCP tool access
To give a subagent MCP access, add `mcp` to its `tools:` list.
Currently connected MCP servers: **context7** (2 tools), **codebase-memory** (14 tools).
Always connected in this session — verified via `mcp({ })`.

### Persistent settings (`subagents.json`)
- `maxConcurrent: 3` — max parallel background agents
- `graceTurns: 3` — wrap-up turns before hard abort at limit

## Installed Packages

| Package | Source | Contents |
|---------|--------|----------|
| `pi-skills` | `git:github.com/badlogic/pi-skills` | brave-search, browser-tools, gccli, gdcli, gmcli, transcribe, vscode, youtube-transcript |
| `pi-wakatime` | `npm:pi-wakatime` | WakaTime integration |
| `superpowers` | `git:github.com/obra/superpowers` | ~14 workflow skills (brainstorming, tdd, debugging, plans, etc.) |
| `pi-mcp-adapter` | `npm:pi-mcp-adapter` | MCP adapter |
| `pi-subagents` | `npm:@tintinweb/pi-subagents` | Autonomous sub-agent framework |
| `pi-tasks` | `npm:@tintinweb/pi-tasks` | Task management tools |

## Skills (local)

- **`git-commit`** — `skills/git-commit/SKILL.md` — Conventional Commits with gitmoji.
  Run `/skill:git-commit` when committing.
- **`pi-skills` skills** — in `git/github.com/badlogic/pi-skills/` — loaded as packages:
  brave-search, browser-tools, gccli, gdcli, gmcli, transcribe, vscode, youtube-transcript
- **`superpowers` skills** — in `git/github.com/obra/superpowers/skills/`:
  brainstorming, test-driven-development, systematic-debugging, writing-plans,
  executing-plans, subagent-driven-development, dispatching-parallel-agents, etc.

## Extensions

- **`extensions/custom-compaction.ts`** — Uses `opencode/deepseek-v4-flash-free` for
  context compaction summarization instead of the default model. Falls back gracefully.

## Shell

- **npm**: Uses `pnpm` instead of npm (`npmCommand: ["pnpm"]`)
- **Aliases**: `shellCommandPrefix` runs `source ~/.zshrc` to load aliases before each bash command
- Manual alias trigger: `shopt -s expand_aliases && source ~/.zshrc`

## Conventions

- **Commit style**: Conventional Commits with gitmoji. Run `/skill:git-commit`.
- **Responses**: Prefer concise, actionable. Show file paths clearly.
- **Verification**: Run tests/checks before claiming completion (see superpowers/verification-before-completion).
- **Debugging**: Use systematic-debugging skill when encountering bugs.
- **Planning**: Use writing-plans skill before multi-step implementations.

## Reference Docs (for further research)

| Topic | URL |
|-------|-----|
| Pi docs (all topics) | `https://github.com/earendil-works/pi/tree/main/packages/coding-agent/docs/` |
| Extensions API | `https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/extensions.md` |
| Settings reference | `https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/settings.md` |
| Skills spec | `https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/skills.md` |
| Custom providers | `https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/custom-provider.md` |
| Models | `https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/models.md` |
| Packages | `https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/packages.md` |
| SDK | `https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/sdk.md` |
| pi-subagents README | `https://raw.githubusercontent.com/tintinweb/pi-subagents/refs/heads/master/README.md` |

Use `curl -sL <url>` from bash to fetch docs inline when you need details.

## MCP Servers

| Server | Tools | Status |
|--------|-------|--------|
| context7 | 2 tools | Connected |
| codebase-memory | 14 tools | Connected (cached) |
| linear | — | Not connected |
| axiom | — | Not connected |

Access via the `mcp` built-in tool. Use `mcp({ server: "name" })` to list a server's tools,
`mcp({ tool: "name", args: "..." })` to call one.
