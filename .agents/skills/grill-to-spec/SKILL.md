---
name: grill-to-spec
description: >-
  Relentlessly interviews the user about a plan or design (grilling), sharpening
  domain terminology as it goes, and — once shared understanding is reached —
  writes a spec file to the *target* repo's `.agents/plans/` tree as the starting
  point for spec-driven development. Simple specs stay directly under `plans/`;
  epic specs stay in the epic's dedicated subdirectory. Afterwards, lists any
  manifest files in the target repo (terms.rule.md, adr/, reference/, guides/)
  made stale by the decisions and asks the user's permission before updating
  them.
  Use when the user asks to "grill me into a spec", "grill this plan",
  "stress-test this design and write a spec", or wants a spec-driven starting
  point for a task.
---

Adapted from [mattpocock/skills](https://github.com/mattpocock/skills) — see
[`THIRD_PARTY_NOTICES.md`](../../../THIRD_PARTY_NOTICES.md).

# Grill to Spec

Interview the user relentlessly about a plan or design until shared
understanding is reached, then capture that understanding as a **spec** the
user can read as a plain description of intended behavior. This is the grilling
loop plus active domain modeling, with two deliverables at the end: a spec file,
and (with permission) manifest updates.

## Inputs you must resolve first

- **Template repo (source):** the folder that contains this skill. Never write
the spec or manifest edits here. Also, the skill may be called from a different place. In that case, ignore the template repo and work with the target repo directly.
- **Target repo (destination):** the repo the plan is about. The spec and any manifest updates go there.
- **Planning source:** the user's stated intent, or the part of an epic master
plan the user wants to turn into a spec. The user remains the authority for the
spec's decisions.

If the workspace has one directory, it is the target. If the workspace has exactly two folders, the one that is **not** this template
is the target. If it is ambiguous, ask the user before writing anything.

> **Safety:** All writes (spec, manifest edits) go to the **target** repo only.



## Phase 1: Grilling

Interview the user relentlessly about every aspect of the plan until you reach
a shared understanding. Walk down each branch of the design tree, resolving
dependencies between decisions one-by-one. For each question, provide your
recommended answer.

Ask the questions **one at a time**, waiting for feedback on each question
before continuing. 

If a *fact* can be found by exploring the target repo, look it up rather than
asking. The *decisions*, though, are the user's — put each one to them and wait
for their answer.

Do not write the spec, and do not enact the plan, until the user confirms you
have reached a shared understanding. Do not implement any of the decisions until the spec is written. Even then, recommend the user to plan and implement the spec in a separate chat.

## Phase 2: Domain modeling during the session

While grilling, actively sharpen the target repo's domain model. The canonical
glossary in a manifest repo is `.agents/rules/terms.rule.md`; decisions live in
`.agents/adr/*.adr.md`.

- **Challenge against the terms.** If the target has a `terms.rule.md` and
the user uses a term that conflicts with it, call it out: example: "Your
terms file defines 'adoption' as X, but you seem to mean Y — which is your intent?"
- **Sharpen fuzzy language.** When the user uses vague or overloaded terms,
propose a precise canonical term. "You're saying 'target' — do you mean the
product or the build option?"
- **Discuss concrete scenarios.** Stress-test domain relationships with
specific edge-case scenarios that force precision about boundaries between
concepts.
- **Cross-reference with code.** When the user states how something works,
check whether the target repo's code agrees. Surface contradictions.

Do **not** edit manifest files during this phase. Instead, keep a running list
of manifest files that the session's decisions make stale (see Phase 4).

## Phase 3: Write the spec

When the user confirms shared understanding is reached — or asks to wrap up —
choose the path from the target's planning structure:

```
# Simple work
.agents/plans/<topic>.spec.md

# One part of an epic
.agents/plans/<epic>/<part>.spec.md
```

Use a short, descriptive dash-case `<topic>` (e.g. `partial-refunds.spec.md`).
For an epic, use the existing epic directory and a short dash-case `<part>`.
If the user points to an epic master plan, save the spec beside it. Do not place
an epic spec at the top level or create a second directory for the same epic.
Create the chosen directory if needed. Never place the spec outside the target
repo's `.agents/plans/` tree, and never in the template repo.

The spec is the human-readable statement of what the task should do in the
scenarios discussed. It describes observable behavior, not architecture,
implementation steps, design rationale, tests, or acceptance criteria.

Write short, direct statements in language close to the user's own words. Cover
normal use, relevant alternatives, boundaries, errors, and recovery behavior.
Prefer concrete sentences such as "When an admin repeats the same request, the
existing export is returned" over formal requirement labels or implementation
terms.

Structure:

```markdown
# <Title> Spec

> Produced by a grilling session on YYYY-MM-DD. Status: ready for planning.

One or two plain sentences about the intended outcome and who it is for.

## Intended behavior

- When <situation>, <what the user or system observes>.
- If <alternative or error>, <what happens instead>.
- While <boundary condition>, <behavior that must remain true>.

```

Use helpful scenario groups when one long list becomes hard to read, but keep
the result informal and behavior-focused. Do not add `Decisions`, `Acceptance
criteria`, file-level changes, test cases, or implementation steps. If an open
question changes intended behavior, keep grilling instead of putting an
unresolved design branch into a ready spec.

Link to the target's manifest documents (ADRs, references, rules) instead of
duplicating their content. For an epic spec, also link to its `*-initial.md` and
`*.master.plan` sources when they exist. Do not copy the whole master plan
into the spec.

If the session ends **without** reaching shared understanding, do not write a
spec. Tell the user which branches remain unresolved.

## Phase 4: Offer manifest updates (permission-gated)

After the spec is written, check whether the session's decisions made any manifest files in the target repo stale. Follow the placement rules in target repo's manifest structure (.agents/rules/manifest-structure.rule.md if present)


Candidates to check (only if the file/directory already exists in the target):

- `.agents/rules/terms.rule.md` — terms coined or sharpened during the session.
- `.agents/adr/` — a decision from the session that is hard to reverse,
surprising without context, and the result of a real trade-off. If any of the
three is missing, skip the ADR.
- `.agents/reference/` — mechanics described in the session that contradict or
extend an existing `*.ref.md`.
- `.agents/guides/` — procedures or commands the session changed.

Then:

1. **List** the files that need an update and what would change in each, in one
  short summary.
2. **Ask the user's permission** before editing any of them.
3. Update **only** the files the user approves, following the target's naming
  suffixes (`*.adr.md`, `*.ref.md`, `<category>.rule.md`) and cross-linking
   conventions.

## Decision tree

```
Workspace folders?
├─ Only this template open ......... STOP: ask user to add their repo
├─ Exactly two ..................... target = the other folder
└─ Ambiguous ....................... ASK which folder is the target

Shared understanding confirmed?
├─ No .............................. keep grilling; no spec, no edits
└─ Yes
  ├─ Simple work .................. write plans/<topic>.spec.md
  └─ Epic part .................... write plans/<epic>/<part>.spec.md

Stale manifest files found in target?
├─ No .............................. report "manifest untouched" and stop
└─ Yes ............................. list them → ask permission → update
                                     only the approved ones
```



## Completion checks

- Questions were asked one at a time; facts came from the repo, decisions from
the user.
- The spec exists directly under `<target>/.agents/plans/` for simple work or
  inside the correct epic directory, covers the intended behavior and relevant
  scenarios in plain language, and contains no design or acceptance section —
  or the user was told why no spec was written.
- No manifest file was edited without the user's explicit approval.
- Nothing was written into the template repo.

