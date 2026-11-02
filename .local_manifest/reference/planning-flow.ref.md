# Planning Flow Reference

This reference defines how an idea moves from user intent to verified
implementation. Each stage has one job. Later stages may read earlier files,
but they must not silently rewrite them.

## File roles

| File | Owner | Purpose |
| --- | --- | --- |
| `*.spec.md` | User, with `grill-to-spec` | Plain-language intended behavior and scenarios |
| `*.planning.md` | `spec-to-plan` | Cursor-style implementation steps and technical approach |
| `*.criteria.md` (highly recommended, not required) | `plan-to-criteria` | High-level behavioral and narrative requirements plus integration-first test contract and final proof |
| `*.manager.md` (manager runs only) | `manager` | Stage checkpoint, review evidence, pending human checks, minor findings, and archive/reopen paths |
| `*-initial.md` | User | Starting intent for an epic |
| `*.master.md` | `grill-to-master` | High-level epic roadmap, architecture, and independent phases |

The spec says **what should happen**. The detailed plan says **how to build
it**. Acceptance criteria say **how to prove it works**. Do not merge these
roles into one document stage.

Running `plan-to-criteria` before implementation is highly recommended and is
the normal flow. The user may choose to skip it; an absent criteria file does
not block implementation or wrap-up and need not be created to proceed.

Production readability, performance, design integrity, code size, and execution
speed must never be compromised for unit tests or coverage. Do not change
production code solely to simplify testing; record alternative proof and
residual coverage gaps when unit testing is impractical.

Acceptance evidence is prioritized as complete narrative and design criteria,
then integration tests when suitable infrastructure exists, then unit tests.
Unit tests are selective gap-fillers, not required merely because unit-test
infrastructure exists. Add them only for important gaps not adequately covered
by integration or higher-level proof. If a selected unit test is premature
because its interface is unclear, `plan-to-criteria` records the required cases
and outcomes for `implement-plan` instead of guessing the production contract.

## Small tasks

These are the standalone stage rules. For an orchestrated run, apply the
[Managed completion](#managed-completion) handoff and closeout exceptions.

1. The user gives `grill-to-spec` a plain task definition. The skill asks
   focused questions and writes a human-readable `plans/<topic>.spec.md`.
2. `spec-to-plan` researches the repo and writes
   `plans/<topic>.planning.md` in Cursor Plan Mode style. At this point the plan has
   implementation steps but no formal acceptance criteria. 
3. The highly recommended `plan-to-criteria` stage reads both files, studies the existing test setup, and
   classifies the work. For a normal change it completes the narrative/design
   criteria first, writes integration tests when suitable infrastructure
   exists, and adds focused unit tests only for important remaining proof gaps
   with clear boundaries. It confirms
   authored tests fail because implementation is missing and records that red
   state. When a module interface or function signature is too unclear for a
   meaningful unit test, it records an implement-plan note containing the
   required cases, desired outcomes, unresolved decision, interim proof, and
   residual gap. For a redesign that makes all or effectively all relevant
   unit tests obsolete, it skips pre-implementation test authoring. It
   records per-behavior production-integrity fallbacks when unit tests would
   require test-only production changes, preserving the normal-change
   classification and testing the remaining behavior. Each fallback names
   alternative proof, expected results, and residual risk. It
   likewise skips test authoring when no suitable test infrastructure exists
   rather than adding a framework. It writes `plans/<topic>.criteria.md` beside
   the plan, replacing only the `.planning.md` suffix. The file links to the
   source plan and spec and contains an `## Acceptance criteria` section with
   high-level behavioral and narrative/design requirements first, then the
   supporting test contract and final validations. The entire planning file
   remains byte-for-byte unchanged.
4. `implement-plan` reads the plan and sibling criteria file if present. If the
   criteria file does not exist, it ignores it and proceeds without requiring
   `plan-to-criteria`, validating the plan with relevant existing tests, commands,
   and behavioral checks instead.
   For a normal change with red tests it first
   reproduces the intentional test failures, then implements required production
   behavior until those tests pass. After resolving an interface named in a
   deferred unit-test note, it adds the specified unit cases against the settled
   boundary and confirms their desired outcomes, unless the boundary remains
   unsuitable under the production-integrity rule. It executes the specified
   alternative checks and reviews production changes for test-only
   modifications. For a
   test-invalidating redesign it honors the test-authoring skip and proves the
   narrative and other validation criteria. It updates applicable task
   checkboxes only after every required acceptance check passes.
5. After implementation finishes, `wrap-up-plan` may move that task's completed
   plan, matching spec, and criteria file when present to `plans/archive/`, and captures or refreshes a
   `reference/*.ref.md` when the shipped design is worth retaining.

## Epics

The standalone epic lifecycle follows. Manager handles only one selected phase
and uses the [Managed completion](#managed-completion) exceptions below.

1. The user gives `grill-to-master` a plain explanation of the intended epic.
   The skill preserves that intent in `<epic>-initial.md` and produces
   `<epic>.master.md` in a dedicated `plans/<epic>/` directory.
2. The master plan contains only the overall outcome, high-level requirements,
   high-level architecture, and a phased roadmap with numbered phase IDs and
   names (for example `01-<phase-slug>: Phase 1 — <name>`). Each phase must be
   small enough for one spec and one detailed plan, and independent enough to
   implement without taking on later phases.
3. For one phase, `grill-to-spec` writes `<01-phase-slug>.spec.md` in the epic
   directory using the master plan's numbered phase ID.
4. `spec-to-plan`, the highly recommended `plan-to-criteria`, and `implement-plan` run as they do for a
   small task. The detailed plan (`<01-phase-slug>.planning.md`) and spec stay
   inside the epic directory, alongside `<01-phase-slug>.criteria.md` when created.
5. After all acceptance criteria pass, `implement-plan` may mark only the
   matching phase complete in the master plan. It may read the rest of the
   master plan for context, but must not implement or edit other phases.
6. While an epic has remaining phases, `wrap-up-plan` leaves all phase records
   active by default. It archives a completed phase plan, matching spec, and criteria only
   when the user explicitly asks to wrap up that phase. It leaves the epic
   initial idea, master plan, other phases, and every unfinished file active.
7. When every master phase is complete, `wrap-up-plan` closes the epic: it
   archives the master plan, linked initial idea, and every remaining active,
   completed phase plan, matching spec, and criteria. It does not move unrelated or
   ambiguous files; previously archived phases remain in place.

## Managed completion

The [manager skill](../skills/manager/SKILL.md) orchestrates the same stages for
one task or one named epic phase. It keeps grilling in the main agent, delegates
substantial stage work, and obtains a fresh independent review against the spec
and criteria before closeout. Its invocation authorizes stage transitions and
archival of that selected task/phase, without intermediate confirmation.

For a manager run, completion requires implemented plan work, passing required
checks executable in the agent's environment, and no unresolved severe review
finding. Two explicitly recorded exceptions do not block closeout:

- Human checks that the agent cannot perform remain **human check pending**.
  Record the reason, steps, inputs, and expected outcome in the criteria and
  sibling `<stem>.manager.md` checkpoint, or only the checkpoint if criteria
  were explicitly skipped.
- Minor independent-review findings remain reported, with evidence and impact.
  Only severe findings trigger an automatic fix-worker/review loop. A known
  failing executable acceptance check cannot be relabeled minor or human-only.

Complete the plan's task statuses and checkboxes and only the matching master
phase when applicable, then archive the task/phase and checkpoint. A completion
status means this managed delivery flow finished; it does not assert that
pending human checks passed or minor findings were fixed. Leave affected
acceptance checkboxes unchecked with explicit pending/minor annotations, and
add a visible closeout note linking the checkpoint from the plan, criteria, and
matching master phase. Never mark an unperformed check as passed. Known severe
defects and unresolved executable-check failures still block completion.

Manager phase closeout always uses **Epic phase** mode, even for the last phase:
keep the master and initial idea active and do not start another phase. A later
explicit whole-epic wrap-up may archive the epic; recorded managed exceptions
remain visible and are not converted into passing evidence.

After the user requests reopening for a failed human check, manager restores
only the archived task/phase companions, resets affected task and matching
master-phase statuses, and resumes repair and verification. Preserve the
previous evidence and do not overwrite conflicting active files.

Outside a recorded manager run, the normal completion gates below still apply.
Manager workers return blockers and questions to the main agent, which owns
user communication. Implementation returns evidence before final status updates
and scratch cleanup; manager orders those only after independent review.

Plan-local scratch cleanup is authorized by default for `implement-plan` and
manager closeout. Preserve durable evidence first, inventory the plan's scratch
directory, verify the resolved target stays within the repository's scratch
tree, and remove its disposable contents without another confirmation. Honor
an explicit request to retain them.

## Change boundaries

- `grill-to-spec` does not design the implementation or write acceptance
  criteria.
- `spec-to-plan` does not edit the spec or add acceptance criteria.
- `plan-to-criteria` leaves the entire planning file untouched. It owns only the
  sibling `*.criteria.md` file and pre-implementation tests derived from planned
  behavior. It does not add tests merely to characterize current code, and it
   skips test authoring for test-invalidating redesigns. It never changes
   production code to enable tests and records per-behavior unit-test notes and
   alternatives where an unclear interface or the production-integrity rule
   prevents pre-implementation unit proof.
- `implement-plan` avoids changing specs, plan prose, criteria, and
   plan-derived tests. It implements required behavior to make the red tests green,
  validates narrative/design criteria, and may update plan task status and, for
  an epic, the matching master-plan phase status.
   It may correct a test implementation that demonstrably contradicts unchanged
   requirements, with evidence and a focused rerun. Changes to intended behavior,
   test strategy, coverage gates, or acceptance criteria require user approval.
   Conflicting mandatory gates remain blockers, not permission for test-only
   production changes or silent reductions in verification.
- `wrap-up-plan` runs after implementation. It closes a completed task, an
  explicitly requested completed epic phase (including a manager invocation), or a fully completed epic without
  a second confirmation. It creates or updates a `reference/*.ref.md` when the
  finished design is non-trivial and not already documented; skip when capture
  would not help future tasks.
- If any stage finds an obvious error in an earlier planning source file, it
   explains the problem and gets user approval before changing that file.
  Truthful evidence, status updates, archive link repairs, and manager closeout
  notes do not change requirements and follow their explicit permissions above.
