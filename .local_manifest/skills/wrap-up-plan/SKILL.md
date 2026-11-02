---
name: wrap-up-plan
description: >-
   Archives completed planning work and captures lasting technical understanding
   in `reference/*.ref.md` when useful. It closes a small task, explicitly named
   completed epic phase, or a fully completed epic. Use when the user asks to
   "wrap up this plan", "wrap-up-plan", archive a completed task or epic, or
   close out finished work with reference docs.
---

# Wrap Up Plan

Close out completed planning work and ensure lasting technical understanding
lives in `reference/` when it is worth capturing. Archive after the completion
gate passes; no separate confirmation is required.

Follow the canonical [planning flow](../../reference/planning-flow.ref.md),
including its [Managed completion policy](../../reference/planning-flow.ref.md#managed-completion)
for recorded manager runs. That policy defines the permitted exceptions;
this skill does not relax standalone completion gates.

## Modes and Inputs

Choose exactly one mode:

| Mode | Primary input | Eligible archive set |
| --- | --- | --- |
| **Task** | One completed `*.planning.md` outside `archive/` | The plan, its matching spec, criteria, manager checkpoint when present, and a task-exclusive initial file when one exists |
| **Epic phase** | One completed phase `*.planning.md` under an epic | The phase plan and matching spec, criteria, and manager checkpoint when present |
| **Epic** | One completed `*.master.md` | The master plan, its linked initial file, and every remaining active, completed phase plan and matching spec, criteria, and manager checkpoint in that epic |

A manager dispatch selects **Task** or **Epic phase** mode for exactly its
task/phase. Always use **Epic phase** for a managed phase, even if it is the
last phase; leave the master and initial idea active. A later explicit
whole-epic wrap-up may select **Epic** mode.

Reject `backlog.plan.md`, specs, and initial files as primary inputs. If the
input is ambiguous, list plausible completed candidates and ask the user to
select one.

## Hard Rules

### Archive

1. Archive exactly one task, phase, or fully completed epic per invocation.
2. Never move backlogs, unrelated files, or files with unfinished plan work.
   Recorded managed exceptions are governed by Managed completion.
3. Require every work todo and task checkbox in each detailed plan, and every
   acceptance checkbox in the plan or sibling criteria file when present,
   to be complete; reject blockers, skipped required checks,
   and unverified criteria. A phase also requires its matching master phase to
   be complete. For a recorded manager run only, apply Managed completion:
   validate the checkpoint's independent-review evidence and permitted
   exceptions instead of requiring affected acceptance boxes to be checked.
   Unresolved severe findings and failing executable checks still block archive.
4. Do not rewrite, remove, weaken, or redefine a criterion to satisfy the
   completion gate. After implementation, you may update acceptance-checkbox
   markers and add concise evidence or verification notes when the existing
   criterion is actually satisfied. Leave unmet criteria unchecked and report
   them as blockers, except the recorded managed exceptions. Preserve those
   annotations and the closeout links to the checkpoint. Do not fix minor review
   findings during wrap-up; return severe findings to the manager for its
   fix-worker and independent-review loop.
5. Include a spec and criteria file only through an explicit plan link or exact
   sibling stem (`.spec.md` and `.criteria.md` replacing `.planning.md`). Read
   the sibling criteria for completion checks when present. If absent, ignore
   it: do not require its creation or a `plan-to-criteria` run. Verify completion
   from the plan and implementation evidence instead.
   Include the manager checkpoint through an explicit plan link or exact sibling
   stem (`.manager.md` replacing `.planning.md`); require it when relying on
   Managed completion. Include an initial file only through an explicit link
   and only when it is exclusive to the archived task or epic. Omit ambiguous
   companions.
6. For an epic with any remaining phase, do not archive a completed phase unless
   the user explicitly asks to wrap up that phase. Keep its master plan and
   initial file active. A manager invocation supplies that selected-phase
   authorization and always retains those epic files. Outside manager, when
   every master phase is complete, use **Epic** mode and archive the full
   remaining epic record instead.
7. **Epic** mode requires every master todo and mirrored phase checkbox to be
   complete, every phase artifact to satisfy its applicable completion gate,
   and all moved files to belong unambiguously to that epic. Check previously
   archived managed phases and their checkpoints as well as active phases;
   preserve recorded exceptions without converting them into passing evidence.
   It may move the master plan and initial file only in this mode.
8. Preserve relative layout under `plans/archive/` and never overwrite files.
9. Do not move code, tests, scratch artifacts, or other manifest documents as
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
    [`routing.rule.md`](../../rules/routing.rule.md) in this directory. When updating, fix routing
    only if the topic or path changed.

## Procedure

Copy this checklist and track progress:

```
Wrap-up progress:
- [ ] 1. Completion gate
- [ ] 2. Resolve archive companions
- [ ] 3. Scan design/logic vs reference/
- [ ] 4. Draft create / update / skip decision
- [ ] 5. Apply documentation
- [ ] 6. Archive moves
- [ ] 7. Validate and report
```

### 1. Completion gate

Read every primary artifact and apply the archive completion rules. For **Epic**
mode, verify every master phase and all active phase artifacts before selecting
any move, consulting previously archived phase records and checkpoints where
needed. For a recorded managed completion, verify the final independent review,
annotated exceptions, completed plan/master work statuses, and closeout notes
linking the checkpoint. Manager may update these statuses and notes and record
truthful evidence without changing planning requirements. A later whole-epic
wrap-up honors the same recorded exceptions; it does not require human checks
to have been performed or minor findings to have been fixed. When the shipped
implementation and available evidence satisfy an existing acceptance criterion,
update its checkbox and record concise evidence
in the criteria file when present before continuing. Do not change
the criterion's wording or scope just to make it pass. Prose such as
"implemented" or a passing build alone is
insufficient evidence.

### 2. Resolve archive companions

Resolve companions conservatively, then search active plans for references.
Include criteria files only when they exist; their absence is not a blocker.
Leave any companion needed by another task or unfinished phase in place.
Build the exact archive move set (paths relative to `plans/`, destinations under
`plans/archive/`). Reject sources outside `.local_manifest/plans/` and existing
destinations. In **Epic** mode, include the completed master, linked initial,
and all remaining active completed phase plans, matching specs, and criteria
files, plus their matching manager checkpoints when present. Previously
archived phase records and checkpoints stay where they are; retain valid links
to them from the completed master record. In managed **Epic phase** mode, leave
the master, initial idea, and other phases active regardless of their status.

### 3. Scan design and logic

From the plan, spec (if any), master and initial documents for an epic, and the
code that was actually shipped:

1. Identify the non-trivial design and logic this task introduced or changed
   (flows, invariants, module boundaries, algorithms, integration contracts).
2. Search `.local_manifest/reference/` (and routing rows) for docs on that topic.
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
- Name new files `.local_manifest/reference/<topic>.ref.md` using the repo's naming conventions.

### 5. Apply documentation

Create or update the reference (or skip). Update routing when a new reference
is added or a topic/path changes. Leave the reference accurate if archive later
moves the plan -- references must not depend on active plan paths.

### 6. Archive moves

Move the resolved planning files. Remove a source directory only if it is empty.

### 7. Validate and report

Verify sources are gone, destinations exist, and protected files stayed put.
Repair valid links to moved files. For an **Epic** closeout, confirm no active
documents still reference the archived epic sources.
If a reference was written, spot-check it against the shipped code for obvious
drift. Run available documentation checks, then report:

- Moved and retained planning files
- Documentation outcome (skipped / created / updated) with paths
- Link updates, routing updates, validation results, and any unavailable checks
- For managed records, the archived checkpoint and every retained pending human
  check or minor finding; do not report those checks as passed or findings fixed
