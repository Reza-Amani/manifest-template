# Routing Guide

Single source of truth for discovering documents that live under
`.team_manifest/`. Maps a task to the **specific** ADR, rule, persona, or
action that covers it.

The other routing file is
[`.local_manifest/rules/routing.rule.md`](../../.local_manifest/rules/routing.rule.md)
(plans, findings, learning, reference docs, and skills).

> **How to use this file:** Scan the tables for the row that matches your task,
> then open only the file it names. Replace the example rows below with the real
> documents in your repository as you add them.

**Context discipline:** Do not bulk-read the manifest. Open a specific file
**only when the current task touches its domain.** ADRs are the authority;
reference docs explain mechanics. ADRs > reference notes.

For project-wide mandates, see the root [`AGENTS.md`](../../AGENTS.md) — it is
always in context and need not be re-read here. For project-wide terminology,
see [`terms.rule.md`](terms.rule.md).

## Task → Rules

Read and follow the matching rule under `rules/` when working in that domain:

- Project-wide terminology; applies to all tasks → [`terms.rule.md`](terms.rule.md)
- Manifest structure; applies when editing manifest files → [`manifest-structure.rule.md`](manifest-structure.rule.md)

## Task → ADR (decisions)

Read the matching ADR under `adr/` only when working in that domain:

- How and why we record decisions → [`adr/0000-record-architecture-decisions.adr.md`](../adr/0000-record-architecture-decisions.adr.md)
- _(coding example)_ Layered architecture & module boundaries → [`adr/0001-example-layered-architecture.adr.md`](../adr/0001-example-layered-architecture.adr.md)
- _(add your real decisions here as `*.adr.md` files)_

## Task → Action (one-step checks)

- _(example)_ Verify docs match code before declaring done → [`actions/verify-docs-in-sync.md`](../actions/verify-docs-in-sync.md)

## Task → Guide

- Choose, create, or verify a solo/team manifest layout → [`guides/manifest-layout.md`](../guides/manifest-layout.md)
- Set up this project's tools and dependencies → [`guides/setup.md`](../guides/setup.md)
- Find this project's build, test, run, and maintenance commands → [`guides/commands.md`](../guides/commands.md)

## Specialized agents

Defined in `personas/*.agent.md`:

- `reviewer` — pre-commit reviewer focused on safety, correctness, and decision
  compliance → [`personas/reviewer.agent.md`](../personas/reviewer.agent.md)
- `manifester` — manifest keeper who writes and fixes manifest docs in plain
  English → [`personas/manifester.agent.md`](../personas/manifester.agent.md)

## Task → Backlog

- Record or pick up a future task → [`../backlog.plan.md`](../backlog.plan.md).
  This is a parking lot, not part of any planning flow; plans live in
  `.local_manifest/plans/`.
