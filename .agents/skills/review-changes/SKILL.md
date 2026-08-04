---

## name: review-changes
description: >-
  Reviews staged, unstaged, and untracked changes without editing files. Reports
  only actionable bugs, architecture violations, and technical debt introduced
  by the changes, ranked by severity with precise evidence. Use when the user
  asks to review uncommitted changes, perform a pre-commit review, or run a
  Bugbot-style local review.

# Review Changes

Review the current working tree as the
`[reviewer](../../personas/reviewer.agent.md)`. This is a read-only review:
never edit files, apply fixes, stage changes, or create commits.

## Review procedure

1. Read the root `AGENTS.md`, then use
  `[routing.rule.md](../../rules/routing.rule.md)` to load only the rules, ADRs,
   references, plans, and terms relevant to the changed code.
2. Establish the full review scope with Git:
  - inspect status, including staged, unstaged, and untracked paths;
  - inspect staged and unstaged diffs against `HEAD`;
  - read every relevant untracked file because it is absent from normal diffs.
3. Infer the intended behavior from the request, changed tests, related specs or
  plans, existing interfaces, and nearby code. Do not assume that compiling
   means the behavior is correct.
4. Trace changed behavior through callers, callees, data boundaries, error
  paths, state transitions, concurrency, and cleanup. Inspect unchanged code
   only where needed to prove or disprove an issue introduced by the changes.
5. Review in this order:
  - **Bugs and regressions:** incorrect logic, edge cases, error handling,
   security failures, races, resource leaks, compatibility breaks, and missing
   validation.
  - **Architecture flaws:** broken boundaries, dependency direction errors, misplaced responsibilities, files put in the wrong directories or with non-sense names, leaky abstractions, and inconsistent domain models.
  - **Technical debt introduced now:** duplication, hidden coupling, brittle shortcuts, avoidable complexity, poor observability, multiple sources of truth (where single source of truth is achievable) and missing focused tests that make the changed behavior unsafe to maintain.
6. Use safe, focused diagnostics when they materially strengthen a finding.
  Do not modify source files or use destructive Git commands.



## Evidence standard

Report an issue only when all of these are true:

- the uncommitted changes introduced it or made an existing issue materially
worse;
- it has a concrete failure mode or maintainability cost;
- the relevant file and line or symbol can be identified;
- a specific remediation can be suggested.

Do not report style preferences, speculative concerns, praise, or problems
unrelated to the changes. Consolidate findings with the same root cause.

## Report format

List findings from highest to lowest severity:

```markdown
## Findings

### [P1] Short actionable title
- Location: `path/to/file.ext:line` (`symbol`)
- Category: Bug | Architecture | Technical debt
- Evidence: What the changed code does and the concrete failing scenario.
- Impact: Why it matters.
- Suggested fix: The smallest sound direction; do not apply it.
```

Severity:

- **P0 — Critical:** immediate data loss, security compromise, or system-wide
outage.
- **P1 — High:** likely production failure, major regression, or serious
architecture violation.
- **P2 — Medium:** real bug in a narrower case or technical debt with a concrete
near-term cost.
- **P3 — Low:** localized, non-urgent issue that is still worth fixing before
commit.

If there are no qualifying findings, write:

`No actionable issues found in the uncommitted changes.`

End a report containing findings with:

`I have not changed any files. Which findings would you like me to fix?`

Wait for explicit instructions before making any fix.