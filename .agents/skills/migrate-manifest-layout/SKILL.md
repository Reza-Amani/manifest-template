---
name: migrate-manifest-layout
description: >-
  One-time migration of a repository's agent manifest from the legacy single
  `.agents/` tree to the two-tree layout: a shared `.team_manifest/` and a
  per-person `.local_manifest/`, with a gitignored `.agents/` discovery shim
  that holds only `skills/team` and `skills/local` symlinks. The user creates
  the trees, splits and moves files, and creates the symlinks by hand first;
  this skill then derives the rename map from where files now live, scaffolds
  the two-level `AGENTS.md` and split routing, rewrites every stale address and
  relative link, fixes `.gitignore`, removes legacy tool mirrors, and verifies
  the result. Works for solo repos (both trees tracked) and team repos
  (`.local_manifest/` gitignored, backed by a private git repo).
  Use when the user asks to "migrate the manifest layout", "repair manifest
  addresses after the split", "move to team/local manifest", or "finish the
  .agents split".
---

# Migrate Manifest Layout

Moves one repository from the legacy layout (everything under `.agents/`) to the
two-tree layout defined in [`reference.md`](reference.md): `.team_manifest/`
(shared) + `.local_manifest/` (personal) + a gitignored `.agents/` shim that
exists only so Cursor, VS Code Copilot, and OpenCode auto-discover skills.

**Persona:** run as the Manifester
([`../../personas/manifester.agent.md`](../../personas/manifester.agent.md)):
plain English, one fact in one place, correct placement and links.

## Division of labour

The **user** does the judgement work before invoking this skill:

- creates `.team_manifest/` and `.local_manifest/` (the latter may be a symlink
  into a private git repo),
- decides which `skills/` and `reference/` items are team and which are local,
  and moves every file into its new tree,
- creates the `.agents/skills/team` and `.agents/skills/local` symlinks.

The **skill** does the mechanical work that is easy to get wrong by hand:

- derives the old-path → new-path map from where files now live,
- writes the two-level `AGENTS.md` and splits `routing.rule.md`,
- rewrites every stale `.agents/...` address and every relative link that
  crossed a tree boundary,
- fixes `.gitignore` per repo type, removes legacy tool mirrors on request,
- verifies symlinks, skill-name uniqueness, and link resolution, then reports.

It never moves content between trees on its own judgement and never deletes
document content. Anything ambiguous is listed for the user.

## Inputs to resolve first

1. **Target repo.** The repository being migrated. Normally the *other*
   workspace folder; it may be this template itself when the user says so
   explicitly. If ambiguous, ask.
2. **Repo type.** Ask the user, do not infer:
   - `solo` — both trees are tracked by the target repo. `.agents/` is
     gitignored. `scratch/` is gitignored.
   - `team` — `.team_manifest/` is tracked; `.local_manifest/` and `.agents/`
     are gitignored; `.local_manifest/` is a symlink into a private repo that
     tracks it (`scratch/` is gitignored there).
3. **Moves are done.** Confirm the user has finished creating trees, moving
   files, and creating symlinks. If not, stop and hand them the checklist in
   [`reference.md`](reference.md#manual-pre-migration-checklist).

## Hard rules

1. Do not move files between `.team_manifest/` and `.local_manifest/`. If a
   file's placement looks wrong, flag it; the user decides.
2. Do not delete document content. Legacy *mirror folders* (`.cursor/`,
   `.github/skills`, `.github/agents`, `.github/instructions`,
   `.github/prompts`) may be removed only after listing their contents and
   getting the user's confirmation.
3. Preserve the target's own wording. Rewrite addresses and links; do not
   rephrase mandates, decisions, or procedures.
4. Links must resolve **as seen from the target repo root through the
   symlinks** (for example `.local_manifest/skills/x/SKILL.md`), never through
   the private repo's physical path. Cross-tree links from the private repo
   viewed on its own will not resolve; that is accepted.
5. When a reference cannot be mapped unambiguously, do not guess. Put it in the
   residual list.

## Procedure

```
Task progress:
- [ ] 1. Identify target, repo type, and confirm manual moves are done
- [ ] 2. Inventory both trees and the shim; detect legacy leftovers
- [ ] 3. Build the rename map from the inventory
- [ ] 4. Scaffold structure files (root AGENTS.md, local AGENTS.md, split routing, backlog, structure rule)
- [ ] 5. Rewrite addresses and relative links everywhere
- [ ] 6. Fix .gitignore for the repo type
- [ ] 7. Remove legacy tool mirrors (with confirmation)
- [ ] 8. Verify and report
```

### 1. Identify target, type, and readiness

Resolve the three inputs above. Record repo type; it drives steps 6 and 8.

### 2. Inventory

List, as seen from the target root:

- `.team_manifest/**` and `.local_manifest/**` (follow the symlink).
- `.agents/**`. Expected: only `skills/team` and `skills/local`, both
  symbolic links. Anything else under `.agents/` is a **legacy leftover** —
  a real folder or an old per-folder symlink the user has not yet moved or
  removed. Stop and list leftovers; do not proceed until the user resolves
  them.
- Every text file that may hold manifest addresses: root `AGENTS.md`,
  `README.md`, `THIRD_PARTY_NOTICES.md`, `.gitignore`, `.vscode/*.json`,
  `.github/**`, `docs/**`, and all files in both trees. Search them for the
  strings `.agents/`, `.agents\`, and `../` links whose target does not
  resolve from the file's current location.

Also check for legacy mirror folders and for any `operation-*` files (these are
retired from the template; list them for the user to delete).

### 3. Build the rename map

For each legacy reference `.agents/<folder>/<rest>` found in step 2, resolve the
new path using the ownership table in
[`reference.md`](reference.md#folder-ownership):

- **Fixed folders** map by rule: `adr`, `actions`, `guides`, `personas`,
  `rules` → `.team_manifest/<folder>/<rest>`; `plans`, `findings`, `learning`,
  `scratch` → `.local_manifest/<folder>/<rest>`.
- **Split folders** (`skills`, `reference`) resolve by lookup: find `<rest>`
  (skill folder name, or reference filename) under
  `.team_manifest/<folder>/` and `.local_manifest/<folder>/`.
  - Found in exactly one tree → map there.
  - Found in both → **ambiguous**; ask the user which is canonical and flag the
    duplicate (duplicate skill names break OpenCode and Copilot discovery).
  - Found in neither → **dangling**; add to the residual list. Do not invent a
    path.
- **Special files:**
  - `plans/backlog.plan.md` → `.team_manifest/backlog.plan.md`.
  - `rules/routing.rule.md` → depends on the *referencing* file: a file in
    `.team_manifest/` points to the team routing; a file in `.local_manifest/`
    points to the local routing; root `AGENTS.md` points to both.
  - `rules/manifest-structure.rule.md` and `rules/terms.rule.md` →
    `.team_manifest/rules/...`.

Write the map down (a table in your working notes) before editing anything, and
show it to the user if it has any ambiguous or dangling rows.

### 4. Scaffold structure files

Create or rewrite these, using the templates in
[`reference.md`](reference.md#file-templates). Keep the target's existing
project mandates and real routing rows; only the structure changes.

- **Root `AGENTS.md`** — team-owned and tracked. Describe the two trees and the
  shim, point to `.team_manifest/rules/routing.rule.md`, and instruct agents to
  also read `.local_manifest/AGENTS.md` when it exists. Carry over the target's
  real mandates verbatim.
- **`.local_manifest/AGENTS.md`** — create only if missing, from the template.
  Never overwrite an existing one.
- **Split routing.** Take the old `routing.rule.md`. Rows that point into
  `.team_manifest/` (ADRs, team reference, team skills, actions, guides,
  personas, terms, structure rule) stay in
  `.team_manifest/rules/routing.rule.md`; add a row for
  `backlog.plan.md`. Rows that point into `.local_manifest/` (plans,
  findings, learning, local reference, local skills, planning-flow) go to
  `.local_manifest/rules/routing.rule.md`. Create the local file if missing.
  Remove `operation-*` rows. Keep each row's wording.
- **`.team_manifest/backlog.plan.md`** — if it is still under
  `.local_manifest/plans/`, ask the user to move it (rule 1), then route to it.
- **`.team_manifest/rules/manifest-structure.rule.md`** — add the "Layout"
  section from the template (two trees + shim + ownership table) near the top
  and fix its `.agents/` mentions. Do not rewrite the folder-by-folder text; a
  full refresh arrives later through `sync-manifest-template`.
- **`.team_manifest/rules/terms.rule.md`** — add the terms *manifest*, *team
  manifest*, *local manifest*, and *discovery shim* if absent.

### 5. Rewrite addresses and links

Apply the map to every file from step 2:

- Replace path strings (`.agents/x/y`) with the mapped path. Use root-relative
  form in prose and in root-level files.
- For **relative markdown links**, recompute from the file's *new* location as
  seen from the repo root. Examples: a local skill that linked
  `../../personas/manifester.agent.md` now links
  `../../../.team_manifest/personas/manifester.agent.md`; a team skill that
  linked `../../reference/planning-flow.ref.md` now links
  `../../../.local_manifest/reference/planning-flow.ref.md` if that file went
  local.
- Skills that *write* files (planning skills writing to `plans/`,
  `wrap-up-plan` writing reference docs) must now name the local tree
  explicitly: `.local_manifest/plans/`, `.local_manifest/reference/`.
- Do not touch `plans/example-epic/` content beyond its own links; it is
  template-only.

Work file by file; after each file, check that every link in it resolves.

### 6. `.gitignore`

Merge the block for the repo type from
[`reference.md`](reference.md#gitignore-blocks) into the target's `.gitignore`.
Remove obsolete entries `.cursor/`, `.github/skills`, `.github/agents` only if
step 7 removed those folders. For `team` repos also remind the user to ignore
`scratch/` in the private repo.

### 7. Legacy tool mirrors

With the shim in place, `.cursor/`, `.github/skills`, `.github/agents`,
`.github/instructions`, and `.github/prompts` are no longer needed for
discovery. List what each contains. If everything inside is a symlink or a copy
of manifest content, propose deletion and delete on confirmation. If a folder
holds real, unmirrored content, leave it and list it. Never touch
`.github/workflows/` or other non-manifest `.github/` content.

### 8. Verify and report

Check, and print the results:

- `.agents/skills/team` and `.agents/skills/local` are real symbolic links
  (`LinkType` is `SymbolicLink`, not a plain file or folder) and resolve.
- For `team` repos, `.local_manifest` is a symbolic link that resolves.
- No skill folder name exists in both `skills/` trees, and each `SKILL.md`
  `name` equals its folder name.
- No remaining `.agents/` reference except in the shim description of root
  `AGENTS.md`, `manifest-structure.rule.md`, and `guides/setup.md`.
- Every relative link in both trees and in root files resolves.
- No `operation-*` files or routing rows remain.
- `.gitignore` matches the repo type.

Then report: the rename map applied, files created and edited, mirrors removed,
the residual list (ambiguous, dangling, misplaced-looking files), and next
steps: restart the editor and type `/` in chat to confirm skills from both
`team` and `local` appear; commit `.team_manifest/` (and, for `team`, commit the
private repo).

## Decision tree

```
Manual moves done?
├─ No .............................. STOP: hand over the pre-migration checklist
└─ Yes
   Legacy leftovers under .agents/ ?
   ├─ Yes ........................... STOP: list them, user resolves
   └─ No
      Split-folder reference resolves to
      ├─ one tree .................... map it
      ├─ both trees .................. ASK; flag duplicate skill name
      └─ neither ..................... residual list, never invent
```

## Completion checks

- Root `AGENTS.md` describes both trees and the shim and points to both
  routing files (local one conditionally).
- `.team_manifest/rules/routing.rule.md` and
  `.local_manifest/rules/routing.rule.md` exist and route only into their own
  tree (plus `backlog.plan.md` in team routing).
- No unmapped `.agents/` addresses remain; all links resolve from the repo
  root.
- `.gitignore` matches the repo type; legacy mirrors handled per user decision.
- The report lists the residual items instead of silently resolving them.
