---
name: implement-plan
description: >-
  Implements a detailed `.agents/plans/*.planning.md` using a Cursor Build-style
  workflow, updates applicable plan task status, and repeatedly validates every
  acceptance criterion until all pass. The spec is optional. It avoids editing
  plan/spec prose and, for epics, marks only the matching master-plan phase
  complete. Use when the user asks to "implement this plan", "build the plan",
  "execute this plan", or "finish this phase".
---

# Implement Plan

Implement one detailed plan end to end. Work in small plan-ordered steps, run
focused checks as you go, then prove every acceptance criterion before calling
the work complete.

Follow the canonical [planning flow](../../reference/planning-flow.ref.md).

## Inputs

- **Plan (required):** one detailed `*.planning.md`. Reject a
  `*.master.plan` as the implementation input.
- **Spec (optional):** use the linked `*.spec.md` when present for behavioral
  context. The plan remains the implementation guide.
- **Master plan (epics only, optional context):** read it to identify the
  matching phase and dependencies. Do not implement other phases.

If the plan has no `## Acceptance criteria` section, stop and recommend running
`plan-to-criteria` first. If the plan, optional spec, or repository contradicts
itself in a way that changes scope or behavior, explain the problem and ask the
user before editing planning files.

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
4. Inspect the named implementation files, tests, and commands.
5. Establish the narrowest check for the first todo.
6. Note whether the user has already authorized scratch cleanup on completion.

Do not expand scope to adjacent master-plan phases or unrelated cleanup.

## Phase 2: Build in plan order

Follow a Cursor Build-style loop:

1. Take the next pending plan todo.
2. Make the smallest coherent implementation change for that todo.
3. Run the narrowest relevant test, compile, lint, or behavior check.
4. If it fails because of the implementation, fix the implementation and rerun.
5. Record the todo as verified only when its work and focused check are
  complete. Defer plan status and checkbox edits until Phase 4.
6. Continue to the next todo.

Follow the target repo's existing architecture, helpers, and style. Do not
rewrite tests merely to make the implementation appear correct.

## Phase 3: Prove acceptance

After implementation, evaluate every acceptance checkbox precisely:

- run every named automated test and validation command;
- perform each manual check that the environment allows;
- compare observed behavior with the exact expected result;
- record any check that cannot run and why; do not mark it passed;
- run broader regression checks when the criteria require them.

If a criterion fails, repair the implementation and repeat the relevant focused
checks, then rerun the acceptance set. Keep iterating until every criterion
passes or a genuine blocker requires the user.

Do not weaken, remove, skip, or rewrite a test or criterion during retries. If a
test or criterion is obviously wrong, explain the evidence and get user
confirmation before editing it.

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
- Tests were not weakened to obtain a pass.
- Every acceptance criterion passed; otherwise the task is reported blocked,
  not complete.
- Plan status and the matching master phase status reflect actual completion.
- Ephemeral files were kept only under `.agents/scratch/<plan-stem>/`.
- Existing scratch contents were inventoried at closeout and were removed only
  with advance authorization or explicit confirmation.
