# Global Preferences

## Language Preferences
When building new tools, scripts, or projects, prefer these languages (in order) with a strong preference to Go:
1. Go
2. Rust
3. Ruby (for quick scripting use cases)

Bash is great for scripts and automation — use it freely. But when a script grows sufficiently complex (heavy string parsing, error handling, multiple subcommands, or anything that would benefit from types), suggest graduating to Go/Rust/Ruby per the preferences above.

Python/Java/Kotlin are fine for Netflix ecosystem work (SBN, DGS, Titus, etc.) but do not suggest them for new standalone tools or scripts unless explicitly requested.

## Infrastructure Context
- Works on Kubernetes and Titus at Netflix
- Decade of Kubernetes experience — treat as an expert. Skip K8s basics and beginner explanations.
- `k/k` = `kubernetes/kubernetes` repo. `k/*` = repos in the `kubernetes` or `kubernetes-sigs` GitHub orgs.

## Git Conventions
- Work branches: prefix with `ajw-` (e.g., `ajw-add-scp-missing-details`)
- Commit messages follow Tim Pope's style (https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html):
  - Subject: imperative mood, capitalized, 50 chars or less
  - Blank line between subject and body
  - Body wrapped at 72 characters
- **Do NOT commit unless explicitly asked.** Instead, suggest a commit message as a reminder. The user owns the git commit process.

## Editor / Terminal
- Ghostty terminal, Neovim, Tmux
- Prefer terminal/CLI tools over GUI alternatives
- Use `jq` for JSON parsing (not python one-liners)
- Dotfiles always at `~/dot` regardless of machine
- Before assuming a command is wrong or doesn't exist, run `alias` in the shell to check for shell aliases

## Communication Style
- Be concise, skip preamble, don't over-explain
- Cite sources when possible

## Design Philosophy
- Prefer "Worse is Better" (New Jersey style): implementation simplicity over interface completeness. Ship something simple that works, iterate later. Don't over-design.

## Code Style
- Follows language conventions; defer to patterns in Neovim config at `~/dot`
- When in doubt, match the style of surrounding code in the project

## Obsidian Vaults
- Work vault: `~/Documents/obsidian_work/`
- Personal vault: `~/Documents/obsidian_personal/`
