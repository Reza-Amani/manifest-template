---
name: implement-plan
description: >-
  Implements a detailed `.agents/plans/*.planning.md` using a Cursor Build-style
  workflow, reproduces the plan's intentional pre-implementation test failures,
  implements until those tests pass, and validates automated and narrative
  acceptance criteria. It respects the test-authoring exception recorded for
  test-invalidating redesigns. The spec is optional. Use when the user asks to
  "implement this plan", "build the plan", "execute this plan", or "finish
  this phase".
---

# Implement Plan

Implement one detailed plan end to end. For a normal change, start from the red
tests written by `plan-to-criteria` and make them green by changing production
code, not by weakening the contract. For a test-invalidating redesign, honor
the recorded pre-implementation test skip and prove the work through the
plan's other behavioral, narrative, and validation criteria.

Follow the canonical [planning flow](../../reference/planning-flow.ref.md).

## Inputs

- **Plan (required):** one detailed `*.planning.md`. Reject a
  `*.master.plan` as the implementation input.
- **Spec (optional):** use the linked `*.spec.md` when present for behavioral
  context. The plan remains the implementation guide.
- **Master plan (epics only, optional context):** read it to identify the
  matching phase and dependencies. Do not implement other phases.

If the plan has no `## Acceptance criteria` section, stop and recommend running
`plan-to-criteria` first. The section must identify its pre-implementation test
strategy: plan-derived red tests, or an explicit test-authoring skip for a
test-invalidating redesign or unavailable test infrastructure. If it does not,
stop and recommend rerunning `plan-to-criteria`. If the plan, optional spec, or
repository contradicts itself in a way that changes scope or behavior, explain
the problem and ask the user before editing planning files.

## Ephemeral files

Put any temporary backups, baselines, comparison outputs, or other ephemeral
artifacts under `.agents/scratch/<plan-stem>/`, where `<plan-stem>` is the
detailed plan filename without `.planning.md`. Never put them beside the plan
or elsewhere in the repository. Create the scratch directory only when needed,
and do not treat its contents as implementation deliverables.

If the user asks at any point to clean up ephemeral files when the work is
done, record that as advance authorization for this run. Otherwise, cleanup
requires explicit confirmation during plan closeout.

## Protected files

- Do not edit spec text.
- Do not edit plan prose, architecture, steps, or acceptance criteria.
- You may update plan YAML todo statuses and matching Markdown task checkboxes
  as work is completed.
- For an epic, you may update only the matching phase status and checkbox in
  the master plan, and only after all acceptance criteria pass.
- If a protected file is obviously wrong, get user approval before correcting
  it. Checkbox/status updates are the only routine exception.

## Phase 1: Prepare the build

1. Read the whole plan and its acceptance section.
2. Read the optional spec and relevant manifest files routed by the target.
3. For an epic, identify the exact master-plan phase ID and verify required
   earlier phases are complete.
4. Read the `Pre-implementation test contract` and classify the run:
   - **Normal change:** inspect every named plan-derived test and its recorded
     expected red result.
   - **Test-invalidating redesign:** confirm the criteria explain why
     pre-implementation tests were skipped and identify the invalidated unit
     suite.
   - **No suitable test infrastructure:** confirm the criteria record that
     limitation and provide non-unit proof.
5. Inspect the named implementation files, tests, and commands.
6. Before production edits on a normal change, run the exact narrow test
   command and reproduce the expected red state. Confirm that failure comes
   from missing planned behavior, not an unrelated baseline defect.
7. If a plan-derived test unexpectedly passes before implementation, determine
   whether behavior already exists, the test is non-discriminating, or
   implementation has already begun. Do not force it red; stop for user input
   if the finding changes plan scope or invalidates the contract.
8. Establish the narrowest check for the first todo.
9. Note whether the user has already authorized scratch cleanup on completion.

Do not expand scope to adjacent master-plan phases or unrelated cleanup.

## Phase 2: Build in plan order

Follow a Cursor Build-style loop:

1. Take the next pending plan todo.
2. Make the smallest coherent implementation change for that todo.
3. Run the narrowest relevant plan-derived test, compile, lint, or behavior
   check. On a normal change, use the red tests as the primary implementation
   target and turn them green incrementally.
4. If it fails because of the implementation, fix the implementation and rerun.
5. Record the todo as verified only when its work and focused check are
  complete. Defer plan status and checkbox edits until Phase 4.
6. Continue to the next todo.

Follow the target repo's existing architecture, helpers, and style. Do not
rewrite tests merely to make the implementation appear correct. For a
test-invalidating redesign, do not invent replacement tests during this run;
use the specified behavioral, narrative, inspection, and command-based checks.
Do not silently delete, disable, or exclude an obsolete suite unless that
disposition is part of the plan.

## Phase 3: Prove acceptance

After implementation, evaluate every acceptance checkbox precisely:

- for a normal change, run every plan-derived pre-implementation test and
  confirm it is now green;
- run every named automated test and validation command;
- perform each manual check that the environment allows;
- inspect each narrative and design requirement against the named code,
  configuration, schema, migration, or documentation artifact;
- compare observed behavior with the exact expected result;
- record any check that cannot run and why; do not mark it passed;
- run broader regression checks when the criteria require them.

If a criterion fails, repair the implementation and repeat the relevant focused
checks, then rerun the acceptance set. Keep iterating until every criterion
passes or a genuine blocker requires the user.

Do not weaken, remove, skip, or rewrite a plan-derived test or criterion during
retries, unless the test or criterion is obviously wrong. If a test or
criterion is obviously wrong or outdated, or a unit test is testing the old
behavior rather than the new one, fix it and explain the evidence; no
confirmation is needed.

## Phase 4: Close the plan

Only after every acceptance criterion passes:

1. Confirm all detailed-plan work and acceptance checks are complete, but defer
  final status updates until the scratch decision is resolved.
2. List the contents of `.agents/scratch/<plan-stem>/`, or state that the
  directory does not exist or is empty.
3. If scratch artifacts exist and the user did not authorize cleanup earlier,
  ask whether to remove them. Do not delete them without confirmation.
4. In one closeout step after the user's answer:
  - remove the listed artifacts and `<plan-stem>` directory if cleanup was
    authorized, including by an earlier request;
  - otherwise preserve them and report their location;
  - update the detailed-plan todo statuses and checkboxes;
  - for an epic, update only the matching master-plan phase todo and checkbox.
5. Report changed files, validation commands, acceptance results, retained
  scratch artifacts, and any residual risk the stated criteria could not
  cover.

## Completion checks

- The implementation input was a `*.planning.md` detailed plan, never a
  `*.master.plan`.
- Work stayed inside the detailed plan and one epic phase when applicable.
- Plan/spec prose and criteria were not edited without user approval.
- Normal-change tests were observed red before production edits when
  implementation had not already begun, then made green through implementation.
- Tests were not weakened to obtain a pass.
- A test-invalidating redesign did not acquire unplanned tests or use the
  skip to evade behavioral, narrative, or final validation criteria.
- Every acceptance criterion passed; otherwise the task is reported blocked,
  not complete.
- Plan status and the matching master phase status reflect actual completion.
- Ephemeral files were kept only under `.agents/scratch/<plan-stem>/`.
- Existing scratch contents were inventoried at closeout and were removed only
  with advance authorization or explicit confirmation.
