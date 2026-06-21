# Routing Guide

Single source of truth for discovering manifest documents. Maps a task to the
**specific** ADR, reference, skill, persona, plan, or action that covers it.

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
- _(example)_ Layered architecture & module boundaries → [`adr/0001-example-layered-architecture.adr.md`](../adr/0001-example-layered-architecture.adr.md)
- _(add your real decisions here as `*.adr.md` files)_

## Task → Reference (mechanics)

Pair with the ADR above only when implementation detail is required:

- _(example)_ How the example subsystem is wired and configured → [`reference/example-subsystem.ref.md`](../reference/example-subsystem.ref.md)
- _(add your real mechanics docs here as `*.ref.md` files)_

## Task → Skill (multi-step procedures)

- Apply this template to another repo in the workspace → [`skills/apply-manifest-template`](../skills/apply-manifest-template/SKILL.md)
- _(example)_ Add a new module end-to-end → [`skills/example-add-module`](../skills/example-add-module/SKILL.md)
- _(add your real runbooks here under `skills/<name>/SKILL.md`)_

## Task → Action (one-step checks)

- _(example)_ Verify docs match code before declaring done → [`actions/verify-docs-in-sync.md`](../actions/verify-docs-in-sync.md)

## Specialized agents

Defined in `personas/*.agent.md`:

- `reviewer` — pre-commit reviewer focused on safety, correctness, and decision
  compliance → [`personas/reviewer.agent.md`](../personas/reviewer.agent.md)
- `manifester` — manifest keeper who writes and fixes `.agents/` docs in plain
  English → [`personas/manifester.agent.md`](../personas/manifester.agent.md)

## Plans & actions

- Multi-session plans live in `plans/`. The canonical backlog is
  [`plans/backlog.plan.md`](../plans/backlog.plan.md).
- One-step procedures live in `actions/` (e.g.
  [`actions/verify-docs-in-sync.md`](../actions/verify-docs-in-sync.md)).
