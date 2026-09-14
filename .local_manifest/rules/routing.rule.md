# Routing Guide

Single source of truth for discovering documents that live under
`.local_manifest/`. Maps a task to the **specific** reference, skill, plan,
learning record, or finding that covers it.

The other routing file is
[`.team_manifest/rules/routing.rule.md`](../../.team_manifest/rules/routing.rule.md)
(rules, ADRs, actions, personas, backlog).

> **How to use this file:** Scan the tables for the row that matches your task,
> then open only the file it names. Replace the example rows below with the real
> documents in your repository as you add them.

**Context discipline:** Do not bulk-read the manifest. Open a specific file
**only when the current task touches its domain.** ADRs are the authority;
reference docs explain mechanics. ADRs > reference notes.

For project-wide mandates, see the root [`AGENTS.md`](../../AGENTS.md). For
project-wide terminology, see
[`terms.rule.md`](../../.team_manifest/rules/terms.rule.md). Placement rules:
[`manifest-structure.rule.md`](../../.team_manifest/rules/manifest-structure.rule.md).

## Task → Reference (mechanics)

Pair with an ADR from the team routing file when implementation detail is
required:

- _(coding example)_ How the example subsystem is wired and configured → [`reference/example-subsystem.ref.md`](../reference/example-subsystem.ref.md)
- _(add your real mechanics docs here as `*.ref.md` files)_

## Task → Skill (multi-step procedures)

Manifest skills:

- Create a new GitHub repo with README, license, and first push → [`skills/create-github-repo`](../skills/create-github-repo/SKILL.md)
- Apply this template to a code repo in the workspace → [`skills/apply-manifest-template`](../skills/apply-manifest-template/SKILL.md)
- Bring recent template updates into a code repo that already has a manifest → [`skills/sync-manifest-template`](../skills/sync-manifest-template/SKILL.md)
- One-time move from the legacy single `.agents/` tree to `.team_manifest/` + `.local_manifest/` + shim; repairs addresses after the user's manual split → [`skills/migrate-manifest-layout`](../skills/migrate-manifest-layout/SKILL.md)
- Grill a large task into a high-level phased master plan → [`skills/grill-to-master`](../skills/grill-to-master/SKILL.md)
- Grill the user about a plan, then write a spec into the target repo's `plans/` → [`skills/grill-to-spec`](../skills/grill-to-spec/SKILL.md)
- Turn a spec into a Cursor-style implementation plan without acceptance criteria → [`skills/spec-to-plan`](../skills/spec-to-plan/SKILL.md)
- Add plan-derived red tests plus behavioral and narrative acceptance criteria → [`skills/plan-to-criteria`](../skills/plan-to-criteria/SKILL.md)
- Implement a detailed plan, make its red tests green, and prove every criterion → [`skills/implement-plan`](../skills/implement-plan/SKILL.md)
- Archive one user-confirmed completed task's plan, spec, and eligible initial plan → [`skills/archive-plan`](../skills/archive-plan/SKILL.md)
- Wrap up a completed task: archive plus create/update reference docs for non-trivial design → [`skills/wrap-up-plan`](../skills/wrap-up-plan/SKILL.md)
- Diagnose and fix a user-identified issue with runtime evidence and temporary instrumentation → [`skills/debug-agent`](../skills/debug-agent/SKILL.md)
- Review uncommitted changes for bugs, architecture flaws, and introduced technical debt without editing files → [`skills/review-changes`](../skills/review-changes/SKILL.md)
- _(coding example)_ Add a new module end-to-end → [`skills/example-add-module`](../skills/example-add-module/SKILL.md)

_(add your real runbooks here under `skills/<name>/SKILL.md`)_

## Task → Learning (teach session records)

- Record or resume a `teach` skill session → the state is kept under [`learning`](../learning) and is managed by "teach" skill only.

## Task → Findings (analysis & investigation records)

- Record a finding or resume an analysis/investigation (data analysis, perf dig, root-cause) → [`findings/README.md`](../findings/README.md)

## Task → Plan (multi-step work across sessions)

- _(example)_ Track a single feature across multiple sessions → [`plans/example-feature.planning.md`](../plans/example-feature.planning.md)
- Small-task and epic planning lifecycle → [`reference/planning-flow.ref.md`](../reference/planning-flow.ref.md)
- Planning file layout and source-of-truth flow → [`manifest-structure.rule.md`](../../.team_manifest/rules/manifest-structure.rule.md#plans)
- _(template-only example)_ See an epic split into an initial idea, master plan,
  spec, and detailed plan → [`plans/example-epic/`](../plans/example-epic/)
- Important:
  - For simple work, save the descriptive `*.spec.md` and matching
    `*.planning.md` directly under `plans/`.
  - For an epic or big task, use one dedicated subdirectory under `plans/` for
    its `*-initial.md`, `*.master.md`, specs, and detailed `*.planning.md`
    plans.
  - Acceptance criteria live in an independent section of the detailed plan.
    They are added by `plan-to-criteria`, not by `grill-to-spec` or
    `spec-to-plan`.
  - When the user asks to continue or edit planning work, search the full
    `plans/` tree, regardless of the agent's default plan directory.
  - Completed task artifacts may be moved to `plans/archive/` only by the
    confirmation-gated `archive-plan` or `wrap-up-plan` workflow. Master plans
    remain active.
  - The `plans/example-epic/` directory belongs only to this template. Do not
    copy it into a target repository.
