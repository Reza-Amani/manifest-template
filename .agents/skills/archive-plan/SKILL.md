---
name: archive-plan
description: >-
  Archives one completed task's detailed plan, matching spec, and optional
  initial plan under `.agents/plans/archive/` after `implement-plan` finishes
  and the user confirms. It refuses master plans, unrelated task files,
  ambiguous companions, and plans with unfinished tasks or acceptance criteria.
  Use when the user asks to "archive this plan", "archive the completed task",
  or clean up completed planning artifacts after implementation.
---

# Archive Plan

Move one completed task's planning artifacts from `.agents/plans/` to
`.agents/plans/archive/`. This is closeout after `implement-plan`, not a way to
declare work complete.

Follow the canonical [planning flow](../../reference/planning-flow.ref.md).

## Inputs

- One completed `*.planning.md` outside `archive/`. Reject master plans,
  `backlog.plan.md`, specs, and initial files as the primary input.
- Optionally, its one matching `*.spec.md` and task-exclusive `*-initial.md`.

If the user does not identify the detailed plan unambiguously, list plausible
completed plans and ask them to select one.

## Hard Rules

1. Archive exactly one task per invocation.
2. Never move or edit master plans, backlogs, unrelated task files, or files
   with unfinished work.
3. Require every todo, task checkbox, and acceptance checkbox to be complete;
   reject blockers, skipped required checks, and unverified criteria. For an
   epic, also require the matching master phase to be complete.
4. Never rewrite planning content to satisfy the completion gate.
5. Include a spec only through an explicit plan link or exact sibling stem.
   Include an initial file only through an explicit link and only when it is
   exclusive to this task. Omit ambiguous or still-referenced companions.
6. For an epic phase, normally archive only its plan and spec. Keep the epic
   initial file with its master plan.
7. Preserve relative layout under `plans/archive/` and never overwrite files.
8. Do not move code, tests, scratch artifacts, or other manifest documents.

## Archive Procedure

1. Read the whole plan and apply the completion rules above. Prose such as
   "implemented" or a passing build alone is insufficient evidence.
2. Resolve companions conservatively, then search active plans for references.
   Leave any companion needed by another task or unfinished phase in place.
3. Preserve each path relative to `plans/`, such as
   `plans/epic/phase.spec.md` to `plans/archive/epic/phase.spec.md`.
4. Reject sources outside `.agents/plans/` and existing destinations.
5. Show the exact move set and retained nearby files. Move nothing until the
   user confirms this exact set after implementation has finished.
6. Move the files. Remove a source directory only if it is empty.

## Validation

Verify sources are gone, destinations exist, and protected files stayed put.
Repair valid links to moved files without changing master-plan status or scope.
Run available documentation checks, then report moved and retained files, link
updates, validation results, and any unavailable checks.