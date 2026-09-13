# Two-tree manifest layout (for migrate-manifest-layout)

The layout this skill migrates *to*. It is self-contained so the skill can run
before the template's own rules have been refreshed.

## Layout

`team` (shared tree is tracked; local tree is a gitignored symlink):

```text
<repo>/
├── AGENTS.md                 # tracked entry point (short)
├── .team_manifest/           # tracked
│   ├── backlog.plan.md       # parking lot for future tasks (not part of any SDD flow)
│   ├── todo.plan.md          # optional; scattered near-term pickups, not a backlog
│   ├── actions/
│   ├── adr/
│   ├── guides/
│   ├── personas/
│   ├── reference/            # mechanics everyone must know
│   ├── rules/
│   └── skills/               # skills everyone must have
├── .local_manifest/          # gitignored symlink to a private repo
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

`solo` (both trees tracked; `reference/` and `skills/` live only under
`.local_manifest/`; `.team_manifest/` exists so the folder names match a team
repo):

```text
<repo>/
├── AGENTS.md
├── .team_manifest/           # tracked
│   ├── backlog.plan.md
│   ├── todo.plan.md          # optional
│   ├── actions/
│   ├── adr/
│   ├── guides/
│   ├── personas/
│   └── rules/
├── .local_manifest/          # tracked, real directory
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

Only `skills/` is auto-discovered by Cursor, VS Code Copilot, and OpenCode from
`.agents/`; rules and personas are reached through `AGENTS.md` → routing.

### Repo types

| | `solo` | `team` |
|---|---|---|
| `.team_manifest/` | tracked | tracked |
| `.local_manifest/` | tracked, real directory | gitignored symlink into a private repo |
| `.agents/` shim | gitignored | gitignored |
| `scratch/` | gitignored in this repo | gitignored in the private repo |
| `reference/` and `skills/` | only under `.local_manifest/` | split across both trees |

## Folder ownership

| Legacy `.agents/<folder>` | New home | How to map |
|---|---|---|
| `adr/` | `.team_manifest/adr/` | fixed |
| `actions/` | `.team_manifest/actions/` | fixed |
| `guides/` | `.team_manifest/guides/` | fixed |
| `personas/` | `.team_manifest/personas/` | fixed |
| `rules/manifest-structure.rule.md`, `rules/terms.rule.md` | `.team_manifest/rules/` | fixed |
| `rules/routing.rule.md` | routing file in each tree | by referencing file's tree |
| `plans/backlog.plan.md` | `.team_manifest/backlog.plan.md` | fixed |
| `plans/` (everything else) | `.local_manifest/plans/` | fixed |
| `findings/`, `learning/`, `scratch/` | `.local_manifest/<folder>/` | fixed |
| `reference/<file>` | `solo`: always `.local_manifest/reference/`. `team`: either tree | `solo` by rule; `team` lookup by filename |
| `skills/<name>/` | `solo`: always `.local_manifest/skills/`. `team`: either tree | `solo` by rule; `team` lookup by folder name |

### Alias table (stale → fresh)

Convert these leftover strings wherever they appear outside `plans/archive/`:

| Stale | Fresh |
|---|---|
| `.agents/reference/` or `.agents/references/` | `.team_manifest/reference/` or `.local_manifest/reference/` by the ownership row above |
| `references/` (folder name) | `reference/` |
| `.agents/teaching/`, `.agents/learnings/`, `.agents/learning/` | `.local_manifest/learning/` |
| `teaching/`, `learnings/` | `learning/` |
| `.agents/plans/backlog.plan.md` | `.team_manifest/backlog.plan.md` |

Typical split on `team` only (the user decides; this is only the expected
default):

- Team skills: `apply-manifest-template`, `sync-manifest-template`,
  `migrate-manifest-layout`, `create-github-repo`, repo-specific runbooks.
- Local skills: `grill-to-master`, `grill-to-spec`, `spec-to-plan`,
  `plan-to-criteria`, `implement-plan`, `archive-plan`, `wrap-up-plan`,
  `debug-agent`, `review-changes`.
- Local reference: `planning-flow.ref.md`.

On `solo`, skip that split: every skill and every reference doc goes under
`.local_manifest/`.

Retired and deleted, not migrated: all `operation-*` skills, rules, ADRs, and
reference docs, plus their routing rows.

## Manual pre-migration work

Folders, moves, symlinks, and the verification checklist the user completes
before invoking this skill live in [`user-setup.md`](user-setup.md), split by
repo type. Hand that file to the user if the moves are not done yet.

## `.gitignore` blocks

`solo` (`.local_manifest/` stays tracked):

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

## `.ignore` blocks

`team` only, so search tools can see the gitignored local tree. Merge if the
target already has a `.ignore` (or equivalent):

```gitignore
!.local_manifest/
!.local_manifest/**
!.agents/
!.agents/**
```

`solo` does not need this: `.local_manifest/` is tracked.

## File templates

Fill `<...>` placeholders; carry over the target's real text where noted.
Pick the **`solo` or `team`** template. Do not use the team wording on a solo
target.

### Root `AGENTS.md` — `team`

```markdown
# AGENTS.md

Entry point for all AI agents and contributors working in this repository
(GitHub Copilot, Cursor, OpenCode, and future tools).

The manifest has two trees plus a discovery shim:

- `.team_manifest/` — shared and tracked: decisions (`adr/`), rules, guides,
  personas, actions, team reference docs, team skills, and the shared
  `backlog.plan.md`.
- `.local_manifest/` — personal: plans, findings, learning, scratch, personal
  reference docs and skills, and a personal `AGENTS.md`. Gitignored; each
  person links their own private copy here. Paths under `.local_manifest/` are
  in the workspace and valid; do not report those files as missing because
  git, glob, or grep skip the symlink.
- `.agents/` — gitignored shim holding only `skills/team` and `skills/local`
  symlinks so tools auto-discover skills. Nothing else lives there.

**Before acting, read
[`.team_manifest/rules/routing.rule.md`](.team_manifest/rules/routing.rule.md).**
Also read
[`.local_manifest/AGENTS.md`](.local_manifest/AGENTS.md) and follow its
routing. Read only what the current task needs; do not bulk-read either tree.

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

If the target already names a first-read file other than team routing (for
example `.team_manifest/rules/global.rule.md`), keep that chain and still
add the unconditional read of `.local_manifest/AGENTS.md`. If
`todo.plan.md` exists at the team root, mention it next to the backlog as
scattered near-term pickups, not a backlog.

### Root `AGENTS.md` — `solo`

Do not mention shared vs personal ownership. Do not say "if local is present".
Both directories are tracked.

```markdown
# AGENTS.md

Entry point for all AI agents and contributors working in this repository
(GitHub Copilot, Cursor, OpenCode, and future tools).

The manifest lives in two directories plus a discovery shim. Both directories
are tracked.

- `.team_manifest/` — decisions (`adr/`), rules, guides, personas, actions,
  and `backlog.plan.md`.
- `.local_manifest/` — plans, findings, learning, scratch, reference docs,
  skills, and `AGENTS.md`.
- `.agents/` — gitignored shim holding a `skills/local` symlink so tools
  auto-discover skills. Nothing else lives there.

**Before acting, read
[`.team_manifest/rules/routing.rule.md`](.team_manifest/rules/routing.rule.md)
and
[`.local_manifest/AGENTS.md`](.local_manifest/AGENTS.md)
and follow their routing.** Read only what the current task needs; do not
bulk-read either directory.

## Project mandates

<carry over the target's existing mandates verbatim>

## Generic rules

- **Read the decisions first.** `.team_manifest/adr/` holds the durable laws
  of this codebase and overrides generic conventions.
- **Keep docs in sync.** If your change makes a reference or guide wrong, fix
  it in the same change. See
  [`.team_manifest/rules/manifest-structure.rule.md`](.team_manifest/rules/manifest-structure.rule.md).
- **Check the backlog before proposing work.** Future tasks live in
  [`.team_manifest/backlog.plan.md`](.team_manifest/backlog.plan.md).
```

Keep an existing first-read file if the target already names one. Mention
`todo.plan.md` only when that file exists.

### `.local_manifest/AGENTS.md` — `team` (create only if missing)

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

### `.local_manifest/AGENTS.md` — `solo` (create only if missing)

No "personal" / "not shared" wording.

```markdown
# AGENTS.md

Read [`rules/routing.rule.md`](rules/routing.rule.md) in this directory to find
plans, findings, learning records, reference docs, and skills.

## Workflow

- <e.g. spec-driven development: grill-to-spec → spec-to-plan →
  plan-to-criteria → implement-plan → wrap-up-plan; all artifacts under
  `plans/` in this directory>
```

### `.team_manifest/rules/routing.rule.md` — sections to keep

Keep from the old routing file, with paths fixed. Split row by row; do not
replace the file with a blank template. Extra sections stay.

On `team`, keep `Task → Rules`, `Task → ADR`, `Task → Reference` (team docs
only), `Task → Skill` (team skills only), `Task → Action`, `Specialized
agents`. Add:

```markdown
## Task → Backlog

- Record or pick up a shared future task → [`../backlog.plan.md`](../backlog.plan.md).
  This is a parking lot, not part of any planning flow; personal plans live in
  `.local_manifest/plans/`.
```

If `todo.plan.md` exists at the team root, add a row: scattered near-term
pickups, not a backlog.

Replace the old context-discipline paragraph's `AGENTS.md` link with
`../../AGENTS.md`, and note that the other routing file lives in
`.local_manifest/rules/routing.rule.md`.

On `solo`, use the same split, but headings and intro must not say "team" vs
"personal". Name the directory (`.team_manifest/`, `.local_manifest/`) when
you need to say where a file lives. All `Task → Reference` and `Task → Skill`
rows go to the local routing file. The backlog row may say plans live in
`.local_manifest/plans/` (a path, not an ownership claim).

### `.local_manifest/rules/routing.rule.md` — sections to hold

`Task → Skill`, `Task → Reference`, `Task → Plan`, `Task → Learning`,
`Task → Findings`, and the planning "Important" notes. All paths relative to
`.local_manifest/rules/`. Cross-tree links (for example to
`manifest-structure.rule.md`) use
`../../.team_manifest/rules/manifest-structure.rule.md`.

On `team`, the skill and reference sections are the local (personal) ones.
On `solo`, they are the only skill and reference sections.

### Layout section for `manifest-structure.rule.md` — `team`

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

### Layout section for `manifest-structure.rule.md` — `solo`

Insert after "Manifest Scope". Do not contrast shared vs personal.

```markdown
## Layout: two directories and a shim

The manifest is the union of `.team_manifest/` and `.local_manifest/`. Both
are tracked. `.team_manifest/` holds `actions/`, `adr/`, `guides/`,
`personas/`, `rules/`, and `backlog.plan.md`. `.local_manifest/` holds
`plans/`, `findings/`, `learning/`, `scratch/`, `reference/`, `skills/`,
`AGENTS.md`, and `rules/routing.rule.md`. `.agents/` is a gitignored
discovery shim that holds a `skills/local` symlink.

`reference/` and `skills/` live only under `.local_manifest/`.
```

### Terms to add to `terms.rule.md`

`team`:

- **manifest** — the union of the team manifest and the local manifest.
- **team manifest** — `.team_manifest/`, tracked and shared.
- **local manifest** — `.local_manifest/`, personal; gitignored in team repos.
- **discovery shim** — the gitignored `.agents/` directory holding only skill
  symlinks.

`solo` (do not add the team-versus-local ownership terms):

- **manifest** — the files under `.team_manifest/` and `.local_manifest/`
  together.
- **discovery shim** — the gitignored `.agents/` directory holding skill
  symlinks.

## Relative-link rewrite rules

Compute every link from the file's new location *as seen from the repo root*.
Never write the private repo's physical path.

| From | To | `solo` | `team` |
|---|---|---|---|
| `.local_manifest/skills/<s>/SKILL.md` | file in `.team_manifest/` | `../../../.team_manifest/...` | same |
| `.local_manifest/skills/<s>/SKILL.md` | local reference | `../../reference/<r>.ref.md` | same |
| `.team_manifest/skills/<s>/SKILL.md` or `adr/` or `rules/` | file in `.local_manifest/` that exists | `../../../.local_manifest/...` (or `../../.local_manifest/...` from `adr/` / `rules/`) | same (assume the local tree is present) |
| `.team_manifest/...` | local file that may be missing | (does not apply; everything is tracked) | code-span filename plus "if available", e.g. refer to `products.ref.md` if available |
| `.team_manifest/rules/*.rule.md` | root `AGENTS.md` | `../../AGENTS.md` | same |
| `.local_manifest/rules/routing.rule.md` | file in `.team_manifest/rules/` | `../../.team_manifest/rules/<x>.rule.md` | same |
| root `AGENTS.md` / `README.md` | anything | root-relative, e.g. `.team_manifest/adr/` | same |

Skills that write files name the tree explicitly: planning skills write to
`.local_manifest/plans/`; `wrap-up-plan` writes to `.local_manifest/reference/`.
