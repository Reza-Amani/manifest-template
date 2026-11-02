# AGENTS.md

Read [`rules/routing.rule.md`](rules/routing.rule.md) in this directory to find
plans, findings, learning records, reference docs, and skills.

## Workflow

- Spec-driven development: grill-to-spec → spec-to-plan → plan-to-criteria →
  implement-plan → wrap-up-plan; all artifacts under `plans/` in this
  directory.
- `manager` orchestrates that flow for one task or one named epic phase, adding
  independent review. Its completion policy records pending human checks and
  minor findings while completing and archiving the selected work. See
  [`reference/planning-flow.ref.md`](reference/planning-flow.ref.md#managed-completion).
- `plan-to-criteria` is highly recommended before implementation. If the user
  chooses to skip it, implementation and wrap-up still proceed without criteria.
