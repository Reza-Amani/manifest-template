# Routing Guide

Single source of truth for discovering manifest documents. Maps a task to the
**specific** ADR, reference, skill, persona, plan, learning record, or action that covers it.

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
- _(operation/data example)_ Secrets, credentials & data privacy → [`operation-secrets.rule.md`](operation-secrets.rule.md)

## Task → ADR (decisions)

Read the matching ADR under `adr/` only when working in that domain:

- How and why we record decisions → [`adr/0000-record-architecture-decisions.adr.md`](../adr/0000-record-architecture-decisions.adr.md)
- _(coding example)_ Layered architecture & module boundaries → [`adr/0001-example-layered-architecture.adr.md`](../adr/0001-example-layered-architecture.adr.md)
- _(operation/data example)_ Data pipeline layering & metric ownership → [`adr/0002-operation-data-layering.adr.md`](../adr/0002-operation-data-layering.adr.md)
- _(add your real decisions here as `*.adr.md` files)_

## Task → Reference (mechanics)

Pair with the ADR above only when implementation detail is required:

- _(coding example)_ How the example subsystem is wired and configured → [`reference/example-subsystem.ref.md`](../reference/example-subsystem.ref.md)
- _(operation/data example)_ Data-source & destination connection inventory → [`reference/operation-connections.ref.md`](../reference/operation-connections.ref.md)
- _(add your real mechanics docs here as `*.ref.md` files)_

## Task → Skill (multi-step procedures)

Manifest skills for **software / development** repos:

- Apply this template to a code repo in the workspace → [`skills/apply-manifest-template`](../skills/apply-manifest-template/SKILL.md)
- Bring recent template updates into a code repo that already has a manifest → [`skills/sync-manifest-template`](../skills/sync-manifest-template/SKILL.md)
- Grill the user about a plan, then write a spec into the target repo's `plans/` → [`skills/grill-to-spec`](../skills/grill-to-spec/SKILL.md)
- _(coding example)_ Add a new module end-to-end → [`skills/example-add-module`](../skills/example-add-module/SKILL.md)

Manifest skills for **operation / data** repos:

- Apply this template to a data/ops repo in the workspace → [`skills/operation-apply-manifest-template`](../skills/operation-apply-manifest-template/SKILL.md)
- Bring recent template updates into a data/ops repo that already has a manifest → [`skills/operation-sync-manifest-template`](../skills/operation-sync-manifest-template/SKILL.md)
- _(operation/data example)_ Onboard a new data source end-to-end → [`skills/operation-add-data-source`](../skills/operation-add-data-source/SKILL.md)

_(add your real runbooks here under `skills/<name>/SKILL.md`)_

## Task → Learning (teach session records)

- Record or resume a `teach` skill session → the state is kept under [`learning`](../learning) and is managed by "teach" skill only.

## Task → Findings (analysis & investigation records)

- Record a finding or resume an analysis/investigation (data analysis, perf dig, root-cause) → [`findings/README.md`](../findings/README.md)

## Task → Action (one-step checks)

- _(example)_ Verify docs match code before declaring done → [`actions/verify-docs-in-sync.md`](../actions/verify-docs-in-sync.md)

## Task → Plan (multi-step work across sessions)

- _(example)_ Track a single feature across multiple sessions → [`plans/example-feature.plan.md`](../plans/example-feature.plan.md)
- Important:
  - when you are in the planning mode, or create a plan per user request, save the plan under `plans/` with a descriptive name and a `.plan.md` suffix. No other location is allowed for plans. 
  - When the user asks to continue or edit a plan, look for the plan under `plans/`, regardless of the default plan directory for the agent.  

## Specialized agents

Defined in `personas/*.agent.md`:

- `reviewer` — pre-commit reviewer focused on safety, correctness, and decision
  compliance → [`personas/reviewer.agent.md`](../personas/reviewer.agent.md)
- `manifester` — manifest keeper who writes and fixes `.agents/` docs in plain
  English → [`personas/manifester.agent.md`](../personas/manifester.agent.md)

## Plans & actions

- Multi-session plans live in `plans/`. The canonical backlog is
  [`plans/backlog.plan.md`](../plans/backlog.plan.md).
- Teach session records live in `learning/`. Start with
  [`learning/README.md`](../learning/README.md).
- Analysis & investigation records live in `findings/`. Start with
  [`findings/README.md`](../findings/README.md).
- One-step procedures live in `actions/` (e.g.
  [`actions/verify-docs-in-sync.md`](../actions/verify-docs-in-sync.md)).
