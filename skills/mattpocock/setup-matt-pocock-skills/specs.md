# Specs

A spec (you may know it as a PRD or plan) captures one unit of work in enough detail that a fresh agent can implement it end-to-end with no further input. Specs live as local markdown under the personal doc root — never in the committed tree, never in a shared team tracker.

Assume the reader is an **unattended implementer**: it sees only this file and the codebase, gets no chance to ask questions, and implements exactly what's written — no more, no less. So a spec must be self-contained, unambiguous, and exact in scope. Whatever you leave vague, the implementer will (correctly) skip.

## Location & naming

- One markdown file per spec: `.brandonnoad/plans/<feature-slug>.md`
- `<feature-slug>` matches the feature's issue directory (`.brandonnoad/issue-tracker/<feature-slug>/`), so a spec and its implementation issues share a name.
- The spec carries **no frontmatter** — task metadata (ticket, type, title, base) is collected at task-creation time, not here.

## Format

Structure the body so a fresh agent executes it exactly, no guesswork:

- **Goal & guiding principle** — what we're building and a one-line north star. Prefer the simplest working approach; no speculative abstraction.
- **Scope** — explicit *in scope* / *out of scope* bullets. The implementer won't re-scope or add anything the spec doesn't call for.
- **Background the implementer needs** (optional) — the one or two hard-won, load-bearing facts that make the changes make sense: a constraint the planning surfaced, why the obvious approach fails, a discovered fact later steps depend on. Include only when the diffs would be baffling without it (a wayfinder plan usually has exactly one); skip for self-evident work.
- **Changes, per file** — concrete: which files to create or edit, what each change is, key function/type names and signatures, how they wire together. **Reference real paths.** Unlike a durable product spec, this plan is implemented immediately and then discarded, so concrete paths don't go stale — spell them out. Carry forward any prototypes or resolved designs the planning produced.
- **Verification / acceptance criteria** — how to confirm it works: tests to add or run, behaviour to observe. A reviewer checks the diff against these first.
- **Risks / edge cases** — what the implementer must handle rather than assume.
- **Accepted tradeoffs / non-goals** — decisions consciously made and things deliberately not done, so neither the implementer nor the reviewer re-litigates them.

If a decision is genuinely still open, **call it out explicitly** in the spec rather than burying an assumption the implementer can't see.

## When a skill says "publish the spec"

Write the spec to `.brandonnoad/plans/<feature-slug>.md`, creating the `plans/` directory if needed, following the format above.

## When a skill says "find the spec"

Read `.brandonnoad/plans/<feature-slug>.md`. The user will normally pass the feature slug or the path directly; otherwise infer the slug from the branch name or feature under discussion.
