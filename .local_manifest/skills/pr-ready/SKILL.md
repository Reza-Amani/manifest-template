---
name: pr-ready
description: "Checks whether the current branch is ready for a pull request against a named target branch: deterministic project checks (format, lint, typecheck, build, tests, and any repo-specific gates) plus a review of naming, coding standards, ADRs, and architecture. Reports every finding as a brief warning with clickable file links and never edits files. Use when the user asks for pr-ready, PR readiness, or a pre-PR check."
argument-hint: "Target branch name, for example main"
disable-model-invocation: true
---

# PR Ready

Read-only readiness check of the branch diff against a target branch. Every
finding is a **warning**: the user may proceed to `pr-create` or fix and rerun
this skill. Never edit, stage, commit, or push.

## 1. Scope

1. Require the target branch name. If the user did not give one, ask. Offer the
   base of an open PR for this branch (`gh pr view --json baseRefName`) or the
   `github-pr-base-branch` git config as the suggestion; never assume `main`.
2. `git fetch origin <target>`, then compare against the merge base:
   `git diff --name-status -M origin/<target>...HEAD`. The three-dot form
   matters because branches may be stacked on other feature branches.
3. Note uncommitted changes and unpushed commits as warnings; they are not part
   of the PR. Review only the committed branch diff.
4. Load the rules, ADRs, and references the changed paths need through
   [`routing.rule.md`](../../../.team_manifest/rules/routing.rule.md) and
   [`local routing`](../../../.local_manifest/rules/routing.rule.md). Always
   include [`terms.rule.md`](../../../.team_manifest/rules/terms.rule.md) and
   any coding-standards rules routed for the touched languages.

## 2. Deterministic checks

Run the repository's real verification commands from
[`commands.md`](../../../.team_manifest/guides/commands.md) (and any routed
build or verification actions); do not invent commands. Skip a check only when
the project does not define it or the diff cannot affect it, and say so.

| Check | What to run | Warn on |
|---|---|---|
| Format / style | project formatter check | any file the diff touched |
| Lint / static analysis | project linter or typechecker | findings in changed lines or files |
| Build | project build for affected targets | errors or new warnings |
| Unit tests | project unit test suite | any failure |
| Integration / E2E | project integration, scenario, or end-to-end checks when applicable | any failure; note whether the scenario or test changed in this diff |
| Generated / protected paths | any rules governing generated or read-only directories | hand edits that violate project rules |
| Release / config safety | any release-readiness or config check defined by the project | debug-only or unsafe options left enabled |

## 3. Judgement checks

Review only lines the branch changed. Prefer a fresh subagent that receives just
the target, merge-base SHA, changed-file list, and rule/ADR paths, not this chat.

- **Naming and coding standards** from the project's routed coding rules and
  conventions.
- **Terminology** matches [`terms.rule.md`](../../../.team_manifest/rules/terms.rule.md).
- **ADRs and architecture:** layer and module boundaries, ownership, dependency
  direction, files in the right directory, and conformance with
  [`adr/`](../../../.team_manifest/adr/).
- **Single source of truth and duplication** introduced by the diff.
- **Tests:** new or changed behavior without a focused unit or integration test.
- **Docs in sync:** apply
  [`verify-docs-in-sync.md`](../../../.team_manifest/actions/verify-docs-in-sync.md)
  as a check only; do not apply its fixes.

High-signal filter: drop pre-existing issues, linter-catchable issues (the lint
row covers them), style preferences, and anything you cannot point to in the
code. Before reporting, re-read the code for each candidate and drop any that
do not hold up. Quote the rule or ADR line for every standards or
architecture warning.

## 4. Report

Keep each warning to one line. Link with workspace-relative paths so they open
in the editor.

```markdown
## PR readiness against `<target>`: <n> warnings

Format pass · Lint 1 · Build pass · Unit tests pass · Integration pass

- ⚠️ Lint — [service.ts:42](src/service.ts#L42): unused error variable on fallback path.
- ⚠️ Architecture — [handler.ts:118](src/transport/handler.ts#L118): transport layer queries storage directly; `0001-layered-architecture.adr.md` says "…".
- ⚠️ Not in PR — 2 uncommitted files.
```

If there are no warnings, write `Ready for a PR against <target>: no warnings.`
Always end with:
`These are warnings only. Run pr-create new <target> to open the PR, or fix and rerun pr-ready <target>.`
