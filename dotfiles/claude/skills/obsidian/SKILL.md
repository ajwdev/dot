---
name: obsidian
user-invocable: true
description: |
  Write notes, summaries, or daily entries to Obsidian vaults.
  Keywords:
  - Obsidian, vault, notes, daily note
  - summarize, summary, write-up, document
  - work vault, personal vault
  - conversation summary, session notes
  - roundup, recap, EOD, end of day, what did I do today
---

# Obsidian Vault Writer

You help the user write structured notes into their Obsidian vaults. There are three modes: **Discussion Summary**, **Daily Note Append**, and **Daily Roundup**. Infer which mode the user wants from their request (keywords like "roundup", "recap", "what did I do today" → Mode 3). If ambiguous, ask.

## Vault Locations

| Vault | Path |
|-------|------|
| Work | `~/Documents/obsidian_work/` |
| Personal | `~/Documents/obsidian_personal/` |

## Mode 1: Discussion Summary

Generate a structured document summarizing the current conversation (or a topic the user specifies).

### Steps

1. **Infer vault and folder** from the conversation topic.
   - Work-related topics (Netflix, Titus, k8s, services, debugging) → work vault.
   - Personal topics (side projects, general programming, non-work) → personal vault.
   - If unsure, ask.
2. **Infer target folder** — Glob the vault's top-level directories and pick the best match for the topic. Known work vault folders:
   - `Projects/` — design discussions, investigations, feature work (has subfolders like `Native K8S`, `Functions Reboot`, etc.)
   - `Teams/` — team-specific notes
   - `Estimates/` — estimation artifacts
   - If no existing folder fits, suggest creating a new one or placing in the vault root. Always ask the user to confirm.
3. **Infer filename** from the topic (e.g., `Fast Properties Daemonset - Design Discussion.md`).
4. **Ask the user to confirm**: vault, folder path, and filename before writing.
5. **Write the document** following the frontmatter and structure rules below.

### Frontmatter Rules

**Work vault** — YAML frontmatter:
```yaml
---
tags:
  - claude-generated
  - <topic-tag-1>
  - <topic-tag-2>
date: YYYY-MM-DD
---
```

**Personal vault** — No YAML frontmatter. Place an inline tag at the top of the file:
```
#claude-generated
```

### Document Structure

```markdown
# <Title>

## Problem Statement
<What problem or question prompted this conversation>

## Key Findings
<Bulleted list of important discoveries, facts, or conclusions>

## Decisions / Recommendations
<What was decided or recommended>

## Open Questions
<Anything still unresolved>
```

Adapt section headings to fit the content. Not every section is required — omit sections that don't apply. Add additional sections if the conversation warrants it (e.g., `## Code Changes`, `## Architecture`, `## Action Items`).

## Mode 2: Daily Note Append

Append content to the current day's daily note.

### Daily Note Paths

Both vaults use: `Daily/YYYY/MM/YYYY-MM-DD.md`

Example: `Daily/2026/02/2026-02-26.md`

### Steps

1. Determine which vault (default: work vault unless the user says otherwise).
2. Compute today's date and the daily note path.
3. If the file exists, **read it first** — then append under a new heading.
4. If the file does not exist, create it with vault-appropriate content:
   - **Work vault**: Start with the date as a tag line (e.g., `#daily`) matching existing convention, then append the content.
   - **Personal vault**: Use the template from `Daily/_template_.md` if it exists, then append.
5. Create intermediate directories (`Daily/YYYY/MM/`) if they don't exist.
6. Append under a heading like `## Claude Session Notes` (or a heading the user specifies). Do not overwrite existing content.

## Mode 3: Daily Roundup

Automatically gather signals from multiple data sources to compile a comprehensive daily note. This replaces the need to manually resume each Claude session.

### Trigger Words
"roundup", "recap", "what did I do today", "end of day", "EOD notes", "daily summary"

### Data Sources

Gather data from **all** of the following sources. Run the collection commands in parallel where possible.

#### 1. ZSH History
Extract today's shell commands to infer projects, repos, and tasks worked on.
```bash
today_start=$(date -j -f '%Y-%m-%d %H:%M:%S' "$(date +%Y-%m-%d) 00:00:00" +%s)
awk -v start="$today_start" -F'[:;]' '/^:/ { ts=$2; gsub(/ /,"",ts); if (ts+0 >= start+0) { sub(/^[^;]*;/, ""); print } }' ~/.zsh_history
```
Look for:
- `cd`, `z` commands → directories/repos visited
- `git` commands → branches, commits, repos
- `ssh` commands → remote hosts accessed
- `claude` invocations → Claude sessions started
- `make`, `gradle`, `docker`, `kubectl` → build/deploy activity
- Group commands by inferred project/repo

#### 2. Claude Session Transcripts
Find today's sessions and extract topics from each.
```bash
find ~/.claude/projects -name "*.jsonl" -mtime 0 -maxdepth 2
```
For each session JSONL file, extract:
- **cwd** and **gitBranch** from the first entry (identifies the repo/project)
- **First few user messages** (identifies the topic — read via python3 one-liner)
- **Project name** from the directory path (format: `-Users-andrewwilliams-src-...-REPONAME`)

Python extraction pattern:
```python
import json, sys
with open(sys.argv[1]) as f:
    for line in f:
        obj = json.loads(line)
        if obj.get('type') == 'user':
            msg = obj.get('message', {})
            content = msg.get('content', '')
            if isinstance(content, str):
                print(content[:200])
            elif isinstance(content, list):
                for c in content:
                    if isinstance(c, dict) and c.get('type') == 'text':
                        print(c['text'][:200])
                        break
            break  # first user message is enough for topic
```

#### 3. Git Activity
Collect repos discovered from ZSH history and Claude sessions, then run:
```bash
daily-git -o json --date YYYY-MM-DD <dir1> <dir2> ...
```
Author is auto-detected per repo from `git config user.email` — no `--author` flag needed.

Each entry in the JSON output has:
- `repo` — repository name
- `dir` — absolute path
- `branch` — current branch
- `commits` — list of `{hash, subject}` (omitted if none)
- `wip` — true if uncommitted changes exist (only present for today's date)

Repos with no commits and no WIP are omitted from output automatically.

#### 4. Calendar
Fetch the day's meetings using the `daily-calendar` tool:
```bash
daily-calendar -o json --date YYYY-MM-DD
```
If no `--date` is given it defaults to today. The tool requires `DAILY_ICS_URL` to be set (or passed via `--ics-url`).

Each event in the JSON output has:
- `title` — meeting name
- `start` / `end` — RFC3339 datetimes in local time
- `status` — `"accepted"`, `"tentative"`, or omitted (organizer)
- `links` — attached notes/docs (Google Docs, Drive, etc.)

Only include meetings the user attended — the tool already filters out declined, needs-action, solo blocks, Clockwise events (lunch, breaks, focus time), and meetings moved to another day.

Include a **Meetings** section in the roundup listing each meeting and any linked notes/docs.

#### 5. Slack (Optional)
If the user asks to include Slack activity, use `rag-slack-prod` to search for recent threads. This is optional — only include if explicitly requested or if the user says "include everything".

### Roundup Output Format

Write to the work vault daily note (`Daily/YYYY/MM/YYYY-MM-DD.md`). If the file already exists, read it first and append — do not overwrite.

Structure the roundup as:

```markdown
## Daily Roundup

### Meetings
- **HH:MMam–HH:MMpm** [Meeting Title] — <1-line context or outcome if known>
  - Notes: <link if present>

### Projects
- **<repo-name>** (`<branch>`) — <1-line summary of what was done>
  - <bullet details: commits, topics explored, decisions made>
- **<repo-name>** (`<branch>`) — ...

### Claude Sessions
- <repo> — <topic from first user message, summarized>
- <repo> — <topic>

### Git Commits
- `<repo>` <branch>: <commit message>

### Shell Activity
- <Notable commands or patterns, e.g., "SSH'd into devstack", "Docker builds", "Nix config updates">

### Notes
- <Any other observations, e.g., uncommitted WIP, interrupted sessions>
```

Adapt sections as needed — omit empty sections, combine if there's little activity.

### Steps

1. Run all data collection (ZSH history, Claude sessions, git logs) in parallel.
2. Deduplicate and cross-reference — e.g., a Claude session in `oakum-federated` on branch `ajw-first-pass-authz-story` with git commits on that branch tells a single story.
3. Group by project/repo, not by data source.
4. Present a draft summary to the user and ask for confirmation before writing.
5. Write/append to the daily note following Mode 2's file handling rules.

## General Rules

- **Always read before editing.** If the target file exists, read it first.
- **Always Glob the target folder** to confirm it exists before writing.
- **Always ask the user to confirm** vault, folder, and filename before writing.
- **Always include `#claude-generated`** — either in YAML frontmatter tags (work vault) or as an inline tag (personal vault).
- Keep summaries concise and well-structured. Prefer bullet points over prose.
- **Separate top-level bullets with blank lines** for readability. Sub-bullets stay tight.
- **Use 4-space indentation** for sub-bullets (not 2-space).
- **Write in past tense.** Each top-level bullet should stand on its own — no "also", "additionally", etc.
- Use the current date (check with `date +%Y-%m-%d` if needed).
