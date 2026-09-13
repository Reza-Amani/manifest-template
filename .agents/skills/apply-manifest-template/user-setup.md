# Manual setup before `apply-manifest-template`

What **you** create by hand in a repository that has **no manifest yet**. The
skill writes the documents; it does not create the tree roots or symlinks,
because those depend on your machine and on whether the repo is shared.
Finish every step for your repo type, then invoke the skill.

If the repo already has a legacy `.agents/` tree with content, use
`migrate-manifest-layout/user-setup.md` instead.

## 0. Decide the repo type

| | `solo` | `team` |
|---|---|---|
| Who uses the repo | only you | several people |
| `.team_manifest/` | real folder, tracked | real folder, tracked |
| `.local_manifest/` | real folder, tracked | **one** symlink to your private repo; gitignored |
| `.agents/` shim | gitignored, recreated per machine | gitignored, recreated per machine |
| Where `scratch/` is ignored | this repo's `.gitignore` | the private repo's `.gitignore` |

Placeholders:

- `<repo>` — the new repository, e.g. `C:\git\my-service`.
- `<PRIVATE>` — your private manifest repo, e.g.
  `C:\git\FW-local-agent-instructions`. Team repos only.
- `<LOCAL>` — the folder that *is* your personal tree:
  - `solo`: `<repo>\.local_manifest`
  - `team`: a project folder you create inside the private repo, e.g.
    `<PRIVATE>\my-service`. Its name is yours to choose; the symlink hides it.

## 1. Folders to create

```text
<repo>\.team_manifest\
  actions\  adr\  guides\  personas\  reference\  rules\  skills\

<LOCAL>\
  rules\  plans\  findings\  learning\  reference\  scratch\  skills\
```

The skill fills them: root `AGENTS.md`, `.team_manifest\backlog.plan.md`, the
three team rules, team skills, and the local `AGENTS.md` plus
`rules\routing.rule.md` and the personal SDD skills.

### `solo`

```powershell
cd <repo>
New-Item -ItemType Directory -Force -Path `
  .\.team_manifest\actions, .\.team_manifest\adr, .\.team_manifest\guides, `
  .\.team_manifest\personas, .\.team_manifest\reference, .\.team_manifest\rules, `
  .\.team_manifest\skills, `
  .\.local_manifest\rules, .\.local_manifest\plans, .\.local_manifest\findings, `
  .\.local_manifest\learning, .\.local_manifest\reference, .\.local_manifest\scratch, `
  .\.local_manifest\skills
```

### `team`

Create the team tree in the repo and the personal tree in the private repo,
then link the personal tree in with **one** symlink:

```powershell
cd <repo>
New-Item -ItemType Directory -Force -Path `
  .\.team_manifest\actions, .\.team_manifest\adr, .\.team_manifest\guides, `
  .\.team_manifest\personas, .\.team_manifest\reference, .\.team_manifest\rules, `
  .\.team_manifest\skills

$local = '<LOCAL>'
New-Item -ItemType Directory -Force -Path `
  "$local\rules", "$local\plans", "$local\findings", "$local\learning", `
  "$local\reference", "$local\scratch", "$local\skills"
New-Item -ItemType SymbolicLink -Path .\.local_manifest -Target $local
```

cmd equivalent for the link: `mklink /D <repo>\.local_manifest <LOCAL>`

Add `*/scratch/` to `<PRIVATE>\.gitignore` once; it covers every project folder
in the private repo.

## 2. The `.agents\` shim (both repo types)

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
through `AGENTS.md` → routing. Every teammate recreates the shim (and, in team
repos, the `.local_manifest` link) on their own machine after cloning.

## 3. `.gitignore`

Merge the block for your repo type into `<repo>\.gitignore`; create the file if
missing. Never ignore `.team_manifest\`.

`solo`:

```gitignore
# Agent manifest: .agents/ is a discovery shim of symlinks, recreated per machine
.agents/
.local_manifest/scratch/
```

`team`:

```gitignore
# Agent manifest: personal tree and discovery shim are per-person, not shared
.agents/
.local_manifest/
```

## 4. Verify, then invoke

```powershell
Get-ChildItem .\.agents\skills -Force | Select-Object Name, LinkType, Target
Get-Item      .\.local_manifest       | Select-Object Name, LinkType, Target   # team: SymbolicLink
```

Checklist:

- `.agents\` contains only `skills\team` and `skills\local`, both `SymbolicLink`.
- `team`: `.local_manifest` is a `SymbolicLink` to `<LOCAL>`; `solo`: it is a
  real folder.
- Both trees have the folder set from section 1.
- `.gitignore` matches the repo type.

Then open the template repo alongside `<repo>` in one workspace and invoke
`apply-manifest-template`.
