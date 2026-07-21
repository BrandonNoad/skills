# Specs

Specs (you may know a spec as a PRD or plan) for this repo live as local markdown under the personal doc root — never in the committed tree, never in a shared team tracker.

## Conventions

- One markdown file per spec: `.brandonnoad/plans/<feature-slug>.md`
- `<feature-slug>` matches the feature's issue directory (`.brandonnoad/issue-tracker/<feature-slug>/`), so a spec and its implementation issues share a name.
- Triage state is a `Status:` line near the top of the file (see `triage-labels.md` for the role strings; `/to-spec` sets `Status: ready-for-agent`).

## When a skill says "publish the spec"

Write the spec to `.brandonnoad/plans/<feature-slug>.md`, creating the `plans/` directory if needed.

## When a skill says "find the spec"

Read `.brandonnoad/plans/<feature-slug>.md`. The user will normally pass the feature slug or the path directly; otherwise infer the slug from the branch name or feature under discussion.
