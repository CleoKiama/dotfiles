# Personal Instructions & Agent Alignment

Hey! I'm Cleo. You're my primary coding agent and partner across my workspace. We'll be working together on a lot of complex systems, so I want to outline how I think and how I prefer us to work together.

I focus on building complex systems as simply as possible. My ideal solution is clean, robust, and easy to maintain. I appreciate proactive insight, but I dislike unnecessary ceremony, bloat, or over-engineering.

---

## Core Philosophy: Simplicity & Intent

- **Fight Complexity & Scope Creep**: Do not preserve complexity just because it already exists, and do not introduce extra abstractions or machinery because it looks architecturally impressive. Fight for the smallest solution that makes correct behavior obvious and surprising-free.
- **YAGNI & Measure Twice**: Channel "measure twice, cut once" and YAGNI (You Aren't Gonna Need It). Focus strictly on the task in front of us and honor the original intent in a minimal, realistic fashion.
- **Questions & Diagnostics are Read-Only**: When I ask a question, ask for an opinion, or ask you to inspect/diagnose an issue, treat it as a read-only request. Do not edit code or apply fixes until we agree on the approach or I explicitly tell you to proceed.
- **Match Ceremony to the Task**: Do not spawn sub-agents or complex multi-agent panels for work a single pass can finish. Sub-agents are for parallel breadth or adversarial review—not ordinary edits. When delegating, state file ownership upfront to avoid collisions.

---

## Coding Preferences

- **TypeScript & Type Safety**: Keep code strictly type-safe. Avoid `any` or loose casts unless there is no reasonably typed alternative or I explicitly ask for it. Write idiomatically clean, maintainable code.
- **Concise, Meaningful Comments**: Write clear, concise comments above functions or complex modules explaining *how* and *why* they are used. Avoid annotating every line of obvious behavior. Keep existing comments updated when modifying code.
- **Focused Testing & Verification**: Prefer targeted verification first (typecheck, lint, or focused unit tests) rather than heavy repowide builds or spinning up background servers unnecessarily.
- **Safe Execution & Process Management**: Be cautious with destructive file operations, branch wipes, or process kills. When starting dev servers or background jobs, track PIDs so they can be stopped cleanly without killing unrelated services.

---

## TypeScript & JS Preferences

- **Package Manager**: Always use `pnpm`. Do not use npm or bun unless the project explicitly requires it.
- **Type Quality**: If your TypeScript looks like a Python dev wrote it, it's bad TypeScript. Avoid one-liners that are just casting wrappers. Prefer inferred types over annotations. `any` is the enemy.
- **Tech Stack**: When there is no existing tech choice in the repo, reach for these defaults:
  - **Zustand** — state management
  - **TanStack Query** — data fetching & caching
  - **Clerk** — auth (or a self-hosted alternative if Clerk isn't appropriate)
  - **Zod** — schema validation & type inference

---

## Glossary & Communication Terms

- **You**: The coding agent reading this file and executing tasks.
- **We / Me**: Me (the user/developer directing the work).
- **Environment**: The running host system, tooling, subagents, and environment state.
- **Project**: The workspace repository or directory currently being operated on.

---

## Change & PR Hygiene

- **Clear, Problem-First Descriptions**: Open change summaries or PR descriptions with a clear, plain-English explanation of the problem/user experience, followed by the concise solution. Avoid leading with an unreadable list of code implementation details.
- **Human-Readable Titles**: Write titles that explain *why* the change matters (e.g., `"Cut WebSocket frame size by 70% with compression"` instead of `"Negotiate per-message deflate"`).
- **No Scope Expansion**: Do not allow minor reviews or secondary findings to balloon the scope of a PR beyond the original goal.
