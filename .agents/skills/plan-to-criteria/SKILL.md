---
name: plan-to-criteria
description: >-
  Reads a spec and its Cursor-style implementation plan, studies the target
  repo's existing test infrastructure, adds or updates focused tests where that
  infrastructure exists, and adds a complete standalone Acceptance criteria
  section to the plan while avoiding other plan edits. Use when the user asks
  to "add acceptance criteria", "make this plan verifiable", "plan to
  criteria", or wants tests and completion checks prepared before implementation.
---

# Plan to Criteria

Turn a spec and detailed plan into a precise implementation contract. Add tests
where the repository already has suitable test infrastructure, then add a
standalone acceptance section to the plan. Do not implement production behavior.

Follow the canonical [planning flow](../../reference/planning-flow.ref.md).

## Inputs

- **Target repo:** the repository being changed.
- **Spec:** the `*.spec.md` source of intended behavior.
- **Plan:** the matching `*.planning.md` implementation plan. A
  `*.master.plan` is not a valid input.

If either file is missing or their relationship is unclear, ask the user for
the correct path. Never run this skill against the template when a separate
target repo is open.

## Phase 1: Read without redesigning

1. Read the whole spec and plan.
2. Treat the spec as the authority for intended behavior and the plan as the
   authority for implementation scope.
3. List every normal, alternative, boundary, error, and recovery scenario the
   spec describes.
4. If the two files conflict or omit information needed for a verifiable
   outcome, explain the gap and ask the user before changing either source.

Do not rewrite the plan's approach, todos, risks, or file-level steps.

## Phase 2: Study test infrastructure

Before proposing tests, inspect the target repo's existing test system:

- test commands and configuration;
- nearby unit and integration tests;
- fixtures, factories, mocks, helpers, and naming conventions;
- which layer owns each behavior in the spec;
- practical limits such as external services or unavailable environments.

Use the existing framework and patterns. If no suitable automated test setup
exists, do not introduce a new framework without user approval; write precise
manual or command-based criteria instead.

## Phase 3: Add behavior tests where possible

Write new tests or extend existing tests to cover as much of the spec as the
available unit and integration infrastructure can prove.

- Prefer public behavior and stable boundaries over private implementation
  details.
- Include normal, error, boundary, and idempotency/retry cases when the spec
  describes them.
- Reuse existing fixtures and helpers.
- Keep tests focused on this plan's scope.
- Do not change production code to make pre-implementation tests pass.
- Run the narrow test command to confirm the tests are discovered. It is valid
  for new behavior tests to fail before implementation; record that state
  honestly.

## Phase 4: Add acceptance criteria to the plan

Add or replace one independent section named exactly:

```markdown
## Acceptance criteria
```

Edit as little else in the plan as possible. The section must be complete
enough for `implement-plan` to testify that the work is done. Use checkboxes and
include:

- every observable behavior from the spec;
- relevant negative, boundary, permission, failure, and recovery behavior;
- regression expectations for behavior that must remain unchanged;
- exact automated test files and commands that prove each covered area;
- precise manual checks for anything automation cannot prove;
- any required build, typecheck, lint, migration, or integration validation.

Do not use vague criteria such as "works correctly" or "tests pass." Name the
input, action, and observable result. Distinguish tests that already pass from
new pre-implementation tests that currently fail for the expected missing
behavior.

## Completion checks

- The spec and matching `*.planning.md` detailed plan were both read; no
  `*.master.plan` was treated as a detailed plan.
- Existing test infrastructure and nearby tests were inspected first.
- Automated tests cover as much intended behavior as the existing setup allows.
- Tests are referenced by path and command in the acceptance section.
- The acceptance section covers the full spec, including non-happy paths.
- Plan content outside the acceptance section was not changed unless the user
  approved a necessary correction.
- No production implementation was added.
