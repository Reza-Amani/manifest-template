# Manual setup before `migrate-manifest-layout`

What **you** create and move by hand in an **existing** repository that still
has the legacy single `.agents/` tree. The skill does not create folders, move
files, or create symlinks; it only repairs addresses afterwards. Finish every
step for your repo type, then invoke the skill.

For a brand-new repo with no manifest yet, use
`apply-manifest-template/user-setup.md` instead.

## 0. Decide the repo type

| | `solo` | `team` |
|---|---|---|
| Who uses the repo | only you | several people |
| `.team_manifest/` | real folder, tracked | real folder, tracked |
| `.local_manifest/` | real folder, **tracked** (commit it) | **one** symlink to your private repo; gitignored |
| `.agents/` shim | gitignored, recreated per machine | gitignored, recreated per machine |
| Where `scratch/` is ignored | this repo's `.gitignore` | the private repo's `.gitignore` |
| `reference/` and `skills/` | only under `.local_manifest/` | your split: team if everyone must have it |

Placeholders used below:

- `<repo>` — the repository being migrated, e.g. `C:\git\honeycomb-code`.
- `<PRIVATE>` — your private manifest repo, e.g.
  `C:\git\FW-local-agent-instructions`. Team repos only.
- `<LOCAL>` — the folder that *is* the `.local_manifest/` tree:
  - `solo`: `<repo>\.local_manifest` (tracked in this repo)
  - `team`: the project folder inside the private repo, e.g.
    `<PRIVATE>\honeycomb-code\.agents`. The inner folder name does not matter;
    the symlink hides it.

Canonical folder names (rename before you invoke the skill if you still have
the old names):

- `reference/` not `references/`
- `learning/` not `teaching/` or `learnings/`

If you have a shared `todo.plan.md`, leave it at `.team_manifest\` root. It is
not the backlog.

On `team`, if a team ADR is paired with a `*.ref.md`, put that ref in
`.team_manifest\reference`.

## 1. Target folder set

### `solo`

Do **not** create `reference\` or `skills\` under `.team_manifest\`. Every
reference doc and every skill goes under `.local_manifest\`. `.team_manifest\`
is there so the folder names match a team repo.

```text
<repo>\.team_manifest\
  backlog.plan.md
  actions\  adr\  guides\  personas\  rules\

<repo>\.local_manifest\          # tracked; commit this tree
  AGENTS.md                 # stub is enough; the skill fills it
  rules\routing.rule.md     # stub is enough; the skill fills it
  plans\  findings\  learning\  reference\  scratch\  skills\
```

### `team`

```text
<repo>\.team_manifest\
  backlog.plan.md
  actions\  adr\  guides\  personas\  reference\  rules\  skills\

<LOCAL>\
  AGENTS.md                 # stub is enough; the skill fills it
  rules\routing.rule.md     # stub is enough; the skill fills it
  plans\  findings\  learning\  reference\  scratch\  skills\
```

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
| anything `operation-*` | delete | delete |

Rules for the split folders on `team`:

- A skill folder name may exist in **one** tree only, and its `SKILL.md`
  `name` must equal the folder name. Duplicates break OpenCode and Copilot
  discovery.
- Expected default: `apply-manifest-template`, `sync-manifest-template`,
  `migrate-manifest-layout`, `create-github-repo`, and repo runbooks are team;
  the SDD flow (`grill-*`, `spec-to-plan`, `plan-to-criteria`,
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
git rm -r .\.local_manifest\skills\operation-* .\.local_manifest\reference\operation-* 2>$null
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
   `rules\routing.rule.md`. Delete `operation-*` files. Add `*/scratch/` to
   `<PRIVATE>\.gitignore`.

5. **One symlink for the whole personal tree**, then the shim (section 3):

   ```powershell
   cd <repo>
   New-Item -ItemType SymbolicLink -Path .\.local_manifest -Target '<LOCAL>'
   ```

   cmd equivalent: `mklink /D <repo>\.local_manifest <LOCAL>`

## 3. The `.agents\` shim

Symlink creation needs an elevated PowerShell or Windows Developer Mode.
Absolute targets are fine; the shim is gitignored and machine-specific. Point
`skills\local` straight at `<LOCAL>\skills`, not through
`.local_manifest\skills`, to avoid chained-symlink resolution on `team`.

### `solo`

Only a `local` skill link. There is no `.team_manifest\skills`.

```powershell
cd <repo>
New-Item -ItemType Directory    -Force -Path .\.agents\skills
New-Item -ItemType SymbolicLink -Path .\.agents\skills\local -Target "$PWD\.local_manifest\skills"
```

```cmd
mklink /D <repo>\.agents\skills\local  <repo>\.local_manifest\skills
```

```bash
cd <repo>
mkdir -p .agents/skills
ln -s ../../.local_manifest/skills .agents/skills/local
```

### `team`

```powershell
cd <repo>
$local = '<LOCAL>'
New-Item -ItemType Directory    -Force -Path .\.agents\skills
New-Item -ItemType SymbolicLink -Path .\.agents\skills\team  -Target "$PWD\.team_manifest\skills"
New-Item -ItemType SymbolicLink -Path .\.agents\skills\local -Target "$local\skills"
```

```cmd
mklink /D <repo>\.agents\skills\team   <repo>\.team_manifest\skills
mklink /D <repo>\.agents\skills\local  <LOCAL>\skills
```

```bash
cd <repo>
ln -s <LOCAL> .local_manifest
mkdir -p .agents/skills
ln -s ../../.team_manifest/skills .agents/skills/team
ln -s <LOCAL>/skills              .agents/skills/local
```

Nothing else goes into `.agents\`. Skills are the only thing Cursor, VS Code
Copilot, and OpenCode auto-discover there; rules and personas are reached
through `AGENTS.md` → routing.

## 4. `.gitignore`

The skill merges the right block in step 6, but if you commit before invoking
it, add the block for your repo type from
[`reference.md`](reference.md#gitignore-blocks) now.

- Never ignore `.team_manifest\`.
- `solo`: never ignore `.local_manifest\` itself; only
  `.local_manifest\scratch\` (and `.agents\`). Commit `.local_manifest\`
  with the rest of the repo.

On `team`, if the repo uses a `.ignore` file so search tools can see
gitignored paths, add the un-ignore block from
[`reference.md`](reference.md#ignore-blocks).

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
- No `operation-*` files remain.
- Restart the editor, type `/` in chat, and confirm skills appear.

Leave the root `AGENTS.md` and every internal link alone; invoke
`migrate-manifest-layout` and it rewrites them.

## Example: `honeycomb-code` (`team`)

```powershell
cd C:\git\honeycomb-code
$local = 'C:\git\FW-local-agent-instructions\honeycomb-code\.agents'
New-Item -ItemType SymbolicLink -Path .\.local_manifest      -Target $local
New-Item -ItemType Directory    -Force -Path .\.agents\skills
New-Item -ItemType SymbolicLink -Path .\.agents\skills\team  -Target 'C:\git\honeycomb-code\.team_manifest\skills'
New-Item -ItemType SymbolicLink -Path .\.agents\skills\local -Target "$local\skills"
```

```cmd
mklink /D C:\git\honeycomb-code\.local_manifest      C:\git\FW-local-agent-instructions\honeycomb-code\.agents
mklink /D C:\git\honeycomb-code\.agents\skills\team  C:\git\honeycomb-code\.team_manifest\skills
mklink /D C:\git\honeycomb-code\.agents\skills\local C:\git\FW-local-agent-instructions\honeycomb-code\.agents\skills
```
