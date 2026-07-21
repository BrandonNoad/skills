# Customizations vs upstream

These skills are forked from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT).
The only change from upstream is **where the skills read and write docs**. Behavior,
prompts, and structure are otherwise untouched, so re-syncing from upstream is mostly a
matter of re-applying the path remapping below.

## The one idea

Everything these skills write goes under a single **personal doc root** instead of the
committed tree, so a teammate's repo stays clean:

```
.brandonnoad            ->  <git-common-dir>/brandonnoad     (symlink, per worktree)
CLAUDE.local.md         ->  .brandonnoad/CLAUDE.md           (symlink, per worktree)
```

- `.brandonnoad/` is a symlink into the repo's **shared git dir** (`git rev-parse
  --git-common-dir` returns the main `.git` from any worktree), so every worktree shares
  the same files — the same pattern as `.plans` in grower-gpt.
- Both symlinks are excluded via `<git-common-dir>/info/exclude` (per-repo, uncommitted,
  invisible to teammates) — not a global gitignore and not the committed `.gitignore`.
- `CLAUDE.local.md` is a Claude Code "local instructions" file, auto-loaded every session.
  Pointing it at `.brandonnoad/CLAUDE.md` gives you a personal, gitignored, worktree-shared
  memory file without touching the shared `CLAUDE.md`.

`setup-matt-pocock-skills/scripts/link-docroot.sh` creates all of this idempotently. Run it
once per worktree (setup step 1 does it for you).

## Path remapping (upstream → fork)

| Upstream | Fork |
|---|---|
| root `CONTEXT.md` | `.brandonnoad/CONTEXT.md` |
| `docs/adr/` | `.brandonnoad/adr/` |
| root `CONTEXT-MAP.md` | `.brandonnoad/CONTEXT-MAP.md` |
| `src/<ctx>/CONTEXT.md`, `src/<ctx>/docs/adr/` | `.brandonnoad/context/<ctx>/CONTEXT.md`, `.brandonnoad/context/<ctx>/adr/` |
| `docs/agents/{issue-tracker,domain,triage-labels}.md` | `.brandonnoad/config/{issue-tracker,specs,domain,triage-labels}.md` |
| `.scratch/` (local issues) | `.brandonnoad/issue-tracker/` |
| specs merged under the feature's tracker dir (`.scratch/<feature>/spec.md`) | their own tree: `.brandonnoad/plans/<feature-slug>.md` |
| `## Agent skills` block written into shared `CLAUDE.md`/`AGENTS.md` | overview written to `.brandonnoad/CLAUDE.md`, surfaced via the `CLAUDE.local.md` symlink |

## Behavioral changes worth noting

1. **Local markdown only.** Upstream `setup` offers GitHub / GitLab / local / other trackers
   and defaults to GitHub. This fork removes the remote options entirely — the GitHub and
   GitLab seed templates are deleted, and `setup` always writes the local-markdown workflow.
   No work is ever published to a shared team tracker. Issues live under
   `.brandonnoad/issue-tracker/`, specs under `.brandonnoad/plans/`.
2. **No shared-file edits.** Upstream `setup` edits the repo's committed `CLAUDE.md` /
   `AGENTS.md` to add an `## Agent skills` pointer block. This fork does **not** touch shared
   files. The forked skills read config from the fixed `.brandonnoad/config/*` paths directly,
   so the shared pointer is unnecessary. The overview lives in the doc root and reaches your
   session only through `CLAUDE.local.md`.

## Files changed

- `setup-matt-pocock-skills/SKILL.md` — doc-root creation step; all output paths rebased;
  always local-markdown (no tracker choice); no longer edits shared `CLAUDE.md`/`AGENTS.md`.
- `setup-matt-pocock-skills/scripts/link-docroot.sh` — **new**; creates the symlinks + exclude.
- `setup-matt-pocock-skills/issue-tracker-github.md`, `issue-tracker-gitlab.md` — **deleted**.
- `setup-matt-pocock-skills/issue-tracker-local.md` — `.scratch/` → `.brandonnoad/issue-tracker/`;
  specs conventions removed (now their own config).
- `setup-matt-pocock-skills/specs.md` — **new**; spec location + naming, written to
  `.brandonnoad/config/specs.md`, parallel to the other config docs.
- `setup-matt-pocock-skills/domain.md` — consumer paths rebased.
- `domain-modeling/SKILL.md`, `CONTEXT-FORMAT.md`, `ADR-FORMAT.md` — CONTEXT/ADR/context paths rebased.
- `code-review/SKILL.md` — config path rebased; spec search points at `.brandonnoad/plans/`.
- `to-spec/SKILL.md` — writes the spec to `.brandonnoad/plans/<feature-slug>.md`.
- `wayfinder/`, `grill-with-docs/` — unchanged; they already indirect through the tracker/domain
  docs above, so no hardcoded paths to fix.
