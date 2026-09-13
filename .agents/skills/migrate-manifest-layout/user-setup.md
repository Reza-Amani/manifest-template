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
| `.local_manifest/` | real folder, tracked | **one** symlink to your private repo; gitignored |
| `.agents/` shim | gitignored, recreated per machine | gitignored, recreated per machine |
| Where `scratch/` is ignored | this repo's `.gitignore` | the private repo's `.gitignore` |

Placeholders used below:

- `<repo>` — the repository being migrated, e.g. `C:\git\honeycomb-code`.
- `<PRIVATE>` — your private manifest repo, e.g.
  `C:\git\FW-local-agent-instructions`. Team repos only.
- `<LOCAL>` — the folder that *is* your personal tree:
  - `solo`: `<repo>\.local_manifest`
  - `team`: the project folder inside the private repo, e.g.
    `<PRIVATE>\honeycomb-code\.agents`. The inner folder name does not matter;
    the symlink hides it.

## 1. Target folder set

Both trees must end up with exactly these folders (empty folders are fine):

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

| Legacy `.agents\<folder>` | New home |
|---|---|
| `adr`, `actions`, `guides`, `personas` | `.team_manifest\<folder>` |
| `rules\manifest-structure.rule.md`, `rules\terms.rule.md`, `rules\routing.rule.md` | `.team_manifest\rules\` (the skill later splits routing into team + local) |
| `plans\backlog.plan.md` | `.team_manifest\backlog.plan.md` |
| `plans\` (everything else), `findings`, `learning`, `scratch` | `<LOCAL>\<folder>` |
| `reference\<file>` | your choice: team if everyone must know it, else `<LOCAL>\reference` |
| `skills\<name>` | your choice: team if everyone must have it, else `<LOCAL>\skills` |
| anything `operation-*` | delete |

Rules for the split folders:

- A skill folder name may exist in **one** tree only, and its `SKILL.md`
  `name` must equal the folder name. Duplicates break OpenCode and Copilot
  discovery.
- Expected default: `apply-manifest-template`, `sync-manifest-template`,
  `migrate-manifest-layout`, `create-github-repo`, and repo runbooks are team;
  the SDD flow (`grill-*`, `spec-to-plan`, `plan-to-criteria`,
  `implement-plan`, `archive-plan`, `wrap-up-plan`), `debug-agent`,
  `review-changes`, and `planning-flow.ref.md` are local.

## 2a. `solo` repo — steps

Windows PowerShell from `<repo>`. Use `git mv` so history follows the files.

```powershell
cd <repo>
git mv .agents .team_manifest
New-Item -ItemType Directory -Force -Path .\.local_manifest\rules, .\.local_manifest\scratch
foreach ($d in 'plans','findings','learning') { git mv ".\.team_manifest\$d" ".\.local_manifest\$d" }
git mv .\.local_manifest\plans\backlog.plan.md .\.team_manifest\backlog.plan.md
# reference docs and skills you consider personal:
git mv .\.team_manifest\reference\<file>.ref.md .\.local_manifest\reference\<file>.ref.md
git mv .\.team_manifest\skills\<name>            .\.local_manifest\skills\<name>
New-Item -ItemType File -Force -Path .\.local_manifest\AGENTS.md, .\.local_manifest\rules\routing.rule.md
git rm -r .\.team_manifest\skills\operation-* .\.team_manifest\reference\operation-* 2>$null
```

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

## 3. The `.agents\` shim (both repo types)

Symlink creation needs an elevated PowerShell or Windows Developer Mode.
Absolute targets are fine; the shim is gitignored and machine-specific. Point
`skills\local` straight at `<LOCAL>\skills`, not through
`.local_manifest\skills`, to avoid chained-symlink resolution.

```powershell
cd <repo>
$local = '<LOCAL>'
New-Item -ItemType Directory    -Force -Path .\.agents\skills
New-Item -ItemType SymbolicLink -Path .\.agents\skills\team  -Target "$PWD\.team_manifest\skills"
New-Item -ItemType SymbolicLink -Path .\.agents\skills\local -Target "$local\skills"
```

cmd equivalents:

```cmd
mklink /D <repo>\.agents\skills\team   <repo>\.team_manifest\skills
mklink /D <repo>\.agents\skills\local  <LOCAL>\skills
```

macOS/Linux:

```bash
cd <repo>
ln -s <LOCAL> .local_manifest            # team repos only
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
[`reference.md`](reference.md#gitignore-blocks) now. Never ignore
`.team_manifest\`.

## 5. Verify, then invoke

```powershell
Get-ChildItem .\.agents\skills -Force | Select-Object Name, LinkType, Target
Get-Item      .\.local_manifest       | Select-Object Name, LinkType, Target   # team: SymbolicLink
Get-ChildItem .\.local_manifest -Force | Select-Object Name
```

Checklist:

- `.agents\` contains only `skills\team` and `skills\local`, both `SymbolicLink`.
- `team`: `.local_manifest` is a `SymbolicLink` to `<LOCAL>`; `solo`: it is a
  real folder.
- No skill folder name exists in both `skills` trees.
- `backlog.plan.md` sits at `.team_manifest\` root.
- `<LOCAL>\AGENTS.md` and `<LOCAL>\rules\routing.rule.md` exist (stubs are fine).
- No `operation-*` files remain.
- Restart the editor, type `/` in chat, and confirm skills from both `team`
  and `local` appear.

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
