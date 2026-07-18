---
name: implement-plan
description: >-
  Implements a detailed `.agents/plans/*.plan.md` using a Cursor Build-style
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

- **Plan (required):** one detailed `*.plan.md`. Reject a
  `*-master.plan.md` as the implementation input.
- **Spec (optional):** use the linked `*.spec.md` when present for behavioral
  context. The plan remains the implementation guide.
- **Master plan (epics only, optional context):** read it to identify the
  matching phase and dependencies. Do not implement other phases.

If the plan has no `## Acceptance criteria` section, stop and recommend running
`plan-to-criteria` first. If the plan, optional spec, or repository contradicts
itself in a way that changes scope or behavior, explain the problem and ask the
user before editing planning files.

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

Do not expand scope to adjacent master-plan phases or unrelated cleanup.

## Phase 2: Build in plan order

Follow a Cursor Build-style loop:

1. Take the next pending plan todo.
2. Make the smallest coherent implementation change for that todo.
3. Run the narrowest relevant test, compile, lint, or behavior check.
4. If it fails because of the implementation, fix the implementation and rerun.
5. Mark the todo complete only when its work and focused check are complete.
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

1. Confirm all detailed-plan todos and checkboxes are complete.
2. For an epic, mark only the matching master-plan phase todo and checkbox as
   complete. Leave all other phase text and status untouched.
3. Report changed files, validation commands, and acceptance results.
4. Report any residual risk that the stated criteria could not cover.

## Completion checks

- Work stayed inside the detailed plan and one epic phase when applicable.
- Plan/spec prose and criteria were not edited without user approval.
- Tests were not weakened to obtain a pass.
- Every acceptance criterion passed; otherwise the task is reported blocked,
  not complete.
- Plan status and the matching master phase status reflect actual completion.
