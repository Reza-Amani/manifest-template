---
name: spec-to-plan
description: >-
Turns a spec into an implementation plan in Cursor Plan Mode format and saves it
under the matching location in `.agents/plans/`. Simple plans stay at the top
level; epic plans stay beside their spec in the epic's subdirectory. It does
not edit the spec or add acceptance criteria. Use when the user asks to "plan
from this spec", "make a plan for the spec", "spec to plan", or wants a
Cursor-style implementation plan before criteria and building.
---

# Spec to Plan

Read a spec, research the repo, and write an implementation plan the way
**Cursor Plan Mode** does. Save the plan under `.agents/plans/`. Do not change
the spec and do not add acceptance criteria.

This skill pairs with [CODE0](../grill-to-spec/SKILL.md): that skill
writes `*.spec.md`; this one turns a ready spec into a detailed `*.plan.md` in
the same planning directory. `plan-to-criteria` adds the acceptance section and
tests in the next stage.

Follow the canonical [planning flow](../../reference/planning-flow.ref.md).

## Inputs you must resolve first
If there are 2 or more repositories open in the workspace, be aware that one of them might be the manifest-template repo that this skill is banned from editting it
- **Template repo (source):** the folder that has only the manifest files and its name should be manifest-template. Never write the plan here when a separate target repo is open. If the skill is invoked from a repo that already has its own copy of this skill, treat that repo as the target and ignore any template folder.
- **Target repo (destination):** the repo the work is about. The plan goes there under `.agents/plans/`.
- **Spec:** a path to a `*.spec.md` (or other spec file the user names).

If the workspace has one directory, it is the target. If it has exactly two
folders and one is the manifest-template, the other is the target. If it is ambiguous,
ask before writing anything.

> **Safety:** Write the plan only in the **target** repo. Never edit the spec.

## Phase 1: Resolve the spec

1. If the user named a spec file, open it and treat it as the source of truth.
2. If there is no spec file, stop and ask the user to run `grill-to-spec` or
  provide the correct spec path. Do not plan directly from stated intent.
3. If the user points at an epic master plan, do not turn it directly into an
implementation plan. Ask which part should become a spec and route that work
through `grill-to-spec` first.
4. If the user points at a vague goal with no detail, ask for enough context to
plan. Prefer short, focused questions.

### Spec problems (do not edit)

If the spec is incomplete, contradictory, or unclear:

- **Do not** change the spec.
- Tell the user what is wrong and what is blocked.
- Ask whether to pause, proceed with stated assumptions (list them), or wait
for a spec fix.

Only continue once the user accepts assumptions or fixes the gaps.

## Phase 2: Research before writing

Research the **target** repo the same way Plan Mode does:

1. Using the manifest files and routing rule, find the files, modules, and tests the change will touch.
2. Read relevant ADRs, references, and rules from the target's `.agents/` when
the task touches their domain (use the target's `routing.rule.md` if present).
1. Prefer facts from the repo over guesses.

Do not implement code in this skill. Planning only.

## Phase 3: Choose detail level

Match **Cursor Plan Mode** by default: concrete enough to build from (goals,
approach, file-level changes, todos, risks), not a vague outline.

Use a **high-detail** plan when any of these is true:

- The user asks for more detail.
- A smaller or cheaper model will implement the plan later.
- The change is easy to get wrong (many files, subtle contracts, migrations).

High-detail plans add: exact signatures or field lists, short code sketches,
line or symbol anchors where known, per-todo verification, edge cases, and a
clear "do not change" list. Goal: a weaker implementer should not invent the
wrong API or skip a constraint.

Ask once if detail level is unclear and the user did not say which model will
build. Default to Plan Mode depth if they do not answer.

## Phase 4: Write the plan file

Save to the **target** repo only:

```
# Simple work
.agents/plans/<topic>.plan.md

# One part of an epic
.agents/plans/<epic>/<part>.plan.md
```

Use a short dash-case name (for example `partial-refunds.plan.md`). When a spec
file exists, save the plan beside that spec: a top-level spec produces a
top-level plan, and an epic spec produces a plan in the same epic directory.
The `*-master.plan.md` suffix is reserved for epic roadmaps and must not be used
for a detailed implementation plan. Create the chosen directory if needed.

**Never** put the plan in `~/.cursor/plans/`, `.cursor/plans/`, or the template
repo when a separate target is in play.

### Format (Cursor Plan Mode)

Use the same shape Cursor Plan Mode uses. Full template and section guidance:
[CODE0](reference.md).

Required shape:

1. **YAML frontmatter** with `name`, `overview`, `todos` (each with `id`,
`content`, `status: pending`), and `isProject: false`.
1. **Markdown body** with:
  - Title
  - Goals / approach (and key decisions if the spec leaves choices)
  - File-level changes with real paths and what to do in each
  - Optional mermaid diagram when architecture or data flow matters
  - Out of scope / what does not change
  - Risks or watch-outs

Do not add an `Acceptance criteria` section. That section is created later by
`plan-to-criteria` after it studies the target's test infrastructure.

Todos in frontmatter must match the work in the body. Keep `id` values short
and dash-case. Write `content` as a clear imperative the implementer can check
off.

Link to the spec from the plan (relative path). Do not copy the whole spec into
the plan.

## Phase 5: Hand off

After writing the plan:

1. Tell the user the plan path.
2. Summarize open assumptions (if any) and any spec issues still outstanding.
3. Recommend running `plan-to-criteria` before implementation.
4. Do not start coding unless the user asks.

## Decision tree

```
Spec file given?
├─ Yes → read it; do not edit
├─ Epic master plan → STOP; choose a part and create a spec first
└─ No → STOP; ask for a spec or route to grill-to-spec

Spec has blocking gaps?
├─ Yes → notify user; pause or proceed only with their OK + listed assumptions
└─ No  → research target repo

Detail level?
├─ User asked for more detail OR cheap/small implementer OR fragile change
│    → high-detail Cursor-style plan
└─ Else → standard Cursor Plan Mode depth

Write → beside the spec
```

## Completion checks

- Plan exists beside its spec with Cursor-style frontmatter and body.
- Spec was not modified.
- Spec problems were reported to the user when found.
- No acceptance criteria were added; the hand-off points to `plan-to-criteria`.
- Detail level matches Phase 3.
- Nothing was written into the template repo when a separate target was open.
