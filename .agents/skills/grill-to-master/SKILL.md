---
name: grill-to-master
description: >-
  Grills the user about a large task or epic, preserves the user's initial idea,
  and writes a high-level master plan with architecture and independently
  plannable phases under `.agents/plans/<epic>/`. The master plan has no
  implementation detail or acceptance criteria. Use when the user asks to
  "grill this epic", "create a master plan", "break this big task into phases",
  or wants an epic roadmap before phase specs are written.
---

Adapted from [mattpocock/skills](https://github.com/mattpocock/skills) — see
[`THIRD_PARTY_NOTICES.md`](../../../THIRD_PARTY_NOTICES.md).

# Grill to Master

Interview the user until the epic's outcome, boundaries, high-level
architecture, and phase split are clear. Preserve the user's starting intent,
then write a master roadmap. Do not write phase specs, detailed implementation
plans, acceptance criteria, or production code.

Follow the canonical [planning flow](../../reference/planning-flow.ref.md).

## Inputs

- **Target repo:** the repository the epic belongs to. Never write to this
  template when a separate target repo is open.
- **Initial explanation:** the user's plain description of the intended
  outcome. An existing `*-initial.md` file may provide it.
- **Epic name:** a short dash-case name for the dedicated plans directory.

If the workspace target is ambiguous, ask before writing. All output belongs in
the target repo.

## Phase 1: Preserve the initial idea

Use `<target>/.agents/plans/<epic>/<epic>-initial.md` as the source of truth for
the epic's starting intent.

- If the file exists, read it and do not rewrite it.
- If the user supplied the idea in chat, write a short faithful capture of the
  user's words before writing the master plan. Do not add inferred requirements
  or agent decisions to this file.
- Show the captured idea to the user during the grilling session and correct it
  if they say it does not match their intent.

## Phase 2: Grill at epic level

Ask one question at a time and wait for the answer. Give a recommended answer
with each question. Explore only what is needed to establish:

- the outcome and who benefits;
- boundaries and clear non-goals;
- high-level requirements that affect the whole epic;
- high-level architecture and system boundaries;
- ordering and dependencies between phases;
- a phase split where each phase can later have one spec and one detailed plan.

Look up repository facts instead of asking the user. Decisions remain the
user's. Stop questions from drifting into API signatures, file-level changes,
test cases, or acceptance criteria; those belong to later stages.

## Phase 3: Test the phase split

Each phase must:

- produce a meaningful result on its own;
- fit into one `grill-to-spec` and `spec-to-plan` cycle;
- state its boundary from earlier and later phases;
- list only true dependencies;
- avoid implementing future phases early.

If a phase is still too broad, split it. If two phases cannot be separated
without duplicate work or an unusable intermediate state, combine or reorder
them.

## Phase 4: Write the master plan

Write:

```text
.agents/plans/<epic>/<epic>-master.plan.md
```

Use YAML frontmatter with `name`, `overview`, `todos`, and `isProject: true`.
Give every phase a stable dash-case todo `id` and `status: pending`. Mirror the
same phases as Markdown checkboxes in the body so `implement-plan` can mark the
matching phase complete later.

Use this body shape:

```markdown
# <Epic> Master Plan

## Source
Link to `<epic>-initial.md`.

## Intended outcome
Short, user-facing result of the epic.

## High-level requirements
Only requirements that apply across phases.

## High-level architecture
System boundaries and major flow. No file-level design.

## Phases
- [ ] **<phase-id>: <name>** — phase outcome, boundary, and dependencies.

## Out of scope
Epic-wide non-goals.
```

Do not add acceptance criteria, detailed behavior scenarios, file paths,
function signatures, test cases, or implementation instructions. Link to future
phase specs and plans only after those files exist.

## Hand-off

Tell the user which phase is ready first. Recommend running `grill-to-spec` for
that phase in a separate session. Do not start the phase spec or implementation
unless the user explicitly asks.

## Completion checks

- The initial idea faithfully preserves user input.
- The master plan links to the initial idea.
- The roadmap is high-level and each phase is independently plannable.
- Frontmatter todos and body phase checkboxes match.
- No phase details or acceptance criteria were added.
- Nothing was written to the template when a separate target was open.
