---
name: pr-review
description: "Reviews someone else's GitHub pull request for architecture changes, potential bugs, single-source-of-truth violations, and duplication, and reports the findings in chat only. Never posts comments, approves, or requests changes on GitHub. Uses the GitHub MCP, falling back to the gh CLI. Use when the user asks for pr-review or to review a PR by number, URL, or branch."
argument-hint: "PR number, URL, or head branch"
disable-model-invocation: true
---

# PR Review

Review a PR and report in chat. **Never write to GitHub**: no comments, review
submissions, approvals, labels, or edits. Never check out the PR branch or
change the working tree.

## 1. Load the PR

1. Resolve the PR from the number, URL, or branch. Read its title, body, base,
   head, head SHA, changed files, and existing review comments. GitHub MCP
   pull-request read tools first; fallback
   `gh pr view <n> --json title,body,baseRefName,headRefName,headRefOid,files,comments,reviews`.
2. Get the code without checking it out:
   `git fetch origin <base> pull/<n>/head:pr-review-<n>`, then
   `git diff -M origin/<base>...pr-review-<n>` and `git show pr-review-<n>:<path>`
   to read whole files and trace callers.
3. Take the author's intent from the PR body and any linked spec or ticket. If
   the body describes an architecture change, check that the diff matches it.
4. Load only the ADRs, rules, and references for the touched areas through
   [`routing.rule.md`](../../../.team_manifest/rules/routing.rule.md) and
   [`local routing`](../../../.local_manifest/rules/routing.rule.md).

## 2. Review focus

Look only at what the PR introduces or makes materially worse, in this order:

1. **Architecture:** module and layer boundaries, ownership of state, interface
   design, files in the right directory, ADR conformance, implementation
   specifics leaking across boundaries, new coupling. Quote the ADR line when
   one applies.
2. **Potential bugs:** logic and off-by-one errors, concurrency and race
   conditions, initialization and lifecycle order, null and boundary handling,
   error paths, resource cleanup, security and input validation.
3. **Single source of truth:** a value, schema, limit, or definition now held
   in two places; parallel structures or enums that must stay in sync by hand;
   derived values stored instead of computed; code and configuration or
   reference docs drifting apart.
4. **Duplication:** copied logic across modules, adapters, handlers, or tests
   that should be shared.

For large PRs, split these four areas across parallel subagents, each given the
PR intent, base, head SHA, and file list.

## 3. Validate before reporting

For every candidate, re-read the code at the head SHA and confirm the failure
scenario or maintenance cost. Drop it if it does not hold up. Also drop
pre-existing issues, style preferences, things a linter or CI catches, and
points already raised in existing review comments.

## 4. Report in chat

Link each location at the head commit on the repository's GitHub remote:
`https://github.com/<owner>/<repo>/blob/<full head SHA>/<path>#L<a>-L<b>`.

```markdown
## Review of [#<n> <title>](<PR url>)

<Two or three sentences: what the PR changes architecturally, and an overall view.>

### [P1] Short actionable title
- Location: [path:line](<head-SHA link>) (`symbol`)
- Category: Architecture | Bug | Single source of truth | Duplication
- Evidence: what the code does and the concrete failing scenario or cost.
- Suggestion: the smallest sound direction.
```

Use the severities of `review-changes` (P0 critical to P3 low), highest first,
and merge findings that share a root cause. With no findings, write
`No actionable issues found in #<n>.` End by offering to turn chosen findings
into comment text for the user to post. Delete the `pr-review-<n>` ref
(`git branch -D pr-review-<n>`) when done.
