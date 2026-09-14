# Agent Manifest Template

A reusable, tool-agnostic template for an **agent manifest** — two directories
plus a discovery shim that give AI coding agents (GitHub Copilot, Cursor,
Claude, OpenCode, and others) the durable context they need to work in a
repository: decisions, mechanics, conventions, runbooks, and role definitions.

Apply this template to a repository, fill it with the project's specifics, and
agents can read durable intent instead of guessing it.

## Why a manifest?

AI agents are powerful but stateless. Without shared context they re-derive
architecture from scratch, miss hard constraints, and re-litigate settled
decisions. A manifest fixes this by giving agents a **single, organized source
of truth** that is:

- **Discoverable** — routing files map any task to the exact doc that covers it.
- **Layered** — durable *decisions* are kept apart from current *mechanics* and
  step-by-step *how-tos*, so each can change at its own pace.
- **Tool-agnostic** — the canonical content lives in `.team_manifest/` and
  `.local_manifest/`. `.agents/` is only a gitignored shim of skill symlinks.
- **Low-noise** — agents read only what a task needs, not the whole manifest.

## How it works

1. Every agent starts at the root **[`AGENTS.md`](AGENTS.md)**.
2. `AGENTS.md` sends them to
   **[`.team_manifest/rules/routing.rule.md`](.team_manifest/rules/routing.rule.md)**
   and
   **[`.local_manifest/AGENTS.md`](.local_manifest/AGENTS.md)**.
3. The routing files map the task to the one decision record, reference, guide,
   skill, persona, plan, or action that applies.
4. The agent reads only that file and acts.

## Directory layout

The canonical solo and team layouts, setup commands, entry-point templates, and
ignore rules live in
**[`.team_manifest/guides/manifest-layout.md`](.team_manifest/guides/manifest-layout.md)**.
This template repository itself uses the solo layout.

## What goes where

The full, authoritative placement rules live in
**[`.team_manifest/rules/manifest-structure.rule.md`](.team_manifest/rules/manifest-structure.rule.md)** —
this is the required guide to document types, naming, and placement.

**Decisions vs. mechanics** is the key distinction: an ADR says *we chose X
because Y* and rarely changes; a reference says *here is how X is wired today*
and changes whenever the code does.

## Planning flow

For small work, `grill-to-spec` turns plain user intent into a human-readable
behavior spec. `spec-to-plan` creates a Cursor-style implementation plan without
acceptance criteria. `plan-to-criteria` studies the test setup, writes failing
tests for the planned behavior when the change is not a test-invalidating
redesign, and adds behavioral plus narrative acceptance criteria to the plan.
`implement-plan` then implements until those tests pass and every criterion is
proved. After the user confirms completion, `archive-plan` moves only that
completed task's eligible planning artifacts to `plans/archive/`. Prefer
`wrap-up-plan` when closeout should also create or refresh a
`reference/*.ref.md` for non-trivial design.

An epic adds one stage at the front: `grill-to-master` preserves the human
initial idea and creates a high-level phased roadmap. Each phase then follows
the same spec, plan, criteria, and implementation flow in the epic's dedicated
directory. See the canonical [planning flow reference](.local_manifest/reference/planning-flow.ref.md),
the [plan structure rule](.team_manifest/rules/manifest-structure.rule.md#plans), and
the [template-only epic example](.local_manifest/plans/example-epic/). Do not copy the
example directory into target repositories.

## Getting started

### Option A — Automated (recommended)

Let an agent do the work:

1. Open **your repo** in a VS Code workspace.
2. Create the two directories and the `.agents/` shim by following
   [`apply-manifest-template/user-setup.md`](.local_manifest/skills/apply-manifest-template/user-setup.md).
3. **Add this template repo** as a second folder in the same workspace.
4. Ask the agent to run
   [`apply-manifest-template`](.local_manifest/skills/apply-manifest-template/SKILL.md).

   It studies your repo, then creates a tailored manifest (or upgrades
   an existing one) with real, project-specific content — replacing all the
   examples for you. To pull later template updates into an existing manifest,
   use the [`sync-manifest-template`](.local_manifest/skills/sync-manifest-template/SKILL.md)
   skill.

### Option B — Manual

1. **Create** `.team_manifest/` and `.local_manifest/` as in
   [`apply-manifest-template/user-setup.md`](.local_manifest/skills/apply-manifest-template/user-setup.md).
2. **Edit `AGENTS.md`** — replace the example mandates with your project's real,
   non-negotiable rules (keep the list short).
3. **Edit both routing files** — point the tables at your real documents.
4. **Replace the examples** — every folder ships with a worked example marked as
   such. Turn them into real docs or delete them once you have your own.
5. **Recreate the shim** — follow
   [`.team_manifest/guides/manifest-layout.md`](.team_manifest/guides/manifest-layout.md).
6. **Keep it in sync** — when a change makes a doc wrong, fix it in the same
   change. The [`verify-docs-in-sync`](.team_manifest/actions/verify-docs-in-sync.md)
   action and the [`manifester`](.team_manifest/personas/manifester.agent.md) persona
   help with this.

## What's included

This template ships at least one worked example in every folder so you can see
the format and the expected level of detail.

- **rules/** — all three rule files (`manifest-structure`, routing in each
  directory, `terms`).
- **adr/** — the meta-ADR (*record architecture decisions*) and a coding
  decision example.
- **reference/** — a coding subsystem example plus the canonical planning-flow
  reference.
- **guides/** — the canonical `manifest-layout.md`, plus project-specific
  `setup.md`, `commands.md`, and `notes.md`.
- **skills/** — real `apply-manifest-template` / `sync-manifest-template` /
  `migrate-manifest-layout` runbooks, plus
  [`grill-to-master`](.local_manifest/skills/grill-to-master/SKILL.md),
  [`grill-to-spec`](.local_manifest/skills/grill-to-spec/SKILL.md),
  [`spec-to-plan`](.local_manifest/skills/spec-to-plan/SKILL.md),
  [`plan-to-criteria`](.local_manifest/skills/plan-to-criteria/SKILL.md), and
  [`implement-plan`](.local_manifest/skills/implement-plan/SKILL.md), followed by
  [`archive-plan`](.local_manifest/skills/archive-plan/SKILL.md) for confirmed completed
  work or [`wrap-up-plan`](.local_manifest/skills/wrap-up-plan/SKILL.md) to archive plus
  document non-trivial design; [`debug-agent`](.local_manifest/skills/debug-agent/SKILL.md) for
  evidence-driven issue diagnosis and fixes; [`review-changes`](.local_manifest/skills/review-changes/SKILL.md)
  for read-only pre-commit reviews; plus an `example-add-module` (coding)
  example.
- **actions/** — a `verify-docs-in-sync` one-step check.
- **personas/** — a `reviewer` and a `manifester` agent.
- **plans/** — a simple example `*.planning.md` feature plan and a
  template-only `example-epic/` with `*.master.md` / `*.planning.md` examples
  that must not be copied into target repositories. The backlog lives at
  `.team_manifest/backlog.plan.md`.
- **findings/** — a README for recording reproducible analyses/investigations,
  plus an example finding.
- **learning/** — a README for recording and resuming `teach` skill sessions,
  plus an example placeholder directory.

## Principles for keeping it useful

- **One fact, one place.** Define a thing once and link to it; never copy.
- **Read narrowly.** Routing exists so agents open one file, not all of them.
- **ADRs win.** When a reference and an ADR disagree, the ADR is right and the
  reference must be fixed.
- **Plain language.** Write so a new contributor understands every line on the
  first read.

## Third-party skills (Matt Pocock)

Parts of this template pair with or adapt skills from
[Matt Pocock's *Skills For Real Engineers*](https://github.com/mattpocock/skills)
([skills.sh](https://www.skills.sh/mattpocock/skills)). Install them with the
`skills` CLI:

```sh
npx skills add mattpocock/skills
```

| This template | Matt Pocock skill | Notes |
| ------------- | ----------------- | ----- |
| [`learning/`](.local_manifest/learning/README.md) | [`teach`](https://www.skills.sh/mattpocock/skills/teach) | Session records in `learning/` pair with the `teach` skill. |
| [`grill-to-spec`](.local_manifest/skills/grill-to-spec/SKILL.md) | [`grilling`](https://www.skills.sh/mattpocock/skills/grilling), [`domain-modeling`](https://www.skills.sh/mattpocock/skills/domain-modeling) | Adapted for manifest repos: grilling loop + domain sharpening, ending in a spec in the target repo's `.local_manifest/plans/` tree. |
| [`grill-to-master`](.local_manifest/skills/grill-to-master/SKILL.md) | [`grilling`](https://www.skills.sh/mattpocock/skills/grilling) | Adapted for epic-level grilling and phased master plans. |

For the original grilling workflow without manifest/spec output, use Matt's
[`grill-me`](https://www.skills.sh/mattpocock/skills/grill-me) or
[`grill-with-docs`](https://www.skills.sh/mattpocock/skills/grill-with-docs)
skills directly.

License terms for adapted material are in
[`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md).

## License

This project is licensed under the MIT License — see [`LICENSE`](LICENSE).
Third-party material may be under separate terms; see
[`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md).
