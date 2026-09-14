# Manifest Layout

This guide is the source of truth for the physical manifest layout, repo-type
differences, discovery shim, setup commands, and ignore rules.

## Choose and detect the repo type

- **solo** — one person owns the repo. `.local_manifest/` is a real, tracked
  directory.
- **team** — several people share the repo. `.local_manifest/` is one
  gitignored symlink to a project folder in a private manifest repository.

For a new manifest, the user chooses the type during manual setup and
`apply-manifest-template` confirms it. After setup, detect it from
`.local_manifest`:

- real directory → `solo`
- symbolic link → `team`

`migrate-manifest-layout` confirms the user's choice and verifies the resulting
link type. `sync-manifest-template` reads the link type because it only runs on
an already-applied or migrated manifest.

## Canonical layouts

### Solo

```text
<repo>/
├── AGENTS.md
├── .team_manifest/           # tracked
│   ├── backlog.plan.md
│   ├── actions/
│   ├── adr/
│   ├── guides/
│   ├── personas/
│   └── rules/
├── .local_manifest/          # tracked real directory
│   ├── AGENTS.md
│   ├── rules/routing.rule.md
│   ├── plans/
│   ├── findings/
│   ├── learning/
│   ├── reference/
│   ├── scratch/              # gitignored
│   └── skills/
└── .agents/                  # gitignored discovery shim
    └── skills/
        └── local -> ../../.local_manifest/skills
```

Do not create `.team_manifest/reference/` or `.team_manifest/skills/` in a solo
repo.

### Team

```text
<repo>/
├── AGENTS.md
├── .team_manifest/           # tracked
│   ├── backlog.plan.md
│   ├── actions/
│   ├── adr/
│   ├── guides/
│   ├── personas/
│   ├── reference/            # mechanics everyone must know
│   ├── rules/
│   └── skills/               # skills everyone must have
├── .local_manifest/          # gitignored symlink to <LOCAL>
│   ├── AGENTS.md
│   ├── rules/routing.rule.md
│   ├── plans/
│   ├── findings/
│   ├── learning/
│   ├── reference/
│   ├── scratch/
│   └── skills/
└── .agents/                  # gitignored discovery shim
    └── skills/
        ├── team  -> ../../.team_manifest/skills
        └── local -> <LOCAL>/skills
```

Skill folder names must be unique across the two trees.

A repository may keep an optional, near-empty `.team_manifest/todo.plan.md` as
a lightweight near-term checklist. It is not the canonical backlog and does
not need special routing or migration behavior.

## Folder ownership

| Content | Solo | Team |
|---|---|---|
| ADRs, actions, guides, personas, project rules, backlog | `.team_manifest/` | `.team_manifest/` |
| Plans, findings, learning, scratch | `.local_manifest/` | `.local_manifest/` |
| References and skills | `.local_manifest/` only | Team-wide items in `.team_manifest/`; personal items in `.local_manifest/` |
| Root entry point | `AGENTS.md` | `AGENTS.md` |
| Local routing entry point | `.local_manifest/AGENTS.md` | `.local_manifest/AGENTS.md` |

Only skills are auto-discovered through `.agents/`. Rules, personas, and other
documents are discovered through `AGENTS.md` and the routing files.

## Entry-point templates

Keep existing project mandates when applying these templates.

### Root `AGENTS.md` — solo

```markdown
# AGENTS.md

Entry point for all AI agents and contributors working in this repository.

The manifest lives in two tracked directories plus a discovery shim:

- `.team_manifest/` — decisions, rules, guides, personas, actions, and backlog.
- `.local_manifest/` — plans, findings, learning, scratch, references, skills,
  and its local `AGENTS.md`.
- `.agents/` — gitignored skill-discovery shim. Nothing else lives there.

Before acting, read
[`routing.rule.md`](.team_manifest/rules/routing.rule.md) and
[`.local_manifest/AGENTS.md`](.local_manifest/AGENTS.md), then follow their
routing. Read only what the current task needs.
```

### Root `AGENTS.md` — team

```markdown
# AGENTS.md

Entry point for all AI agents and contributors working in this repository.

The manifest has two trees plus a discovery shim:

- `.team_manifest/` — shared, tracked decisions, rules, guides, personas,
  actions, references, skills, and backlog.
- `.local_manifest/` — personal plans, findings, learning, scratch, references,
  skills, and its local `AGENTS.md`; linked from a private repository.
- `.agents/` — gitignored skill-discovery shim. Nothing else lives there.

Before acting, read
[`routing.rule.md`](.team_manifest/rules/routing.rule.md) and
[`.local_manifest/AGENTS.md`](.local_manifest/AGENTS.md), then follow their
routing. Paths under `.local_manifest/` are valid even when Git or search tools
skip the symlink. Read only what the current task needs.
```

### `.local_manifest/AGENTS.md` — solo

```markdown
# AGENTS.md

Read [`rules/routing.rule.md`](rules/routing.rule.md) in this directory to find
plans, findings, learning records, reference docs, and skills.
```

### `.local_manifest/AGENTS.md` — team

```markdown
# Local AGENTS.md

Read [`rules/routing.rule.md`](rules/routing.rule.md) in this tree to find
personal plans, findings, learning records, reference docs, and skills. Add
personal mandates and workflow here.
```

## Create the directories

Create the folders shown in the matching layout. For a team repo, first create
the local tree at `<LOCAL>`, then link it:

```powershell
New-Item -ItemType SymbolicLink -Path .\.local_manifest -Target '<LOCAL>'
```

On Windows, symbolic links require Developer Mode or an elevated shell.

## Create the discovery shim

Solo:

```powershell
New-Item -ItemType Directory -Force -Path .\.agents\skills
New-Item -ItemType SymbolicLink -Path .\.agents\skills\local -Target ..\..\.local_manifest\skills
```

```bash
mkdir -p .agents/skills
ln -s ../../.local_manifest/skills .agents/skills/local
```

Team:

```powershell
$local = '<LOCAL>'
New-Item -ItemType Directory -Force -Path .\.agents\skills
New-Item -ItemType SymbolicLink -Path .\.agents\skills\team -Target ..\..\.team_manifest\skills
New-Item -ItemType SymbolicLink -Path .\.agents\skills\local -Target "$local\skills"
```

```bash
mkdir -p .agents/skills
ln -s ../../.team_manifest/skills .agents/skills/team
ln -s <LOCAL>/skills .agents/skills/local
```

Point a team repo's local skill link directly at `<LOCAL>/skills`; do not chain
it through the `.local_manifest` symlink.

## Ignore rules

Merge the matching block into the target repo's `.gitignore`.

Solo:

```gitignore
# Agent manifest: discovery shim is recreated per machine
.agents/
.local_manifest/scratch/
```

Team:

```gitignore
# Agent manifest: local tree and discovery shim are per-person
.agents/
.local_manifest/
```

Never ignore `.team_manifest/`. In the private repository behind a team
manifest, ignore each project's scratch directory:

```gitignore
*/scratch/
```

If a team repo has a search-tool `.ignore` file, allow traversal of the
gitignored links:

```gitignore
!.local_manifest/
!.local_manifest/**
!.agents/
!.agents/**
```

## Verify

- `.local_manifest` is a real directory for solo and a resolving symlink for
  team.
- `.agents/skills/local` resolves; team also has a resolving
  `.agents/skills/team`.
- `.agents/` contains only skill links.
- Solo has no team `reference/` or `skills/` directories.
- Team has no duplicate skill folder names across the two trees.
- Ignore rules match the detected repo type.
