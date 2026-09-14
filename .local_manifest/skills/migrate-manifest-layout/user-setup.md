# Manual setup before `migrate-manifest-layout`

What **you** create and move by hand in an **existing** repository that still
has the legacy single `.agents/` tree. The skill does not create folders, move
files, or create symlinks; it only repairs addresses afterwards. Finish every
step for your repo type, then invoke the skill.

For a brand-new repo with no manifest yet, use
`apply-manifest-template/user-setup.md` instead.

## 0. Decide the repo type

Choose `solo` when one person owns the repository. Choose `team` when several
people share it and each person needs a private local manifest. See the
canonical definitions and layouts in
[`manifest-layout.md`](../../../.team_manifest/guides/manifest-layout.md).
Tell the migration skill which type you chose; it will verify that choice
against `.local_manifest` after the manual setup.

Placeholders used below:

- `<repo>` — the repository being migrated.
- `<PRIVATE>` — your private manifest repository. Team repos only.
- `<LOCAL>` — the folder that *is* the `.local_manifest/` tree:
  - `solo`: `<repo>\.local_manifest` (tracked in this repo)
  - `team`: the project folder inside the private repo. Its inner folder name
    does not matter because the symlink hides it.

Names such as `honeycomb-code` and its local-manifest repository are examples
only. Substitute the actual target and private repository paths.

Canonical folder names (rename before you invoke the skill if you still have
the old names):

- `reference/` not `references/`
- `learning/` not `teaching/` or `learnings/`

On `team`, if a team ADR is paired with a `*.ref.md`, put that ref in
`.team_manifest\reference`.

## 1. Move content into the target layout

Create the target folder set shown in `manifest-layout.md`, then use this
migration map:

Where each legacy folder goes:

| Legacy `.agents\<folder>` | `solo` | `team` |
|---|---|---|
| `adr`, `actions`, `guides`, `personas` | `.team_manifest\<folder>` | `.team_manifest\<folder>` |
| `rules\manifest-structure.rule.md`, `rules\terms.rule.md`, `rules\routing.rule.md` | `.team_manifest\rules\` | `.team_manifest\rules\` (the skill later splits routing) |
| `plans\backlog.plan.md` | `.team_manifest\backlog.plan.md` | `.team_manifest\backlog.plan.md` |
| `plans\` (everything else), `findings`, `learning`, `scratch` | `.local_manifest\<folder>` | `<LOCAL>\<folder>` |
| `reference\<file>` | **all** under `.local_manifest\reference` | your choice: team if everyone must know it |
| `skills\<name>` | **all** under `.local_manifest\skills` | your choice: team if everyone must have it |
| `teaching\` or `learnings\` | rename to `.local_manifest\learning` | rename to `<LOCAL>\learning` |
| `references\` | rename to `reference\` in the tree that holds it | same |

Do not move `apply-manifest-template`, `sync-manifest-template`,
`migrate-manifest-layout`, or `create-github-repo` into the target manifest.
They remain in this template and run from the shared workspace. Preserve any
target-specific customizations before removing an old copied version.

Rules for the split folders on `team`:

- A skill folder name may exist in **one** tree only, and its `SKILL.md`
  `name` must equal the folder name. Duplicates break OpenCode and Copilot
  discovery.
- Repo-specific runbooks that everyone needs are team; the SDD flow
  (`grill-*`, `spec-to-plan`, `plan-to-criteria`,
  `implement-plan`, `archive-plan`, `wrap-up-plan`), `debug-agent`,
  `review-changes`, and `planning-flow.ref.md` are local.

On `solo` there is no split: do not leave any skill or `*.ref.md` under
`.team_manifest\`.

## 2a. `solo` repo — steps

Windows PowerShell from `<repo>`. Use `git mv` so history follows the files.
`.local_manifest\` stays in this git repo and must be committed.

```powershell
cd <repo>
git mv .agents .team_manifest
New-Item -ItemType Directory -Force -Path .\.local_manifest\rules, .\.local_manifest\scratch
foreach ($d in 'plans','findings','learning','reference','skills') {
  if (Test-Path ".\.team_manifest\$d") { git mv ".\.team_manifest\$d" ".\.local_manifest\$d" }
}
if (Test-Path .\.team_manifest\references) {
  git mv .\.team_manifest\references .\.local_manifest\reference
}
if (Test-Path .\.local_manifest\references) {
  git mv .\.local_manifest\references .\.local_manifest\reference
}
foreach ($old in 'teaching','learnings') {
  if (Test-Path ".\.team_manifest\$old") { git mv ".\.team_manifest\$old" ".\.local_manifest\learning" }
  if (Test-Path ".\.local_manifest\$old") { git mv ".\.local_manifest\$old" ".\.local_manifest\learning" }
}
if (Test-Path .\.team_manifest\plans\backlog.plan.md) {
  git mv .\.team_manifest\plans\backlog.plan.md .\.team_manifest\backlog.plan.md
}
New-Item -ItemType File -Force -Path .\.local_manifest\AGENTS.md, .\.local_manifest\rules\routing.rule.md
```

Do not create `.team_manifest\reference` or `.team_manifest\skills`. If both
`teaching\` and `learning\` (or both `references\` and `reference\`) exist,
stop and pick one name; do not merge them.

Then create the shim (section 3) and continue with section 4.

## 2b. `team` repo — steps

The repo's current `.agents\` is a folder of per-folder symlinks into
`<LOCAL>`. The personal content already lives in the private repo; only team
content moves out of it into the tracked `.team_manifest\`.

1. **Remove the old per-folder links** without touching their targets.
   `rmdir` deletes only the link; never use `Remove-Item -Recurse` on a
   directory symlink in Windows PowerShell 5.1.

   ```powershell
   cd <repo>
   Get-ChildItem .\.agents -Force | Where-Object { $_.LinkType -eq 'SymbolicLink' } |
     ForEach-Object { cmd /c rmdir "$($_.FullName)" }
   Remove-Item .\.agents   # now an empty folder
   ```

2. **Create the team tree** in the repo:

   ```powershell
   New-Item -ItemType Directory -Force -Path `
     .\.team_manifest\actions, .\.team_manifest\adr, .\.team_manifest\guides, `
     .\.team_manifest\personas, .\.team_manifest\rules, .\.team_manifest\reference, `
     .\.team_manifest\skills
   ```

3. **Move team content out of the private repo** into `.team_manifest\`:
   `adr`, `actions`, `guides`, `personas`, the three `rules\*.rule.md`,
   `plans\backlog.plan.md` (to the team root), and the team-owned reference
   docs and skills. Cross-repo moves lose git history; that is accepted.
   Rename `references\` → `reference\` and `teaching\` → `learning\` if those
   old names are still on disk.

4. **In `<LOCAL>`** keep `plans`, `findings`, `learning`, `scratch`, personal
   reference docs and skills. Add empty `AGENTS.md` and
   `rules\routing.rule.md`. Add the private-repo scratch ignore rule from the
   layout guide.

5. **One symlink for the whole personal tree**, then the shim (section 3).
   Use the `.local_manifest` link command in `manifest-layout.md`.

## 3. The `.agents\` shim

Create the links exactly as shown in
[`manifest-layout.md`](../../../.team_manifest/guides/manifest-layout.md).
The solo local link intentionally uses the relative target
`../../.local_manifest/skills`.

## 4. `.gitignore`

The skill fixes ignore rules later. If you commit before invoking it, use the
matching blocks from
[`manifest-layout.md`](../../../.team_manifest/guides/manifest-layout.md).

## 5. Verify, then invoke

```powershell
Get-ChildItem .\.agents\skills -Force | Select-Object Name, LinkType, Target
Get-Item      .\.local_manifest       | Select-Object Name, LinkType, Target
Get-ChildItem .\.local_manifest -Force | Select-Object Name
```

Checklist:

- `.agents\` contains only the skill symlink(s): `solo` has `local`; `team`
  has `team` and `local`. Each is `SymbolicLink`.
- `team`: `.local_manifest` is a `SymbolicLink` to `<LOCAL>`; `solo`: it is a
  real folder and is **not** listed in `.gitignore`.
- `solo`: no `reference\` or `skills\` under `.team_manifest\`.
- No skill folder name exists in both `skills` trees (`team` only).
- `backlog.plan.md` sits at `.team_manifest\` root.
- Folder names are `reference\` and `learning\`, not `references\` or
  `teaching\`.
- `<LOCAL>\AGENTS.md` and `<LOCAL>\rules\routing.rule.md` exist (stubs are fine).
- Restart the editor, type `/` in chat, and confirm skills appear.

Leave the root `AGENTS.md` and every internal link alone; invoke
`migrate-manifest-layout` and it rewrites them.
