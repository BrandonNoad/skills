# Issue tracker: Local Markdown

All work for this repo is tracked as local markdown under the personal doc root — nothing goes to a shared team tracker. Issues live under `.brandonnoad/issue-tracker/`; specs (you may know a spec as a PRD) live under `.brandonnoad/specs/`.

## Specs

- One markdown file per spec: `.brandonnoad/specs/<feature-slug>.md`
- `<feature-slug>` matches the feature's issue directory (below), so a spec and its implementation issues share a name.

## Issues

- One feature per directory: `.brandonnoad/issue-tracker/<feature-slug>/`
- Implementation issues are one file per ticket at `.brandonnoad/issue-tracker/<feature-slug>/issues/<NN>-<slug>.md`, numbered from `01` — never a single combined tickets file
- Triage state is recorded as a `Status:` line near the top of each issue file (see `triage-labels.md` for the role strings)
- Comments and conversation history append to the bottom of the file under a `## Comments` heading

## When a skill says "publish to the issue tracker"

Create a new issue file under `.brandonnoad/issue-tracker/<feature-slug>/` (creating the directory if needed). A spec goes to `.brandonnoad/specs/<feature-slug>.md` instead.

## When a skill says "fetch the relevant ticket"

Read the file at the referenced path. The user will normally pass the path or the issue number directly.

## Wayfinding operations

Used by `/wayfinder`. The **map** is a file with one **child** file per ticket.

- **Map**: `.brandonnoad/issue-tracker/<effort>/map.md` — the Notes / Decisions-so-far / Fog body.
- **Child ticket**: `.brandonnoad/issue-tracker/<effort>/issues/NN-<slug>.md`, numbered from `01`, with the question in the body. A `Type:` line records the ticket type (`research`/`prototype`/`grilling`/`task`); a `Status:` line records `claimed`/`resolved`.
- **Blocking**: a `Blocked by: NN, NN` line near the top. A ticket is unblocked when every file it lists is `resolved`.
- **Frontier**: scan `.brandonnoad/issue-tracker/<effort>/issues/` for files that are open, unblocked, and unclaimed; first by number wins.
- **Claim**: set `Status: claimed` and save before any work.
- **Resolve**: append the answer under an `## Answer` heading, set `Status: resolved`, then append a context pointer (gist + link) to the map's Decisions-so-far in `map.md`.
