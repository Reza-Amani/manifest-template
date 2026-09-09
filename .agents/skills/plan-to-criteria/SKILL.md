---
name: plan-to-criteria
description: >-
  Reads a spec and its Cursor-style implementation plan, studies the target
  repo's existing test infrastructure, prioritizes narrative criteria and
  available integration tests, writes practical failing pre-implementation unit tests for planned
  behavior , and adds acceptance criteria while avoiding other plan edits. It
  may defer unit-test authoring when the module interface or function signatures
  are not clear enough, leaving a precise handoff for implement-plan. Use when
  the user asks to "add acceptance criteria", "make this plan verifiable",
  "plan to criteria", or wants tests and completion checks prepared before
  implementation.
---

# Plan to Criteria

Turn a spec and detailed plan into a TDD/SDD implementation contract. Write
tests against the behavior the plan will introduce, not against the current
implementation. Those tests can be red before implementation and become
green through `implement-plan`. Give first priority to complete narrative and
design criteria, then to integration tests when suitable infrastructure exists,
then to unit tests. Unit tests are required when unit-test infrastructure and a
clear, stable test boundary exist, but they must not crowd out higher-value
integration or narrative proof. Do not implement production behavior.

Follow the canonical [planning flow](../../reference/planning-flow.ref.md).

Never trade production readability, performance, design integrity, code size,
or execution speed for unit tests or coverage. This skill must not edit
plan of the production code, including preparatory changes intended only to enable tests.
Do not expose private internals, widen APIs or visibility, add test hooks or
  test-conditioned production paths

## Inputs

- **Target repo:** the repository being changed.
- **Spec:** the `*.spec.md` source of intended behavior.
- **Plan:** the matching `*.planning.md` implementation plan. A
  `*.master.md` is not a valid input.

If either file is missing or their relationship is unclear, ask the user for
the correct path. Never run this skill against the template when a separate
target repo is open.

## Phase 1: Read without redesigning

1. Read the whole spec and plan.
2. Treat the spec as the authority for intended behavior and the plan as the
   authority for implementation scope.
3. List every normal, alternative, boundary, error, and recovery scenario the
   spec describes, plus every architecture, ownership, compatibility,
   migration, security, performance, and documentation requirement in scope.
4. Add a concrete narrative or design criterion for every item above.
5. For behavior that can be meaningfully proved through existing integration
  test infrastructure, write a pre-implementation integration test (temporarily failing).
6. When unit-test infrastructure is present, write pre-implementation unit
  tests for behavior with a clear, stable unit boundary. These tests can be red
  before implementation and become green after a proper implementation. Apply
  the per-behavior unit-test deferral below when unit proof is premature or
  impractical.

Do not rewrite the plan's approach, todos, risks, or file-level steps.

## Phase 2: Study test infrastructure

Before proposing tests, inspect the target repo's existing test system:

- test commands and configuration;
- nearby integration and unit tests, treating integration coverage as the
  higher-value automated proof when both can express the behavior;
- fixtures, factories, mocks, helpers, and naming conventions;
- which layer owns each behavior in the spec;
- the relevant suite's baseline result before adding tests; (if applicable and
  appropriate)
- practical limits such as external services or unavailable environments.

Use the existing framework and patterns. If no suitable automated test setup
exists, do not introduce a new framework without user approval; write precise
manual or command-based criteria instead.

Classify the plan before editing tests:

- **Normal change:** the planned behavior can be expressed through the existing
  test architecture without invalidating all or effectively all of the
  relevant unit suite.
- **Test-invalidating redesign:** the plan deliberately replaces core
  boundaries or architecture so broadly that all or effectively all relevant
  existing unit tests become obsolete or require wholesale rewrites.
- **No suitable test infrastructure:** the repository has no existing
  framework or stable automated boundary capable of expressing the planned
  delta. This is not a redesign classification and does not authorize adding a
  framework without user approval.

Do not call a change a redesign merely because testing is difficult or several
tests need updates. Record the classification and evidence in the acceptance
section.

### Per-behavior unit-test deferral

For a difficult-to-test part of a normal change, first check existing public
boundaries and test-side fixtures or helpers. Unit tests may be deferred when
the module interface, function signatures, ownership boundary, or observable
contract is not yet clear enough to write a meaningful test, or when testing
would require production changes solely for test convenience or coverage. Keep
the normal-change classification and author integration tests and unit tests
for the remaining testable behavior.

For each deferred unit-test behavior, add an `Implement-plan unit-test note` to
the acceptance section. State why authoring is premature, the behavior and cases
the eventual tests must cover, the desired observable outcome of each case, the
likely test boundary or file if known, and which interface or signature decision
must be resolved first. Also specify an existing integration, system,
simulation, command-based, inspection, or precise manual check with inputs and
expected results for interim proof. Record the residual coverage gap. Do not
label difficult testing as a redesign or absence of infrastructure. If a
mandatory coverage gate conflicts with this deferral, report the blocker and
request a verification or scope decision; do not silently relax the gate or
weaken the behavior being verified.

## Phase 3: Create the pre-implementation proof

### Normal changes: write integration and practical unit tests

Write new tests, or extend an existing test file when that is the clearest
local pattern, before production implementation:

- Derive every assertion from the spec and plan's intended post-change
  behavior. Do not add characterization tests that merely freeze existing code.
- Write integration tests first when the existing suite can exercise the
  behavior through a stable boundary.
- When unit-test infrastructure exists, write unit tests for every meaningful
  planned behavior whose interface and signatures are sufficiently clear. Unit
  tests are the lower priority when they duplicate stronger integration proof.
- Cover as much of the planned normal, error, boundary, and
  idempotency/retry behavior as the existing test infrastructure can prove.
- Prefer public behavior and stable boundaries over private implementation
  details, and reuse existing fixtures and helpers.
- Keep every test traceable to this plan's delta. Preserve-current-behavior
  requirements belong in narrative criteria or the existing regression suite
  unless they are inseparable from a new planned behavior.
- Do not change production code, add compatibility shims, or weaken assertions
  to make the pre-implementation tests pass.
- Run the narrow test command. The new tests must fail for the expected missing
  planned behavior; compile failure from an intentionally not-yet-created API
  is also a valid red state. Record the command and exact expected failure.
- If a new test unexpectedly passes, investigate whether the test is
  non-discriminating, the behavior already exists, or the plan is stale. Do not
  manufacture a failure; ask the user when the finding changes scope.
- If a unit test qualifies for the per-behavior deferral, do not guess the
  production interface or function signatures. Add the required implement-plan
  note and interim proof instead.

Unrelated baseline failures are not a valid red state. Separate them from the
new, intentional failures and report a blocker if they prevent reliable proof.

### Test-invalidating redesigns: skip test authoring

Do not create or update pre-implementation tests when the redesign
classification applies. In particular, do not rewrite unit tests around
architecture that the plan will discard. State why test authoring was skipped
and which suite is expected to become obsolete. Existing black-box or
regression commands may still be acceptance checks, but do not author new tests
in this phase. Use narrative, manual, build, lint, migration, or other
command-based criteria instead.

The redesign exception must not erase behavior or design requirements from the
acceptance contract.

### No suitable test infrastructure: write manual or command-based criteria. skip test authoring.

If no suitable test infrastructure exists, write manual or command-based
criteria. Skip test authoring. Follow the same pattern as the normal changes
section, but instead of writing a test, write a manual or command-based
criterion.

## Phase 4: Add acceptance criteria to the plan

Add or replace one independent section named exactly:

```markdown
## Acceptance criteria
```

Edit as little else in the plan as possible. The section must be complete
enough for `implement-plan` to testify that the work is done. Use checkboxes and
organize it into the following subsections:

### Pre-implementation test contract

- State whether this is a normal change, a test-invalidating redesign, or a
  change without suitable test infrastructure, and why.
- For a normal change, name every added or changed test file, the exact narrow
  command, the planned behavior it specifies, and its observed pre-implementation
  red result.
- For each deferred unit test, include an `Implement-plan unit-test note` with
  the reason for deferral, required cases, desired outcomes, likely boundary or
  file when known, the unresolved interface decision, interim proof, and
  residual coverage gap.
- For a redesign, state that pre-implementation test authoring was
  intentionally skipped, name the invalidated unit suite, and state that no
  new pre-implementation tests were added.
- When no suitable test infrastructure exists, state the limitation and name
  the manual or command-based proof used instead.
- Name existing regression commands separately. Do not present tests that
  merely pass against current code as tests for the planned change.

### Behavioral criteria

- Include every observable behavior from the spec.
- Include relevant negative, boundary, permission, failure, recovery, and
  preserve-current-behavior expectations.
- Name the test, command, or precise manual check that will prove each item.

### Narrative and design criteria

- Treat this subsection as the primary acceptance contract; automated tests
  support it rather than replacing it.
- Include every in-scope architecture, dependency direction, data ownership,
  API/schema, compatibility, migration, security, performance, operability,
  usability, and documentation requirement.
- Make each requirement concrete enough for code inspection or a named manual
  check. Unit-test coverage is not required when it would not meaningfully
  prove the requirement.
- Include all manifest files that implementation must update. They should
  already appear in the plan, but criteria must capture any further manifest
  updates discovered during implementation. Do not update them in this skill.

### Final validation

- Include required build, typecheck, lint, migration, integration, and
  regression commands.
- List integration tests before unit tests when both are present.
- Include precise manual checks for anything automation cannot prove.

Do not use vague criteria such as "works correctly" or "tests pass." Name the
input, action, and observable result, or name the design artifact and the exact
constraint it must satisfy.

## Completion checks

- The spec and matching `*.planning.md` detailed plan were both read; no
  `*.master.md` was treated as a detailed plan.
- Existing test infrastructure and nearby tests were inspected first.
- The relevant existing suite's baseline state was established.
- A normal change has complete narrative/design criteria, plan-derived
  integration tests when suitable infrastructure exists, and plan-derived unit
  tests when unit infrastructure and a clear test boundary exist.
- Every deferred unit test has an `Implement-plan unit-test note` that states
  the required cases, desired outcomes, unresolved interface decision, interim
  proof, and residual coverage gap.
- A test-invalidating redesign has no pre-implementation test edits and
  records the reason for skipping them.
- A repository without suitable test infrastructure records that limitation
  and does not acquire an unapproved framework.
- Every added test is referenced by path, command, intended behavior, and red
  result in the acceptance section.
- Behavioral and narrative criteria cover the full spec and plan, including
  non-happy paths and design requirements not suited to unit testing.
- Plan content outside the acceptance section was not changed unless the user
  approved a necessary correction.
- No production implementation was added.
- No production files were changed for unittest convenience, or coverage.
