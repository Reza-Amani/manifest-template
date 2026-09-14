# Migration mapping reference

This reference contains only the legacy-to-current path mapping and link
rewrite rules used during migration. The canonical target layouts, repo-type
definitions, entry-point templates, shim commands, and ignore blocks live in
[`manifest-layout.md`](../../../.team_manifest/guides/manifest-layout.md).

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

## Manual pre-migration work

Folders, moves, symlinks, and the verification checklist the user completes
before invoking this skill live in [`user-setup.md`](user-setup.md), split by
repo type. Hand that file to the user if the moves are not done yet.

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
