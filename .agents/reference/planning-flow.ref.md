# Planning Flow Reference

This reference defines how an idea moves from user intent to verified
implementation. Each stage has one job. Later stages may read earlier files,
but they must not silently rewrite them.

## File roles

| File | Owner | Purpose |
| --- | --- | --- |
| `*.spec.md` | User, with `grill-to-spec` | Plain-language intended behavior and scenarios |
| `*.planning.md` | `spec-to-plan` | Cursor-style implementation steps and technical approach |
| `## Acceptance criteria` in `*.planning.md` | `plan-to-criteria` | Plan-derived test contract plus behavioral, narrative, and final proof requirements |
| `*-initial.md` | User | Starting intent for an epic |
| `*.master.md` | `grill-to-master` | High-level epic roadmap, architecture, and independent phases |

The spec says **what should happen**. The detailed plan says **how to build
it**. Acceptance criteria say **how to prove it works**. Do not merge these
roles into one document stage.

Production readability, performance, design integrity, code size, and execution
speed must never be compromised for unit tests or coverage. Do not change
production code solely to simplify testing; record alternative proof and
residual coverage gaps when unit testing is impractical.

## Small tasks

1. The user gives `grill-to-spec` a plain task definition. The skill asks
   focused questions and writes a human-readable `plans/<topic>.spec.md`.
2. `spec-to-plan` researches the repo and writes
   `plans/<topic>.planning.md` in Cursor Plan Mode style. At this point the plan has
   implementation steps but no formal acceptance criteria. 
3. `plan-to-criteria` reads both files, studies the existing test setup, and
   classifies the work. For a normal change it writes tests for the planned
   behavior, confirms they fail because implementation is missing, and records
   that red state. For a redesign that makes all or effectively all relevant
   unit tests obsolete, it skips pre-implementation test authoring. It
   records per-behavior production-integrity fallbacks when unit tests would
   require test-only production changes, preserving the normal-change
   classification and testing the remaining behavior. Each fallback names
   alternative proof, expected results, and residual risk. It
   likewise skips test authoring when no suitable test infrastructure exists
   rather than adding an unapproved framework. It then adds a standalone
   `## Acceptance criteria` section containing the test strategy, behavioral
   criteria, narrative/design requirements, and final validations while
   leaving the rest of the plan unchanged.
4. `implement-plan` follows the plan. For a normal change with red tests it first
   reproduces the intentional test failures, then implements required production
   behavior until those tests pass. It executes the specified alternative checks
   for production-integrity fallbacks and reviews production changes for
   test-only modifications. For a
   test-invalidating redesign it honors the test-authoring skip and proves the
   narrative and other validation criteria. It updates applicable task
   checkboxes only after every required acceptance check passes.
5. After implementation finishes and the user confirms the task is complete,
   `archive-plan` may move that task's completed plan and matching spec to
   `plans/archive/`. Prefer `wrap-up-plan` when the shipped design should also
   be captured or refreshed in `reference/*.ref.md`.

## Epics

1. The user gives `grill-to-master` a plain explanation of the intended epic.
   The skill preserves that intent in `<epic>-initial.md` and produces
   `<epic>.master.md` in a dedicated `plans/<epic>/` directory.
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
6. After the user confirms phase completion, `archive-plan` may archive only
   that phase's detailed plan and matching spec. Prefer `wrap-up-plan` when the
   phase's design should also be captured or refreshed in `reference/`. Either
   skill leaves the epic initial idea, master plan, other phases, and every
   unfinished file active.

## Change boundaries

- `grill-to-spec` does not design the implementation or write acceptance
  criteria.
- `spec-to-plan` does not edit the spec or add acceptance criteria.
- `plan-to-criteria` avoids changing the existing plan body. It owns only the
  acceptance section and pre-implementation tests derived from planned
  behavior. It does not add tests merely to characterize current code, and it
   skips test authoring for test-invalidating redesigns. It never changes
   production code to enable tests and records per-behavior alternatives where
   the production-integrity rule prevents unit proof.
- `implement-plan` avoids changing specs, plan prose, criteria, and
   plan-derived tests. It implements required behavior to make the red tests green,
  validates narrative/design criteria, and may update plan task status and, for
  an epic, the matching master-plan phase status.
   It may correct a test implementation that demonstrably contradicts unchanged
   requirements, with evidence and a focused rerun. Changes to intended behavior,
   test strategy, coverage gates, or acceptance criteria require user approval.
   Conflicting mandatory gates remain blockers, not permission for test-only
   production changes or silent reductions in verification.
- `archive-plan` runs only after implementation and user confirmation. It moves
   one completed task's eligible planning artifacts without moving master plans,
   unrelated files, or anything with unfinished work.
- `wrap-up-plan` is the same archive closeout plus a documentation pass: create
   or update a `reference/*.ref.md` when the finished design is non-trivial and
   not already documented; skip when capture would not help future tasks.
- If any stage finds an obvious error in an earlier planning source file, it
   explains the problem and gets user approval before changing that file.
