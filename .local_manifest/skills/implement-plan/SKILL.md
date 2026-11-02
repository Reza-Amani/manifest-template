---
name: implement-plan
description: >-
  Implements a detailed `.local_manifest/plans/*.planning.md` using a Cursor Build-style
  workflow, reproduces the plan's intentional pre-implementation test failures,
  implements until those tests pass, and validates automated and narrative
  acceptance criteria. It respects the test-authoring exception recorded for
  test-invalidating redesigns and per-behavior production-integrity fallbacks.
  The spec is optional. Use when the user asks to
  "implement this plan", "build the plan", "execute this plan", or "finish
  this phase".
---





























# Implement Plan

Implement one detailed plan end to end. Running `plan-to-criteria` first is
highly recommended, but a user choice to skip it must not block implementation.
Without a sibling criteria file, proceed from the plan and validate the work
using relevant existing tests, commands, and behavioral checks; do not require
or create a criteria file. When plan-derived red tests exist, make them green by implementing required
production behavior, not by weakening the contract or adding test-only production
changes. Honor recorded alternative proof for difficult-to-unit-test behavior.
For a test-invalidating redesign, honor
the recorded pre-implementation test skip and prove the work through the
plan's other behavioral, narrative, and validation criteria.

Follow the canonical [planning flow](../../reference/planning-flow.ref.md).
When dispatched by [manager](../manager/SKILL.md), apply its
[Managed completion policy](../../reference/planning-flow.ref.md#managed-completion)
and return implementation evidence before final status updates or cleanup.

## Inputs

- **Plan (required):** one detailed `*.planning.md`. Reject a
  `*.master.md` as the implementation input.
- **Criteria (highly recommended, not required):** the sibling file obtained by replacing the plan's
  `.planning.md` suffix with `.criteria.md`. Read its `## Acceptance criteria`
  section as the acceptance contract when present. If the file does not exist,
  ignore it and proceed without running `plan-to-criteria`.
- **Spec (optional standalone, required under manager):** use the linked
  `*.spec.md` for behavioral context. The plan remains the implementation guide.
- **Master plan (epics only, optional context):** read it to identify the
  matching phase and dependencies. Do not implement other phases.
- **Manager checkpoint (managed runs):** read the supplied sibling
  `<plan-stem>.manager.md` and return evidence for that exact task or phase.
  Return blockers, questions, and helper requests to the main agent.

When a criteria file is present, its acceptance section must identify its pre-implementation test strategy:
integration-first plan-derived red tests, a justified per-behavior unit-test deferral with an
`Implement-plan unit-test note`, or an explicit test-authoring skip for a
test-invalidating redesign or unavailable test infrastructure. If it does not,
stop and recommend rerunning `plan-to-criteria`. If the plan, optional spec, or
repository contradicts itself in a way that changes scope or behavior, explain
the problem and ask the user before editing planning files.

## Ephemeral files

Put any temporary backups, baselines, comparison outputs, or other ephemeral
artifacts under `.local_manifest/scratch/<plan-stem>/`, where `<plan-stem>` is the
detailed plan filename without `.planning.md`. Never put them beside the plan
or elsewhere in the repository. Create the scratch directory only when needed,
and do not treat its contents as implementation deliverables.

Plan-local cleanup is authorized by default after durable evidence is saved.
Inventory the directory, resolve its absolute path, and verify it is the exact
plan directory within the target repository's `.local_manifest/scratch/` tree
before deleting disposable contents. Honor an explicit request to retain them.
Under manager, defer cleanup until the main agent orders closeout after
independent review.

## Protected files

- Do not edit spec text.
- Do not edit plan requirements, architecture, steps, or acceptance criteria.
- Do not edit the sibling criteria file's requirements or test contract.
- You may update plan YAML todo statuses and matching Markdown task checkboxes
  only at closeout.
- For an epic, you may update only the matching phase status and checkbox in
  the master plan, plus its permitted closeout note, after the applicable
  completion gate passes.
- You may record truthful verification evidence and acceptance-checkbox status
  without changing requirements. Under manager, final task/master status and
  scratch cleanup belong to manager after independent review. Manager may add
  closeout notes linking its checkpoint and record the exceptions allowed by
  Managed completion; pending acceptance checks stay unchecked.
- If a protected file is obviously wrong, get user approval before correcting
  its requirements. Status, evidence, and closeout notes within these limits do
  not require separate approval.

## Phase 1: Prepare the build

1. Read the whole plan and sibling criteria file if it exists.
2. Read the optional spec (required under manager), the manager checkpoint when
   supplied, and relevant manifest files routed by the target.
3. For an epic, identify the exact master-plan phase ID and verify required
   earlier phases are complete.
4. If a criteria file exists, read its `Pre-implementation test contract` and
   classify the run below. Otherwise, skip this contract-specific step and use
   the plan and existing verification practices without requiring red tests:

   - **Normal change:** inspect every named plan-derived test and its recorded
     expected red result, each deferred `Implement-plan unit-test note`, and
     each alternative proof and residual risk. Do not demand red unit tests for
     documented deferred behavior or behavior adequately proved by integration
     or higher-level checks, even when the contract has no new unit tests.
   - **Test-invalidating redesign:** confirm the criteria explain why
     pre-implementation tests were skipped and identify the invalidated unit
     suite.
   - **No suitable test infrastructure:** confirm the criteria record that
     limitation and provide non-unit proof.
5. Inspect the named implementation files, tests, and commands.
6. Before production edits on a normal change with plan-derived red tests, run the exact narrow test
   command and reproduce the expected red state. Confirm that failure comes
   from missing planned behavior, not an unrelated baseline defect.
7. If a plan-derived test unexpectedly passes before implementation, determine
   whether behavior already exists, the test is non-discriminating, or
   implementation has already begun. Do not force it red; stop for user input
   if the finding changes plan scope or invalidates the contract.
8. Establish the narrowest check for the first todo.
9. Record any explicit request to retain scratch artifacts on completion.

Do not expand scope to adjacent master-plan phases or unrelated cleanup.

## Phase 2: Build in plan order

Follow a Cursor Build-style loop:

1. Take the next pending plan todo.
2. Make the smallest coherent implementation change for that todo. Require a
   production justification independent of unit-test convenience or coverage.
3. Run the narrowest relevant plan-derived test, compile, lint, or behavior
   check. On a normal change, use the red tests as the primary implementation
   target and turn them green incrementally.
4. When implementation settles an interface or function signature named in an
  `Implement-plan unit-test note`, add the specified unit cases against that
  boundary and verify the stated desired outcomes. If the boundary remains
  unclear or unsuitable, execute the note's interim proof and report the
  residual gap instead of guessing an API or changing production code for the
  test.
5. If a check fails because required production behavior is wrong, fix that behavior
   and rerun. If the difficulty is accessing or controlling code for a unit test,
   use existing boundaries or test-side helpers instead of altering production
   code. If that is insufficient, report the affected behavior, alternative
   proof, and residual risk; get approval before changing the protected test
  contract or criteria. Do not silently skip the check or force a coverage gate.
  If the user does not respond, preserve the documented deferral and alternative
  proof rather than forcing the unit test or modifying production code solely
  for test convenience.
6. Record the todo as verified only when its work and focused check are
   complete. Defer plan status and checkbox edits until Phase 4.
7. Continue to the next todo.

Follow the target repo's existing architecture, helpers, and style. Do not
rewrite tests merely to make the implementation appear correct. For a
test-invalidating redesign, do not invent replacement tests during this run;
use the specified behavioral, narrative, inspection, and command-based checks.
Do not silently delete, disable, or exclude an obsolete suite unless that
disposition is part of the plan.

## Phase 3: Prove acceptance

After implementation, evaluate every acceptance checkbox precisely:

If no criteria file exists, verify the completed plan steps with relevant
existing tests, build/lint commands, and observable behavioral checks instead.
Report the results and any unavailable checks; missing criteria are not a blocker.

- for a normal change, run every plan-derived pre-implementation test and
  confirm it is now green;
- run every named automated test and validation command;
- perform each manual check that the environment allows;
- inspect each narrative and design requirement against the named code,
  configuration, schema, migration, or documentation artifact;
- inspect the production diff for test-only refactors, hooks, widened visibility,
  mock-only indirection, and other coverage-driven changes; remove changes made
  by this run that have no independent production justification;
- execute each recorded production-integrity fallback and relevant size,
  performance, or timing check; disclose coverage gaps and unavailable evidence;
- compare observed behavior with the exact expected result;
- record any check that cannot run and why; do not mark it passed;
- run broader regression checks when the criteria require them.

If a criterion fails because production behavior or design is wrong, repair the
implementation and repeat the relevant focused checks, then rerun the acceptance
set. Never alter production code solely to satisfy a test harness or coverage
gate. Keep iterating until every criterion passes or a genuine blocker requires
the user. Under manager, apply Managed completion for unavailable human checks
and return blockers to the main agent. Return evidence for independent review;
do not treat a pending human check as passed or initiate review-finding repairs
outside the main agent's dispatch.

Do not create unit tests beyond plan-derived tests and the cases specified by an
`Implement-plan unit-test note`, unless the user requests them.

Do not weaken, remove, skip, or rewrite a plan-derived test or criterion merely
to obtain a pass. If a test seems too hard to pass, report to the user and seek further instructions. A test implementation that demonstrably contradicts the
unchanged spec and criteria may be corrected with recorded evidence and a
focused rerun. Changing the intended behavior, test strategy, coverage gate, or
any acceptance criterion always requires user approval, including when a
criterion appears wrong or outdated. Production-integrity conflicts are
blockers to resolve, not permission to silently rewrite the contract.

## Phase 4: Close the plan

**Under manager:** return changed files, checks and observed results, evidence
locations identifying the checked code/diff state, pending human checks, and
blockers to the main agent. Preserve durable evidence before scratch cleanup.
Do not update final plan/master completion statuses or clean scratch yet.
Manager owns independent review and subsequent closeout under the linked
Managed completion policy; its closeout worker may perform the status, evidence,
and cleanup updates permitted above. Do not repair minor review findings.

**Standalone:** proceed only after every applicable acceptance criterion passes,
or, without a criteria file, after plan completion and relevant verification
succeed:

1. Save durable verification evidence outside scratch.
2. Inventory `.local_manifest/scratch/<plan-stem>/`, or state that the directory
   does not exist or is empty. Verify the resolved cleanup path as described
   above, then remove its disposable contents and directory. If retention was
   explicitly requested, preserve and report them instead.
3. Update detailed-plan todo statuses and task checkboxes and, for an epic,
   only the matching master-plan phase status and checkbox.
4. Report changed files, validation commands, acceptance results, retained
   scratch artifacts, and residual risks.

## Completion checks

- The implementation input was a `*.planning.md` detailed plan, never a
  `*.master.md`.

- Work stayed inside the detailed plan and one epic phase when applicable.

- Planning requirements were not edited without user approval; status,
  verification evidence, and managed closeout notes stayed within the stated
  permissions.

- Normal-change tests were observed red before production edits when
  implementation had not already begun, then made green through implementation;
  documented fallback behavior was verified by its specified alternative checks.

- Tests were not weakened to obtain a pass.

- Production code was not changed solely to ease unit testing or raise coverage;
  production-integrity checks and residual coverage gaps were reported.

- A test-invalidating redesign did not acquire unplanned tests or use the
  skip to evade behavioral, narrative, or final validation criteria.

- Standalone completion requires every acceptance criterion to pass. Under
  manager, evidence and pending checks were returned for independent review
  before manager applies Managed completion; unperformed checks were never
  marked passed.

- An absent criteria file was ignored, not treated as a prerequisite or created
  automatically; work was verified against the plan and existing checks instead.

- Final plan and matching master-phase status updates occurred only at
  standalone closeout or manager closeout after independent review.

- Ephemeral files were kept only under `.local_manifest/scratch/<plan-stem>/`.

- Scratch cleanup followed durable evidence capture and resolved path checks,
  stayed within this plan's directory, and honored an explicit retain request;
  under manager it waited for closeout after independent review.
