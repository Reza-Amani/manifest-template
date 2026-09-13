# Two-tree manifest layout (for migrate-manifest-layout)

The layout this skill migrates *to*. It is self-contained so the skill can run
before the template's own rules have been refreshed.

## Layout

```text
<repo>/
├── AGENTS.md                 # tracked, team-owned entry point (short)
├── .team_manifest/           # tracked: shared by everyone on the repo
│   ├── backlog.plan.md       # shared parking lot for future tasks (not part of any SDD flow)
│   ├── actions/              # shared one-step procedures
│   ├── adr/                  # decisions
│   ├── guides/               # setup, commands, how-tos
│   ├── personas/             # role definitions, read via routing
│   ├── reference/            # mechanics everyone must know
│   ├── rules/                # manifest-structure, terms, TEAM routing
│   └── skills/               # skills everyone must have (repo runbooks, apply/sync/migrate)
├── .local_manifest/          # personal; symlink to a private repo in team repos
│   ├── AGENTS.md             # personal mandates and workflow
│   ├── rules/routing.rule.md # LOCAL routing
│   ├── plans/                # specs, plans, archive
│   ├── findings/
│   ├── learning/
│   ├── reference/            # personal mechanics notes
│   ├── scratch/              # gitignored everywhere
│   └── skills/               # personal skills, incl. the SDD flow skills
└── .agents/                  # gitignored discovery shim; nothing else lives here
    └── skills/
        ├── team  -> ../../.team_manifest/skills
        └── local -> <.local_manifest>/skills
```

Only `skills/` is auto-discovered by Cursor, VS Code Copilot, and OpenCode from
`.agents/`; rules and personas are reached through `AGENTS.md` → routing.

### Repo types

| | `solo` | `team` |
|---|---|---|
| `.team_manifest/` | tracked | tracked |
| `.local_manifest/` | tracked, real directory | gitignored symlink into a private repo |
| `.agents/` shim | gitignored | gitignored |
| `scratch/` | gitignored in this repo | gitignored in the private repo |

## Folder ownership

| Legacy `.agents/<folder>` | New home | How to map |
|---|---|---|
| `adr/` | `.team_manifest/adr/` | fixed |
| `actions/` | `.team_manifest/actions/` | fixed |
| `guides/` | `.team_manifest/guides/` | fixed |
| `personas/` | `.team_manifest/personas/` | fixed |
| `rules/manifest-structure.rule.md`, `rules/terms.rule.md` | `.team_manifest/rules/` | fixed |
| `rules/routing.rule.md` | team **and** local routing | by referencing file's tree |
| `plans/backlog.plan.md` | `.team_manifest/backlog.plan.md` | fixed |
| `plans/` (everything else) | `.local_manifest/plans/` | fixed |
| `findings/`, `learning/`, `scratch/` | `.local_manifest/<folder>/` | fixed |
| `reference/<file>` | either tree | lookup by filename |
| `skills/<name>/` | either tree | lookup by folder name |

Typical split (the user decides; this is only the expected default):

- Team skills: `apply-manifest-template`, `sync-manifest-template`,
  `migrate-manifest-layout`, `create-github-repo`, repo-specific runbooks.
- Local skills: `grill-to-master`, `grill-to-spec`, `spec-to-plan`,
  `plan-to-criteria`, `implement-plan`, `archive-plan`, `wrap-up-plan`,
  `debug-agent`, `review-changes`.
- Local reference: `planning-flow.ref.md`.

Retired and deleted, not migrated: all `operation-*` skills, rules, ADRs, and
reference docs, plus their routing rows.

## Manual pre-migration work

Folders, moves, symlinks, and the verification checklist the user completes
before invoking this skill live in [`user-setup.md`](user-setup.md), split by
repo type. Hand that file to the user if the moves are not done yet.

## `.gitignore` blocks

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

Private repo (team repos), at its root:

```gitignore
*/scratch/
```

## File templates

Fill `<...>` placeholders; carry over the target's real text where noted.

### Root `AGENTS.md` (tracked, team-owned)

```markdown
# AGENTS.md

Entry point for all AI agents and contributors working in this repository
(GitHub Copilot, Cursor, OpenCode, and future tools).

The manifest has two trees plus a discovery shim:

- `.team_manifest/` — shared and tracked: decisions (`adr/`), rules, guides,
  personas, actions, team reference docs, team skills, and the shared
  `backlog.plan.md`.
- `.local_manifest/` — personal: plans, findings, learning, scratch, personal
  reference docs and skills, and a personal `AGENTS.md`. <team: gitignored;
  each person links their own private copy here.>
- `.agents/` — gitignored shim holding only `skills/team` and `skills/local`
  symlinks so tools auto-discover skills. Nothing else lives there.

**Before acting, read
[`.team_manifest/rules/routing.rule.md`](.team_manifest/rules/routing.rule.md).**
Then, if `.local_manifest/AGENTS.md` exists, read it and follow its routing
too. Read only what the current task needs; do not bulk-read either tree.

## Project mandates

<carry over the target's existing mandates verbatim>

## Generic rules

- **Read the decisions first.** `.team_manifest/adr/` holds the durable laws
  of this codebase and overrides generic conventions.
- **Keep docs in sync.** If your change makes a reference or guide wrong, fix
  it in the same change. See
  [`.team_manifest/rules/manifest-structure.rule.md`](.team_manifest/rules/manifest-structure.rule.md).
- **Check the backlog before proposing work.** Shared future tasks live in
  [`.team_manifest/backlog.plan.md`](.team_manifest/backlog.plan.md).
```

### `.local_manifest/AGENTS.md` (personal; create only if missing)

```markdown
# Local AGENTS.md

Personal mandates and workflow for this repository. Not shared with the team;
the shared entry point is the root `AGENTS.md`.

Read [`rules/routing.rule.md`](rules/routing.rule.md) in this tree to find
plans, findings, learning records, personal reference docs, and personal skills.

## Personal workflow

- <e.g. spec-driven development: grill-to-spec → spec-to-plan →
  plan-to-criteria → implement-plan → wrap-up-plan; all artifacts under
  `plans/` in this tree>

## Personal mandates

- <anything the team AGENTS.md does not say but you want every agent to follow
  when working for you>
```

### `.team_manifest/rules/routing.rule.md` — sections to keep

Keep from the old routing file, with paths fixed: `Task → Rules`,
`Task → ADR`, `Task → Reference` (team docs only), `Task → Skill` (team skills
only), `Task → Action`, `Specialized agents`. Add:

```markdown
## Task → Backlog

- Record or pick up a shared future task → [`../backlog.plan.md`](../backlog.plan.md).
  This is a parking lot, not part of any planning flow; personal plans live in
  `.local_manifest/plans/`.
```

Replace the old context-discipline paragraph's `AGENTS.md` link with
`../../AGENTS.md`, and note that personal routing lives in
`.local_manifest/rules/routing.rule.md`.

### `.local_manifest/rules/routing.rule.md` — sections to hold

`Task → Skill` (personal skills, including the SDD flow), `Task → Reference`
(personal reference, e.g. `planning-flow.ref.md`), `Task → Plan`,
`Task → Learning`, `Task → Findings`, and the planning "Important" notes. All
paths relative to `.local_manifest/rules/`. Cross-tree links (for example to
the team `manifest-structure.rule.md`) use
`../../.team_manifest/rules/manifest-structure.rule.md`.

### Layout section for `manifest-structure.rule.md`

Insert after "Manifest Scope":

```markdown
## Layout: two trees and a shim

The manifest is the union of two trees. `.team_manifest/` is tracked and
shared: `actions/`, `adr/`, `guides/`, `personas/`, `rules/`, team
`reference/`, team `skills/`, and `backlog.plan.md`. `.local_manifest/` is
personal: `plans/`, `findings/`, `learning/`, `scratch/`, personal
`reference/`, personal `skills/`, a personal `AGENTS.md`, and a personal
`rules/routing.rule.md`. In team repos `.local_manifest/` is gitignored and
symlinked to a private repo. `.agents/` is a gitignored discovery shim that
holds only `skills/team` and `skills/local` symlinks.

`reference/` and `skills/` exist in both trees: the team copy holds what
everyone must have; the local copy holds personal material. Promotion from
local to team is a manual move. Skill folder names must be unique across both
trees.
```

### Terms to add to `terms.rule.md`

- **manifest** — the union of the team manifest and the local manifest.
- **team manifest** — `.team_manifest/`, tracked and shared.
- **local manifest** — `.local_manifest/`, personal; gitignored in team repos.
- **discovery shim** — the gitignored `.agents/` directory holding only skill
  symlinks.

## Relative-link rewrite rules

Compute every link from the file's new location *as seen from the repo root*.

| From | To | Link |
|---|---|---|
| `.local_manifest/skills/<s>/SKILL.md` | team persona | `../../../.team_manifest/personas/<p>.agent.md` |
| `.local_manifest/skills/<s>/SKILL.md` | local reference | `../../reference/<r>.ref.md` |
| `.team_manifest/skills/<s>/SKILL.md` | local reference | `../../../.local_manifest/reference/<r>.ref.md` |
| `.team_manifest/rules/*.rule.md` | root `AGENTS.md` | `../../AGENTS.md` |
| `.local_manifest/rules/routing.rule.md` | team rule | `../../.team_manifest/rules/<x>.rule.md` |
| root `AGENTS.md` / `README.md` | anything | root-relative, e.g. `.team_manifest/adr/` |

Skills that write files name the tree explicitly: planning skills write to
`.local_manifest/plans/`; `wrap-up-plan` writes to `.local_manifest/reference/`.
