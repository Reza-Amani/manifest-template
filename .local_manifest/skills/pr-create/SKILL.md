---
name: pr-create
description: "Creates a new GitHub pull request from the current branch to a named target branch, or edits an existing PR the user names, as a draft by default, with a plain-English title and a description that explains intent and architecture changes with code snippets as evidence. For a new PR it first checks whether the diff carries more than one unrelated purpose: a focused diff becomes one PR without pausing, while slices worth separate review are proposed with names and split into their own branches and PRs after the user picks them. Uses the GitHub MCP, falling back to the gh CLI. Use when the user asks for pr-create, to open, create, raise, or split a PR, or to rewrite a PR title or description."
argument-hint: "new <target branch> | edit <PR number or URL>, plus any wording changes for the title or description"
disable-model-invocation: true
---

# PR Create

Open a new PR, or edit an existing one, against a target branch. The
description is the main deliverable: a reviewer should understand the intent
and the architecture change without reading the whole diff.

## 1. Mode and inputs

The user says which mode this is. If they did not, ask; never infer it by
searching for open PRs. Several open PRs to the same target are normal.

- **New:** requires the target branch. If missing, ask; suggest the target used
  by a recent `pr-ready` run in this chat, if any.
- **Edit:** requires the PR number or URL. Read the PR (GitHub MCP
  `pull_request_read`, fallback `gh pr view <n> --json number,url,title,body,isDraft,headRefName,baseRefName,headRefOid`)
  to get its head, base, draft state, title, and body.

Then:

1. `git fetch origin <target>` (edit mode: fetch the PR's base and head). Diff
   against the merge base: `origin/<target>...HEAD`, or
   `origin/<base>...origin/<head>` in edit mode.
2. Stop if the head is the target or has no commits ahead of it.
3. Warn that uncommitted changes are not included; never commit them for the user.

Edit mode skips section 2 and goes to section 4.

## 2. Decide whether to split (new mode)

Read the commits and `git diff --stat -M origin/<target>...HEAD`, then the diff
itself, and group the changes by purpose. Use the chat history and the matching
spec (section 4) to recover intent. Use `.github/CODEOWNERS` (when present) as
a signal for natural reviewer boundaries.

A change is a **split candidate** only when all of these hold:

- Its purpose is unrelated to the main purpose: a separate feature, bug fix,
  refactor, tooling change, or manifest overhaul.
- It stands alone: it builds, passes tests, and makes sense to merge without
  the main change.
- It is worth its own review: big or risky enough that mixing it in would
  distract the reviewer of the main change.

Keep a change in the main PR when it is tightly coupled (the main change needs
it to build or test), shares the main purpose, or is a **side change**: tiny
and unimportant, such as a typo, comment, small rename, local cleanup, or the
manifest doc update that keeps docs in sync with the change.

- **No split candidates:** go straight to section 3 with one PR. Do not ask for
  confirmation. List the side changes, if any, in the description (section 4).
- **One or more candidates:** recommend them to the user. For each give a
  proposed PR title, a proposed branch name (short kebab-case, keeping any
  ticket key if the slice has one), a one-line scope note naming the files,
  and whether it is independent or stacked. Name what stays in the main PR.
  Show a Mermaid diagram when there are three or more PRs or any stacking.
  Ask which candidates get a separate PR, as a multiple-choice question when
  the tool supports it. Wait for the answer; do nothing to git before it.
  Candidates the user rejects stay in the main PR and are listed as side
  changes. If the user rejects all of them, go to section 3 with one PR.

## 3. Branches and push

### One PR

If the current branch is missing on `origin` or behind local, push it with
`git push -u origin HEAD`. Never force-push.

### Split

Never discard work, run destructive git commands, rewrite history, or stage
with `git add .` / `git add -A` (stage only named files or hunks).

1. Save a backup ref of the original head:
   `git update-ref refs/backup/pre-split-<branch>-<yyyymmddHHmm> HEAD`.
2. Every approved slice and the remaining main change get a new branch. The
   original branch is left as it is, because removing changes from it would
   rewrite history.
3. Base each branch on `origin/<target>`. Stack a branch on another slice's
   branch only when it really depends on it (it does not build or test
   without it); order foundations before consumers. A stacked PR targets the
   branch it is stacked on.
4. Build each branch in a temporary worktree so the user's working tree and
   uncommitted changes are untouched:
   `git worktree add .local_manifest/scratch/pr-create/wt/<slice> -b <slice-branch> <base>`.
   - Whole files: `git -C <wt> checkout <original head> -- <files>`
     (deleted files: `git -C <wt> rm <files>`; renames: both paths).
   - Part of a file: write the slice's hunks with
     `git diff <base>...<original head> -- <file>` into a patch under
     `.local_manifest/scratch/pr-create/`, trim it to the slice, then
     `git -C <wt> apply --index <patch>`.
5. Before committing, check `git -C <wt> diff --cached --stat` shows only the
   planned files. Across all slices, every path in the original
   `--name-status` list must land in exactly one slice, and the hunks of a
   split file must together equal its original diff. Build or run the
   affected unit tests in the worktree when a slice splits a file or moves
   shared code.
6. Commit with a plain message naming the slice, push with
   `git push -u origin <slice-branch>`, then remove the worktree with
   `git worktree remove <wt>`.

Then run sections 4 and 5 once per PR, foundations first, so stacked PRs can
link the PR they depend on.

## 4. Gather the story and write the description

- **Intent source:** search `.local_manifest/plans/` for the spec matching any
  ticket key in the branch name or the branch topic: prefer `*.spec.md`, then
  `*.planning.md`, then the epic's `*.master.md`. If none exists, infer intent
  from the commit messages and the diff.
- **Commits:** `git log --oneline origin/<target>..<head>`.
- **Architecture candidates**, in this order:
  1. Renamed, moved, added, or deleted files: `git diff --name-status -M origin/<target>...<head>`.
  2. Public interfaces, contracts, schemas, API endpoints, and exported types
     or signatures.
  3. Core configuration, domain definitions, and shared constants or wiring.
  4. Changed ownership or data flow: who creates, writes, or reads a state.
  5. ADR changes under `.team_manifest/adr/`.

**Edit mode:** apply the user's requested wording changes on top of the
current title and body rather than rewriting sections they did not mention.
Regenerate a section from the diff only when the user asks for it or new
commits made it wrong. Keep the draft state unless asked.

**Title:** `<ticket-key>: <plain-English summary>` when the branch has a ticket
key, otherwise just the summary. At most 72 characters, no jargon.

**Body:** if the repository has a pull request template (for example
`.github/pull_request_template.md`), fill its sections and remove its HTML
comments; otherwise use the sections below.

- **Intent:** two to four sentences of plain English: the problem and what this
  PR changes about it, drawn from the spec. Name the ticket (if any) and name
  the spec without linking its local path (`.local_manifest/` may be private).
  For a split PR, name the sibling PRs and, when stacked, the PR it depends on.
- **Architecture changes:** the core section. One short subsection per change,
  most important first. Each has one or two sentences on what changed and why
  it matters, then a short snippet as evidence (at most about 15 lines): the
  new interface, the old and new signature as a `diff` block, the type or
  schema, or the new way of defining the thing. Link the file at the head
  commit on the repository's GitHub remote:
  `https://github.com/<owner>/<repo>/blob/<full head SHA>/<path>#L<a>-L<b>`.
  Skip internal-only refactors unless they move ownership. Write `None` when
  there is no architecture change.
- **Side changes:** only when the PR carries side changes. Add this section
  after Architecture changes: one bullet per side change, a few words each,
  naming the file.
- **Testing:** what actually ran (unit tests, integration or end-to-end checks,
  manual verification, benchmarks), using `pr-ready` results from this chat
  when available. For a split PR, only claim results that apply to that branch.
  Do not claim checks that did not run.
- **Risks and follow-ups:** where reviewers should look hardest, and deferred work.

Write the body to `.local_manifest/scratch/pr-create/<head branch>.md` so later
edits start from it.

## 5. Publish

- **GitHub MCP:** `create_pull_request` (`draft: true`) or `update_pull_request`.
- **Fallback:** `gh pr create --draft --base <target> --head <branch> --title "<title>" --body-file <file>`,
  or `gh pr edit <number> --title "<title>" --body-file <file>`.

Report each PR link, whether it was created or edited, its draft state, its
base, and its architecture headings. After a split, also report the backup ref,
that the original branch is unchanged, and anything not placed in any PR. Say
that `pr-create edit <PR>` with new wording edits a PR.
