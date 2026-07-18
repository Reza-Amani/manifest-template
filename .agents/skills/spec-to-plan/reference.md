# Cursor Plan Mode format (for spec-to-plan)

Use this as the shape and depth bar when writing detailed implementation plans
in the `.agents/plans/` tree.
Match Cursor Plan Mode: concrete file paths, actionable todos, and enough
detail that an implementer can build without re-deriving the design.

## Frontmatter

```yaml
---
name: short-plan-name
overview: One or two sentences on what will be built and why.
todos:
  - id: kebab-case-id
    content: Imperative task the implementer can complete and check off
    status: pending
  - id: another-step
    content: Next discrete step
    status: pending
isProject: false
---
```

Rules:

- `name`: short label (often matches the file topic).
- `overview`: the whole plan in one breath.
- `todos`: ordered build steps. Keep them small enough to finish in one pass
  each. Status starts as `pending` for a new plan.
- `isProject`: use `false` unless the target repo already uses another
  convention for workspace-saved plans.

## Body skeleton

Omit empty sections. Add sections the work needs (for example a behavior
matrix or version-bump rules).

```markdown
# <Title>

## Spec

Source of truth: [`<topic>.spec.md`](<topic>.spec.md) (adjust the relative path).
The plan normally sits beside its spec, both at the top level for simple work
or both inside one epic directory. Prefer linking over copying acceptance text.

## Goals

- Bullet goals the implementation must hit.

## Approach

Short design narrative. Key decisions if the spec left room. Optional mermaid
when structure or flow matters:

\`\`\`mermaid
flowchart LR
  a[Caller] --> b[Service]
  b --> c[Store]
\`\`\`

## File-level changes

### 1) [`path/to/file`](path/to/file) — change

What to add, change, or remove. Name types, functions, flags, and contracts.
Include a short code sketch when the API must be exact.

### 2) [`path/to/new_file`](path/to/new_file) — NEW

Purpose and outline of contents.

## Out of scope / what this does not change

Explicit non-goals and untouched call sites when that prevents scope creep.

## Risks / things to watch

Easy mistakes, ordering constraints, backward-compat traps.
```

Keep test discovery and acceptance-test authoring out of this stage.
`plan-to-criteria` inspects the real test infrastructure and adds those tests
after this implementation plan exists.

## Detail levels

### Standard (default Plan Mode depth)

- Real paths and what changes in each.
- Named APIs, flags, and data shapes.
- Todos that map 1:1 to the file-level work.
- Risks and out-of-scope.

### High detail (cheap implementer or user request)

Everything in standard, plus:

- Exact signatures, field lists, and constants when known.
- Short copy-paste sketches for new helpers or types.
- Line or symbol anchors ("near `Migrate`, after `LiveTradeResult`").
- Edge cases and failure paths the implementer must not invent.
- Explicit "do not change" list for nearby code that looks related.

## Anti-patterns

- Vague steps like "update the backend" with no paths.
- Todos that do not appear in the body (or body work with no todo).
- Pasting the entire spec into the plan.
- Editing the spec from this skill.
- Adding acceptance criteria before `plan-to-criteria` studies the test setup.
- Adding test-authoring todos that belong to `plan-to-criteria`.
- Turning an epic `*-master.plan.md` roadmap directly into an implementation
  plan instead of producing a spec for one part first.
- Saving under `~/.cursor/plans/` or `.cursor/plans/` instead of
  `.agents/plans/`.
