---
name: migrate-manifest-layout
description: >-
  One-time migration of a repository's agent manifest from the legacy single
  `.agents/` tree to the two-tree layout: `.team_manifest/` plus
  `.local_manifest/`, with a gitignored `.agents/` discovery shim that holds
  skill symlinks. The user creates the trees, moves files, and creates the
  symlinks by hand first; this skill then derives the rename map, scaffolds
  `AGENTS.md` and split routing, rewrites stale addresses and relative links,
  fixes `.gitignore`, removes legacy tool mirrors, and verifies the result.
  Solo repos track both trees and keep every `reference/` and `skills/` item
  under `.local_manifest/`. Team repos track `.team_manifest/` and gitignore
  `.local_manifest/` (a symlink into a private git repo).
  Use when the user asks to "migrate the manifest layout", "repair manifest
  addresses after the split", "move to team/local manifest", or "finish the
  .agents split".
---

# Migrate Manifest Layout

Moves one repository from the legacy layout (everything under `.agents/`) to the
two-tree layout defined in
[`manifest-layout.md`](../../../.team_manifest/guides/manifest-layout.md).
[`reference.md`](reference.md) contains only migration path mappings.

**Persona:** run as the Manifester
([`../../../.team_manifest/personas/manifester.agent.md`](../../../.team_manifest/personas/manifester.agent.md)):
plain English, one fact in one place, correct placement and links.

## Division of labour

The **user** does the judgement work before invoking this skill, following
[`user-setup.md`](user-setup.md):

- creates `.team_manifest/` and `.local_manifest/` (in `team` repos the latter
  is one symlink into a private git repo),
- moves every file into its new tree,
- creates the `.agents/` skill symlink(s).

In `solo` repos every `reference/` doc and every skill goes under
`.local_manifest/`. Do not create `reference/` or `skills/` under
`.team_manifest/`. `.team_manifest/` is there so the folder names match a team
repo; both trees are git-tracked.

In `team` repos the user decides which `skills/` and `reference/` items are
shared (team tree) and which stay in the local tree.

The **skill** does the mechanical work that is easy to get wrong by hand:

- renames leftover `references/` → `reference/` and `teaching/` → `learning/`
  when those old folder names are still present,
- derives the old-path → new-path map from where files now live,
- writes `AGENTS.md` and splits `routing.rule.md` (wording depends on repo type),
- rewrites every stale `.agents/...` address and every relative link that
  crossed a tree boundary,
- fixes `.gitignore` per repo type, removes legacy tool mirrors on request,
- verifies symlinks, skill-name uniqueness, and link resolution, then reports.

It never moves content between trees on its own judgement (the two folder
renames above are the only exception) and never deletes document content.
Anything ambiguous is listed for the user.

## Inputs to resolve first

1. **Target repo.** The repository being migrated. Normally the *other*
   workspace folder; it may be this template itself when the user says so
   explicitly. If ambiguous, ask.
2. **Repo type.** Ask the user to choose, then verify the result after setup
   (`.local_manifest` real directory = `solo`; symbolic link = `team`):
   - `solo` — both `.team_manifest/` and `.local_manifest/` are real folders
     tracked by the target repo. `.agents/` is gitignored. `scratch/` is
     gitignored. `.local_manifest/` is always present.
   - `team` — `.team_manifest/` is tracked; `.local_manifest/` and `.agents/`
     are gitignored; `.local_manifest/` is a symlink into a private repo that
     tracks it (`scratch/` is gitignored there). Treat `.local_manifest/` as
     present.
3. **Moves are done.** Confirm the user has finished creating trees, moving
   files, and creating symlinks. If not, stop and hand them
   [`user-setup.md`](user-setup.md).

## Hard rules

1. Do not move files between `.team_manifest/` and `.local_manifest/`. If a
   file's placement looks wrong, flag it; the user decides. Exception: rename
   `references/` to `reference/` and `teaching/` to `learning/` in place when
   those old folder names are still on disk (step 3).
2. Do not delete document content. Legacy *mirror folders* (`.cursor/`,
   `.github/skills`, `.github/agents`, `.github/instructions`,
   `.github/prompts`) may be removed only after listing their contents and
   getting the user's confirmation.
3. Preserve the target's own wording. Rewrite addresses and links; do not
   rephrase mandates, decisions, or procedures. Use the matching entry-point
   templates from `manifest-layout.md`; the solo templates contain no
   team-versus-local ownership language.
4. Links may resolve **as seen from the target repo root through the
   symlinks** (for example `.local_manifest/skills/x/SKILL.md` in team
   projects), or through the tracked `.local_manifest/` directory in solo
   projects. Assume `.local_manifest/` is present. In `solo`, a full relative
   link is always safe. In `team`, use a full relative link through the
   symlink; only if a specific local file may be missing, write the filename
   plus "if available" instead of a path (for example "refer to
   `products.ref.md` if available"). Never write the private repo's physical
   path into a document.
5. When a reference cannot be mapped unambiguously, do not guess. Put it in the
   residual list.

## Procedure

```
Task progress:
- [ ] 1. Identify target, repo type, and confirm manual moves are done
- [ ] 2. Inventory both trees and the shim; detect legacy leftovers
- [ ] 3. Rename stale folders; build the rename map from the inventory
- [ ] 4. Scaffold structure files (layout guide, root/local AGENTS.md, split routing, backlog, structure rule)
- [ ] 5. Rewrite addresses and relative links everywhere
- [ ] 6. Fix .gitignore for the repo type
- [ ] 7. Remove legacy tool mirrors (with confirmation)
- [ ] 8. Verify and report
```

### 1. Identify target, type, and readiness

Resolve the three inputs above. Record repo type; it drives scaffolding
wording, link style, steps 6 and 8, and whether `reference/` / `skills/` may
exist under `.team_manifest/`.

### 2. Inventory

List, as seen from the target root:

- `.team_manifest/**` and `.local_manifest/**` (follow the symlink on `team`).
- `.agents/**`. Expected:
  - `team`: `skills/team` and `skills/local`, both symbolic links.
  - `solo`: `skills/local` as a symbolic link. `skills/team` only if
    `.team_manifest/skills/` exists (it should not in a correct solo setup).
  Anything else under `.agents/` is a **legacy leftover** — a real folder or
  an old per-folder symlink the user has not yet moved or removed. Stop and
  list leftovers; do not proceed until the user resolves them.
- Search the **whole target repo** (skip build output and binaries) for the
  strings `.agents/`, `.agents\`, `references/`, and `teaching`. Cover root
  `*.md`, `*.yml`, `*.yaml`, `.gitignore`, `.ignore`, `.vscode/**`,
  `.github/**`, `docs/**`, and every file in both trees. Also list `../`
  links whose target does not resolve from the file's current location.

Also check for legacy mirror folders and unexpected files at
`.team_manifest/` root. Preserve unexpected files and list them for review.
List copied `apply-manifest-template`, `sync-manifest-template`,
`migrate-manifest-layout`, or `create-github-repo` skill folders. These
workspace tools belong only in this template; ask the user to preserve any
customizations and remove the target copies before continuing.

In `solo`, if `.team_manifest/reference/` or `.team_manifest/skills/` exists,
flag them as misplaced; the user should have put those under
`.local_manifest/`. Do not move them (rule 1).

### 3. Rename stale folders and build the rename map

**Canonical folder names.** If either tree still has these old names, rename
in place with `git mv` (tracked tree) or a normal move (gitignored local tree
on `team`):

| On disk now | Canonical name |
|---|---|
| `references/` | `reference/` |
| `teaching/` | `learning/` (under `.local_manifest/`) |
| `learnings/` | `learning/` |

If both `teaching/` and `learning/` exist, do not merge; ask the user.

Then, for each legacy reference `.agents/<folder>/<rest>` found in step 2,
resolve the new path using the ownership table and the **alias table** in
[`reference.md`](reference.md#folder-ownership).

- **Fixed folders** map by rule: `adr`, `actions`, `guides`, `personas`,
  `rules` → `.team_manifest/<folder>/<rest>`; `plans`, `findings`, `learning`,
  `scratch` → `.local_manifest/<folder>/<rest>`. Treat `teaching` and
  `learnings` as `learning`.
- **`solo` split folders:** every `reference/<file>` and `skills/<name>/` maps
  to `.local_manifest/...`. Do not look under `.team_manifest/` for them.
- **`team` split folders** (`skills`, `reference`) resolve by lookup: find
  `<rest>` under `.team_manifest/<folder>/` and `.local_manifest/<folder>/`.
  Treat `references/` as `reference/`.
  - Found in exactly one tree → map there.
  - Found in both → **ambiguous**; ask the user which is canonical and flag the
    duplicate (duplicate skill names break OpenCode and Copilot discovery).
  - Found in neither → **dangling**; add to the residual list. Do not invent a
    path.
- **Special files:**
  - `plans/backlog.plan.md` → `.team_manifest/backlog.plan.md`.
  - `rules/routing.rule.md` → depends on the *referencing* file: a file in
    `.team_manifest/` points to the routing file in that tree; a file in
    `.local_manifest/` points to the routing file in that tree; root
    `AGENTS.md` points to both.
  - `rules/manifest-structure.rule.md` and `rules/terms.rule.md` →
    `.team_manifest/rules/...`.

Write the map down (a table in your working notes) before editing anything, and
show it to the user if it has any ambiguous or dangling rows, or if any folder
was renamed.

### 4. Scaffold structure files

Create or rewrite these, using the **repo-type** entry-point templates in
[`manifest-layout.md`](../../../.team_manifest/guides/manifest-layout.md).
Keep the target's existing project mandates and real routing rows; only the
structure changes.

- **`.team_manifest/guides/manifest-layout.md`** — copy the canonical guide
  from this template so the migrated repo owns its permanent layout contract.
- **Root `AGENTS.md`.** Keep the target's existing first-read file if it
  already names one (for example a project-wide `global.rule.md`). Only insert
  the two-directory description and the read of `.local_manifest/AGENTS.md`.
  In `solo` and `team`, that local file is present — write "read it", never
  "if it exists" / "if the local manifest is present". Carry over the
  target's real mandates verbatim.
- **`.local_manifest/AGENTS.md`** — create only if missing, from the
  repo-type template. Never overwrite an existing one. Still **verify** it:
  it must point at `rules/routing.rule.md` in the local tree, not the team
  routing file. If that one link is wrong, fix only that link.
- **Split routing.** Take the old `routing.rule.md`. Do not replace the file
  with the template. Split it **row by row**. Rows whose target now lives
  under `.team_manifest/` stay in `.team_manifest/rules/routing.rule.md`;
  add a row for `backlog.plan.md`. Rows whose target now lives under
  `.local_manifest/` go to
  `.local_manifest/rules/routing.rule.md`. Extra sections the target already
  had stay. Create the local file if missing. Keep each row's wording.
- **`.team_manifest/backlog.plan.md`** — if it is still under
  `.local_manifest/plans/`, ask the user to move it (rule 1), then route to it.
- **`.team_manifest/rules/manifest-structure.rule.md`** — preserve its
  folder-by-folder rules, fix stale `.agents/` paths, and add a link to the
  canonical `manifest-layout.md` guide copied into `.team_manifest/guides/`.
- **`.team_manifest/rules/terms.rule.md`** — add the terms listed for this
  repo type in the template if they are absent. `solo` does not get the
  team-versus-local ownership terms.

### 5. Rewrite addresses and links

Apply the map and the alias table to every file from step 2 **except**
`plans/archive/` (leave archive prose and historical paths alone unless the
user asks) and `plans/example-epic/` content beyond its own links
(template-only):

- Replace path strings (`.agents/x/y`, `.agents/references/`,
  `.agents/teaching/`) with the mapped path. Use root-relative form in prose
  and in root-level files.
- For **relative markdown links**, recompute from the file's *new* location as
  seen from the repo root. See
  [`reference.md`](reference.md#relative-link-rewrite-rules).
  - `solo`: always a full relative link (both trees are tracked).
  - `team`: assume `.local_manifest/` is present; write a full relative link
    through that symlink. Only when the specific local file may be missing,
    write a code-span filename plus "if available" and do not invent a path.
- Skills that *write* files (planning skills writing to `plans/`,
  `wrap-up-plan` writing reference docs) must now name the local tree
  explicitly: `.local_manifest/plans/`, `.local_manifest/reference/`.

Work file by file. After each file, check same-tree and (for `solo`)
cross-tree links resolve. In `team`, a full `.local_manifest/...` link is
expected when the file exists in the inventory.

### 6. `.gitignore`

Merge the block for the repo type from
[`manifest-layout.md`](../../../.team_manifest/guides/manifest-layout.md#ignore-rules)
into the target's `.gitignore`.
Remove obsolete entries `.cursor/`, `.github/skills`, `.github/agents` only if
step 7 removed those folders.

- `solo`: `.local_manifest/` itself must **not** be ignored. Only
  `.local_manifest/scratch/` (and `.agents/`) are ignored. If a copied team
  block ignores `.local_manifest/`, remove that line.
- `team`: remind the user to ignore `scratch/` in the private repo. If the
  target has a `.ignore` (or similar search-tool ignore file), merge the
  search-tool block from the layout guide so agents can still see the
  gitignored local tree.

### 7. Legacy tool mirrors

With the shim in place, `.cursor/`, `.github/skills`, `.github/agents`,
`.github/instructions`, and `.github/prompts` are no longer needed for
discovery. List what each contains. If everything inside is a symlink or a copy
of manifest content, propose deletion and delete on confirmation. If a folder
holds real, unmirrored content, leave it and list it. Never touch
`.github/workflows/` or other non-manifest `.github/` content.

### 8. Verify and report

Check, and print the results:

- `solo`: `.agents/skills/local` is a real symbolic link and resolves.
  `.local_manifest` is a real folder, not a symlink, and is **not** in
  `.gitignore`. `.team_manifest/reference/` and `.team_manifest/skills/` are
  absent (flag if present).
- `team`: `.agents/skills/team` and `.agents/skills/local` are real symbolic
  links and resolve. `.local_manifest` is a symbolic link that resolves.
- No skill folder name exists in both `skills/` trees, and each `SKILL.md`
  `name` equals its folder name.
- No template-side apply, sync, migrate, or GitHub-repo creation skill remains
  in the target manifest.
- No remaining `.agents/` reference except in the shim description of root
  `AGENTS.md`, `manifest-structure.rule.md`, and `guides/manifest-layout.md`.
- No leftover `references/` folder name or `.agents/teaching` string outside
  `plans/archive/`.
- Same-tree relative links resolve. Cross-tree links follow hard rule 4.
- `.gitignore` matches the repo type. `solo` tracks `.local_manifest/`.

Run these searches (skip `plans/archive/` and build output) and put any hits
on the residual list:

- leftover `.agents/` except the allowed structural mentions,
- leftover `references/` after the rename to `reference/`,
- leftover `teaching`,
- the private-repo physical path written into any document.

Then report: the rename map applied (including folder renames), files created
and edited, mirrors removed, the residual list (ambiguous, dangling,
misplaced-looking files, unexpected team-root files), and next steps: restart
the editor and type `/` in chat to confirm skills appear; commit
`.team_manifest/` **and**, for `solo`, commit `.local_manifest/` in the same
repo; for `team`, commit the private repo that backs `.local_manifest/`.

## Decision tree

```
Manual moves done?
├─ No .............................. STOP: hand over user-setup.md
└─ Yes
   Legacy leftovers under .agents/ ?
   ├─ Yes ........................... STOP: list them, user resolves
   └─ No
      Old folder names references/ or teaching/ ?
      ├─ Yes ........................ rename in place (or ask if both teaching and learning exist)
      └─ No
         Split-folder reference resolves to
         ├─ solo ..................... map to .local_manifest/
         ├─ team, one tree ........... map it
         ├─ team, both trees ......... ASK; flag duplicate skill name
         └─ neither .................. residual list, never invent
```

## Completion checks

- `.team_manifest/guides/manifest-layout.md` exists and is the canonical layout
  and setup reference.
- Root `AGENTS.md` describes both directories and the shim and points at both
  routing files. The local `AGENTS.md` read is unconditional.
- `solo`: both trees are tracked; `reference/` and `skills/` live only under
  `.local_manifest/`.
- `.team_manifest/rules/routing.rule.md` and
  `.local_manifest/rules/routing.rule.md` exist. Each routes into its own
  tree (plus `backlog.plan.md` in the team file).
- No unmapped `.agents/` addresses remain outside the allowed shim mentions.
  Archive trees were left alone.
- `.gitignore` matches the repo type; `solo` commits `.local_manifest/`;
  legacy mirrors handled per user decision.
- The report lists the residual items instead of silently resolving them.
