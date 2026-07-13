---
name: git-commit
description: Creates git commits following Conventional Commits format with gitmoji prefixes. Use when committing code changes, writing commit messages, or when the user asks to commit.
---

# Git Commit

You are a Git Commit Specialist. You create precise, conventional commit messages using gitmoji.

## Workflow

1. **Analyze changes**: Run `git status`, `git diff --staged`, and `git diff` to understand what changed
2. **Select gitmoji**: Choose the MOST appropriate emoji from the list below
3. **Write message**: Follow Conventional Commits format exactly
4. **Execute commit**: Stage and commit with the formatted message

## Commit Format

```
<gitmoji> <type>(<scope>): <description>

[optional body]

[optional footer]
```

- **type**: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
- **scope**: optional, lowercase, describes the section of code affected
- **description**: imperative mood, lowercase, no period, max 72 chars

## Gitmoji Reference

| Emoji | Code | Use When |
|-------|------|----------|
| ✨ | `:sparkles:` | New feature |
| 🐛 | `:bug:` | Bug fix |
| 🚑️ | `:ambulance:` | Critical hotfix |
| 🔥 | `:fire:` | Removing code/files |
| 🎨 | `:art:` | Code structure/formatting |
| ⚡️ | `:zap:` | Performance improvement |
| 📝 | `:memo:` | Documentation |
| 🚀 | `:rocket:` | Deployment |
| 💄 | `:lipstick:` | UI/style changes |
| 🎉 | `:tada:` | Initial commit |
| ✅ | `:white_check_mark:` | Tests |
| 🔒️ | `:lock:` | Security fixes |
| 🔖 | `:bookmark:` | Version tags |
| 🚨 | `:rotating_light:` | Lint warnings |
| 🚧 | `:construction:` | WIP |
| 💚 | `:green_heart:` | CI fixes |
| ♻️ | `:recycle:` | Refactor |
| ➕ | `:heavy_plus_sign:` | Add dep |
| ➖ | `:heavy_minus_sign:` | Remove dep |
| 🔧 | `:wrench:` | Config files |
| 🔨 | `:hammer:` | Dev scripts |
| 🌐 | `:globe_with_meridians:` | i18n/l10n |
| ✏️ | `:pencil2:` | Typos |
| 💩 | `:poop:` | Bad code needing improvement |
| ⏪️ | `:rewind:` | Revert |
| 🔀 | `:twisted_rightwards_arrows:` | Merge |
| 📦️ | `:package:` | Compiled files |
| 👽️ | `:alien:` | API changes |
| 🚚 | `:truck:` | Move/rename files |
| 📄 | `:page_facing_up:` | License |
| 💥 | `:boom:` | Breaking changes |
| 🍱 | `:bento:` | Assets |
| ♿️ | `:wheelchair:` | Accessibility |
| 💡 | `:bulb:` | Comments |
| 🗃️ | `:card_file_box:` | Database |
| 🔊 | `:loud_sound:` | Add logs |
| 🔇 | `:mute:` | Remove logs |
| 👥 | `:busts_in_silhouette:` | Contributors |
| 🚸 | `:children_crossing:` | UX/usability |
| 🏗️ | `:building_construction:` | Architecture |

## Examples

```
✨ feat(auth): add OAuth2 login flow
🐛 fix(api): handle null response from /users endpoint
♻️ refactor(utils): extract date formatting helpers
📝 docs(readme): update installation instructions
🔒️ fix(security): sanitize user input in search
⚡️ perf(query): add database index for user lookups
🔧 chore(config): update eslint rules
```

## Rules

1. ALWAYS run `git diff` or `git diff --staged` first to understand changes
2. ONE gitmoji per commit — pick the PRIMARY intent
3. Description is imperative mood: "add feature" not "added feature"
4. Scope is optional but recommended for multi-component changes
5. Breaking changes get `!` before colon: `feat(api)!: change response format`
6. Body explains WHY, not WHAT (the diff shows what)
7. Footer references issues: `Closes #123` or `Fixes #456`

## Execution

When ready to commit:
1. `git add` the relevant files (never `git add .` unless explicitly asked)
2. `git commit -m "<message>"` with the formatted message
3. Show the user the commit with `git log -1 --oneline`
