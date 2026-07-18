# Planning Flow Reference

This reference defines how an idea moves from user intent to verified
implementation. Each stage has one job. Later stages may read earlier files,
but they must not silently rewrite them.

## File roles

| File | Owner | Purpose |
| --- | --- | --- |
| `*.spec.md` | User, with `grill-to-spec` | Plain-language intended behavior and scenarios |
| `*.plan.md` | `spec-to-plan` | Cursor-style implementation steps and technical approach |
| `## Acceptance criteria` in `*.plan.md` | `plan-to-criteria` | Complete, verifiable proof that the spec was implemented |
| `*-initial.md` | User | Starting intent for an epic |
| `*-master.plan.md` | `grill-to-master` | High-level epic roadmap, architecture, and independent phases |

The spec says **what should happen**. The detailed plan says **how to build
it**. Acceptance criteria say **how to prove it works**. Do not merge these
roles into one document stage.

## Small tasks

1. The user gives `grill-to-spec` a plain task definition. The skill asks
   focused questions and writes a human-readable `plans/<topic>.spec.md`.
2. `spec-to-plan` researches the repo and writes
   `plans/<topic>.plan.md` in Cursor Plan Mode style. At this point the plan has
   implementation steps but no formal acceptance criteria.
3. `plan-to-criteria` reads both files, studies the existing test setup, and
   adds or updates tests where the repository already supports them. It then
   adds a standalone `## Acceptance criteria` section to the plan while leaving
   the rest of the plan unchanged.
4. `implement-plan` follows the plan, updates applicable task checkboxes, and
   runs every acceptance check. It fixes the implementation and retries until
   all criteria pass or a real blocker needs user input.

## Epics

1. The user gives `grill-to-master` a plain explanation of the intended epic.
   The skill preserves that intent in `<epic>-initial.md` and produces
   `<epic>-master.plan.md` in a dedicated `plans/<epic>/` directory.
2. The master plan contains only the overall outcome, high-level requirements,
   high-level architecture, and a phased roadmap. Each phase must be small
   enough for one spec and one detailed plan, and independent enough to
   implement without taking on later phases.
3. For one phase, `grill-to-spec` writes `<phase>.spec.md` in the epic directory.
4. `spec-to-plan`, `plan-to-criteria`, and `implement-plan` run as they do for a
   small task. The detailed plan and spec stay inside the epic directory.
5. After all acceptance criteria pass, `implement-plan` may mark only the
   matching phase complete in the master plan. It may read the rest of the
   master plan for context, but must not implement or edit other phases.

## Change boundaries

- `grill-to-spec` does not design the implementation or write acceptance
  criteria.
- `spec-to-plan` does not edit the spec or add acceptance criteria.
- `plan-to-criteria` avoids changing the existing plan body. It owns only the
  acceptance section and the tests it adds or updates.
- `implement-plan` avoids changing specs and plan prose. It may update plan
  task status and, for an epic, the matching master-plan phase status.
- If any stage finds an obvious error in an earlier source file, it explains
  the problem and gets user approval before changing that file.
