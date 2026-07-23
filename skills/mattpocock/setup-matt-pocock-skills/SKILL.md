---
name: setup-matt-pocock-skills
description: Configure this repo for the engineering skills — set up the personal doc root, issue tracker, triage label vocabulary, and domain doc layout. Run once per worktree before first use of the other engineering skills.
disable-model-invocation: true
---

# Setup Matt Pocock's Skills

Scaffold the per-repo configuration that the engineering skills assume. Everything these skills write lives under a **personal doc root** — a `.brandonnoad/` symlink that points into the repo's shared git dir — so nothing lands in the committed tree your teammates share:

- **Doc root** — `.brandonnoad/` → `<git-common-dir>/brandonnoad/`, shared across worktrees, excluded via `.git/info/exclude`
- **Issue tracker** — always local markdown: issues live under `.brandonnoad/issue-tracker/`, specs (PRDs or plans) under `.brandonnoad/plans/`. Nothing goes to a shared team tracker.
- **Triage labels** — the strings used for the five canonical triage roles
- **Domain docs** — where `.brandonnoad/CONTEXT.md` and ADRs live, and the consumer rules for reading them

This is a prompt-driven skill, not a deterministic script. Explore, present what you found, confirm with the user, then write.

## Process

### 1. Create the doc root

Before anything else, create the personal doc root so every later write has somewhere to go. The helper script ships in this skill's folder, but it must run with the **target project as the working directory** — it resolves the repo from `git rev-parse`, so it targets whichever project you're in whether this skill is installed in the project or globally (`~/.claude/skills/`). Claude Code gives you this skill's base directory; invoke the script by its absolute path from the project root (idempotent, safe to re-run in every worktree):

```bash
bash "<this-skill-dir>/scripts/link-docroot.sh"   # cwd must be the target project
```

Do **not** `cd` into the skill folder to run it — that would resolve the wrong git repo and point the symlinks at the wrong place.

It creates `<git-common-dir>/brandonnoad/`, symlinks `.brandonnoad` → it at the worktree root, creates a gitignored `CLAUDE.local.md` → `.brandonnoad/CLAUDE.md` symlink (Claude Code auto-loads it), and adds both `.brandonnoad` and `CLAUDE.local.md` to `<git-common-dir>/info/exclude`. Because the target is the shared git dir, every worktree that runs this points at the same files. Nothing is committed and teammates never see it.

### 2. Explore

Look at the current repo to understand its starting state. Read whatever exists; don't assume:

- `.brandonnoad/config/` — does this skill's prior output already exist?
- `.brandonnoad/CONTEXT.md` and `.brandonnoad/CONTEXT-MAP.md`
- `.brandonnoad/adr/` and any `.brandonnoad/context/*/adr/` directories
- `.brandonnoad/issue-tracker/` and `.brandonnoad/plans/` — sign the local-markdown workflow is already in use
- Is the `triage` skill installed? (a `triage` skill folder alongside this one, or `triage` in your available skills.) This decides whether Section B runs at all.
- Monorepo signals — a `pnpm-workspace.yaml`, a `workspaces` field in `package.json`, or a populated `packages/*` with its own `src/`. Present only in a genuinely large multi-package repo; their absence means single-context, which is almost every repo.

### 3. Present findings and ask

Summarise what's present and what's missing. Then take the sections in order — one section, one answer, then the next.

Lead each section with the recommended answer so the user can accept it in a word. Give a one-line explainer only when the choice genuinely branches; skip the section entirely when exploration already settled it (Section B when `triage` isn't installed, Section C when there's no monorepo).

**Section A — Issue tracker.** No choice to make: this fork always uses the **local-markdown** workflow, so work never lands in a shared team tracker. Issues live as files under `.brandonnoad/issue-tracker/<feature>/` and specs (PRDs or plans) as `.brandonnoad/plans/<feature>.md`. Write `.brandonnoad/config/issue-tracker.md` from the local template without asking.

**Section B — Triage label vocabulary.** Skip this section entirely if the `triage` skill isn't installed (exploration told you) — an uninstalled skill needs no labels.

If it is installed, ask exactly one question:

> Do you want to keep the default triage labels? (recommended: **yes**)

The defaults are the five canonical roles, each label string equal to its name: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. On **yes**, write them as-is. Only if the user says no — usually because their tracker already uses other names (e.g. `bug:triage` for `needs-triage`) — collect the overrides so `triage` applies existing labels instead of creating duplicates.

**Section C — Domain docs.** Default to **single-context** — one `.brandonnoad/CONTEXT.md` + `.brandonnoad/adr/`. This fits almost every repo; write it without asking.

Offer **multi-context** — a `.brandonnoad/CONTEXT-MAP.md` pointing to per-context `.brandonnoad/context/<name>/CONTEXT.md` files — only when exploration found monorepo signals. Then confirm which layout they want.

### 4. Confirm and write

Show the user a draft of:

- The contents of `.brandonnoad/config/issue-tracker.md`, `.brandonnoad/config/domain.md`, and `.brandonnoad/config/triage-labels.md` (the last only when `triage` is installed)
- The `.brandonnoad/CLAUDE.md` overview (see below)

Let them edit before writing. Then write everything under the doc root:

Config docs, using the seed templates in this skill folder as a starting point:

- [issue-tracker-local.md](./issue-tracker-local.md) → `.brandonnoad/config/issue-tracker.md` — local-markdown issues + wayfinding
- [specs.md](./specs.md) → `.brandonnoad/config/specs.md` — where specs (PRDs or plans) live and how they're named
- [triage-labels.md](./triage-labels.md) → `.brandonnoad/config/triage-labels.md` — label mapping (only if `triage` is installed)
- [domain.md](./domain.md) → `.brandonnoad/config/domain.md` — domain doc consumer rules + layout

Then write a short overview at `.brandonnoad/CLAUDE.md`. `scripts/link-docroot.sh` symlinks the repo-root `CLAUDE.local.md` to this file, so Claude Code auto-loads it every session — personal to you, gitignored, shared across worktrees, never in the committed tree. It gives a fresh session the layout at a glance:

```markdown
## Agent skills

### Issue tracker

[one-line summary of where issues are tracked]. See `.brandonnoad/config/issue-tracker.md`.

### Specs

Specs (PRDs or plans) live as `.brandonnoad/plans/<feature-slug>.md`. See `.brandonnoad/config/specs.md`.

### Triage labels

[one-line summary of the label vocabulary]. See `.brandonnoad/config/triage-labels.md`.

### Domain docs

[one-line summary of layout — "single-context" or "multi-context"]. See `.brandonnoad/config/domain.md`.
```

Include the `### Triage labels` sub-block, and write `.brandonnoad/config/triage-labels.md`, only when `triage` is installed and Section B ran. When it isn't, both are omitted.

**Do not edit the repo's committed `CLAUDE.md` or `AGENTS.md`.** The engineering skills read their config from the fixed `.brandonnoad/config/*` paths directly, so no pointer in a shared, committed file is needed — keeping the team's tree untouched. The overview above lives inside the excluded doc root and reaches your session only through the gitignored `CLAUDE.local.md` symlink.

### 5. Done

Tell the user the setup is complete and which engineering skills will now read from these files. Mention they can edit `.brandonnoad/config/*.md` and `.brandonnoad/CLAUDE.md` directly later — re-running this skill is only necessary if they want to switch issue trackers or restart from scratch. In a new worktree, re-run `scripts/link-docroot.sh` (step 1) to recreate the `.brandonnoad` and `CLAUDE.local.md` symlinks pointing at the same shared files.
