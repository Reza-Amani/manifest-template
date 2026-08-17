---
name: wrap-up-plan
description: >-
  Combination of archiving and documentation. Does everything `archive-plan`
  does for one completed task, then scans the finished work's design and logic
  and creates or updates a `reference/*.ref.md` when future tasks would need
  that technical understanding — skipping when the logic is trivial, useless to
  capture, or already documented. Use when the user asks to "wrap up this plan",
  "wrap-up-plan", archive and document a completed task, or close out finished
  work with reference docs.
---

# Wrap Up Plan

Close out one completed task: archive its planning artifacts (same rules as
[`archive-plan`](../archive-plan/SKILL.md)), and ensure lasting technical
understanding lives in `reference/` when it is worth capturing.

Follow the canonical [planning flow](../../reference/planning-flow.ref.md).

## Inputs

Same as `archive-plan`:

- One completed `*.planning.md` outside `archive/`. Reject master plans,
  `backlog.plan.md`, specs, and initial files as the primary input.
- Optionally, its one matching `*.spec.md` and task-exclusive `*-initial.md`.

If the user does not identify the detailed plan unambiguously, list plausible
completed plans and ask them to select one.

## Hard Rules

### Archive (identical to `archive-plan`)

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
8. Do not move code, tests, scratch artifacts, or other manifest documents as
   part of the archive step.

### Documentation

9. Capture **mechanics** (how the implemented design/logic works) in
   `reference/*.ref.md`. Put durable **why** decisions in `adr/` only when the
   user asks or an existing ADR is clearly contradicted — do not invent ADRs
   during wrap-up by default.
10. Write for a future agent or developer who should grasp the technical design
    without reading the whole implementation or the archived plan.
11. **Skip** documentation when the implemented logic is trivial, not useful to
    future tasks, or already accurately documented in an existing reference
    (or an ADR that already covers the same mechanics).
12. Prefer updating a related existing `*.ref.md` over creating a parallel file
    on the same topic.
13. Do not dump the plan into a reference. Summarize durable design: purpose,
    components, control flow / sequences, key invariants, config surfaces, and
    caveats that matter for later work.
14. When creating a new reference, add a routing row under Task → Reference in
    [`routing.rule.md`](../../rules/routing.rule.md). When updating, fix routing
    only if the topic or path changed.

## Procedure

Copy this checklist and track progress:

```
Wrap-up progress:
- [ ] 1. Completion gate
- [ ] 2. Resolve archive companions
- [ ] 3. Scan design/logic vs reference/
- [ ] 4. Draft create / update / skip decision
- [ ] 5. User confirms archive set + doc action
- [ ] 6. Apply documentation
- [ ] 7. Archive moves
- [ ] 8. Validate and report
```

### 1. Completion gate

Read the whole plan and apply the archive completion rules. Prose such as
"implemented" or a passing build alone is insufficient evidence.

### 2. Resolve archive companions

Resolve companions conservatively, then search active plans for references.
Leave any companion needed by another task or unfinished phase in place.
Build the exact archive move set (paths relative to `plans/`, destinations under
`plans/archive/`). Reject sources outside `.agents/plans/` and existing
destinations.

### 3. Scan design and logic

From the plan, spec (if any), and the code that was actually shipped:

1. Identify the non-trivial design and logic this task introduced or changed
   (flows, invariants, module boundaries, algorithms, integration contracts).
2. Search `.agents/reference/` (and routing rows) for docs on that topic.
3. Decide one outcome:

| Outcome | When |
| --- | --- |
| **Skip** | Logic is trivial, not useful later, or already covered accurately |
| **Create** | No `*.ref.md` captures this design/logic for future tasks |
| **Update** | A related `*.ref.md` exists but is stale, incomplete, or wrong |

### 4. Draft the documentation action

If creating or updating, prepare the reference content (or a clear diff summary)
before any file moves:

- Explain the design and technical details at the level future tasks need.
- Prefer the shape of existing references in the repo (summary, components,
  sequences, config, caveats). Use diagrams only when they clarify control flow.
- Name new files `reference/<topic>.ref.md` using the repo's naming conventions.

### 5. Confirm with the user

Show in one confirmation:

- The exact archive move set and retained nearby files
- The documentation decision: **skip** (with one-line reason), **create**
  (path + short outline), or **update** (path + what will change)

Move nothing and write no reference changes until the user confirms this exact
set after implementation has finished.

### 6. Apply documentation

On confirmation, create or update the reference (or skip). Update routing when a
new reference is added or a topic/path changes. Leave the reference accurate if
archive later moves the plan — references must not depend on active plan paths.

### 7. Archive moves

Move the confirmed planning files. Remove a source directory only if it is
empty.

### 8. Validate and report

Verify sources are gone, destinations exist, and protected files stayed put.
Repair valid links to moved files without changing master-plan status or scope.
If a reference was written, spot-check it against the shipped code for obvious
drift. Run available documentation checks, then report:

- Moved and retained planning files
- Documentation outcome (skipped / created / updated) with paths
- Link updates, routing updates, validation results, and any unavailable checks
