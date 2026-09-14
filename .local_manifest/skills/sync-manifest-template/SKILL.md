---
name: sync-manifest-template
description: >-
  Brings recent updates from this manifest-template into a *target* repo's
  two-directory manifest without overwriting its local content.
  Compares this template (source of structure) against the target repo, finds
  logical manifest-creation progress (new folder types, naming rules,
  routing/structure conventions), and applies only those — skipping template
  example content and edits that are specific to the target repo.
  Use when the user opens their own repo alongside this template and asks to
  "sync the manifest template", "bring in recent manifest updates", "update my
  manifest from the template", or "pull manifest-template changes". Requires
  both this template and the target repo open in one workspace.
---

# Sync Manifest Template

Pull **structural** updates from this `manifest-template` into a target repo's
`.team_manifest/` and `.local_manifest/` trees, while keeping the target's own
real content intact. This template is the source of truth for manifest
*structure and conventions* — not for the target's actual decisions, references,
skills, or learning content.

This is the counterpart to [`apply-manifest-template`](../apply-manifest-template/SKILL.md):
that skill bootstraps a manifest from scratch; this one upgrades an existing one.

## When to Use

- The user wants the latest manifest conventions from this template.
- Both this template and the target repo are open in the same workspace.
- The template has had recent commits and the target's manifest trees lag behind.

Do **not** use this to scaffold a manifest from scratch — use
`apply-manifest-template` instead.

## Hard Rules

1. **Never edit this `manifest-template` repo.** It is the read-only source.
2. Make the smallest possible surgical edit that brings the structural or behavioral change across. You may create a whole new folder/file in the target if the template added a new folder/file, but do not copy example files from the template into the target.
3. **Preserve the target's wording, links, and real content.** Adapt the
   template change to fit existing local phrasing instead of replacing it.
4. **When unsure whether a diff is structure or local content, list it for the
   user instead of guessing.**
5. **Write into the target's two-directory layout.** Never recreate a single
   content tree under `.agents/`. `.agents/` on the target is only the
   discovery shim.
6. **Place each incoming file by the target's repo type**, not by where it
   happens to live in this template. This template is a solo repo: every skill
   and every `*.ref.md` lives under `.local_manifest/`. A team target still
   splits `skills/` and `reference/` across both trees.

## Repo type and placement

Read `.local_manifest`'s `LinkType`: real directory = `solo`; symbolic link =
`team`. Do not ask for a repo type unless the filesystem state is invalid or
contradictory; sync assumes `apply-manifest-template` or
`migrate-manifest-layout` already established the layout.

Use the ownership table and entry-point templates in
[`manifest-layout.md`](../../../.team_manifest/guides/manifest-layout.md).
Update an existing skill or reference in its current valid tree. If a new item
could be team-wide or personal, ask rather than guessing. Skill folder names
must remain unique across both trees.

## Procedure

### 1. Identify the two repos
- Confirm both folders are open. The **source** is this `manifest-template` repo
  (has example ADRs, `apply-manifest-template`, a template `README.md`).
- The **target** is the user's repo with `.team_manifest/` and
  `.local_manifest/`.

### 2. Scope "recent updates" from template git history
Read this template's history to bound what changed (do not diff the whole tree blind):
```
git -C <template> log --oneline -30
git -C <template> show <commit> --name-status
git -C <template> show <commit> -- <path>   # inspect the actual diff
```
If the target repo has already applied some of those changes, skip them. Only bring across changes that are new to the target.

Important: if the user asks for a deeper sync, then checking the git history is not enough and you need to compare the two manifest trees directly
(`.team_manifest/` and `.local_manifest/` on each side). Use a diff tool to
find structural changes in the template that are not yet in the target. Still,
use common sense to skip template example content and edits that are specific
to the target repo. Compare by *role* (routing, structure rule, planning
skill), not by assuming the same relative path — this template keeps all
skills under `.local_manifest/skills/`.

### 3. Map common structural files
List both trees on each side and map structural files by role. A target may be
missing a newly introduced structural file:
- `.team_manifest/rules/manifest-structure.rule.md`
- `.team_manifest/guides/manifest-layout.md`
- `.team_manifest/rules/routing.rule.md`
- `.local_manifest/rules/routing.rule.md`
- `.team_manifest/rules/terms.rule.md`
- `.team_manifest/personas/manifester.agent.md` (and other shared personas)
- root `AGENTS.md`
- `.local_manifest/AGENTS.md` (do not overwrite an existing one; only fix a
  wrong routing link)
- shared `actions/` and `guides/` conventions
Compare and consider skills, as they may be needed in the target repo. Skip
Lessons examples and other examples entirely, as they are not part of the
target repo's real content.

### 4. Classify each template change — bring it or skip it
Use this table:

| Bring across (logical manifest progress) | Skip (not for the target) |
|---|---|
| New folder type documented (e.g. adding `learning/`) | Template example files: `*example*` ADRs, refs, skills, `example/` dirs |
| New naming-suffix / placement / cross-link rules | The apply/sync/migrate/create-GitHub-repo meta-skills (template-only) |
| Two-directory layout wording, split routing, shim `.gitignore` | Recreating a single content tree under `.agents/` |
| Simple-plan vs. epic-directory conventions | `plans/example-epic/` and all files inside it |
| Generic planning, debugging, and review workflow skills, including `debug-agent` and `review-changes` | Target-specific plans, specs, tests, and implementation content |
| Required third-party attribution for copied adapted skills | Unrelated template notices or licenses |
| Routing discipline and discovery-flow wording | This template's `README.md` describing the template itself |
| Persona convention updates (plain-English rules, folder lists) | Edits the target already has, or is ahead on |
| Frontmatter / structure conventions | Anything that names the template's example domain |
| Layout terms (`manifest`, `discovery shim`; team terms only on team targets) | Solo-versus-team ownership language on a solo target |

If the target already has the change (or a more advanced local version), skip it.

### 5. Apply surgically
- Edit only the shared structural files in the **target**, matching the target's
  existing tone and link style (relative links, local terminology).
- When syncing the plan-naming convention, rename legacy master plans
  (including former `*.master.plan` files) to `*.master.md` and legacy
  detailed plans to `*.planning.md`, then repair all affected links.
  Keep `backlog.plan.md` unchanged because it is neither type. If it still
  lives under `plans/`, ask the user to move it to
  `.team_manifest/backlog.plan.md`.
- If a template change references scaffolding the target doesn't have (e.g.
  `learning/README.md`), point at the target's real path instead, or omit the
  dead link.
- Do not copy template placeholder/example files into the target.
- Skills that write files must keep naming `.local_manifest/plans/` and
  `.local_manifest/reference/` (and `.local_manifest/scratch/`).
- Merge the repo-type ignore blocks from `manifest-layout.md` if they are
  missing.

### 6. Validate and finish
- Check the edited target files for broken links and markdown errors.
- If the target has an `actions/verify-docs-in-sync.md` action, run it (or remind
  the user to) so the synced changes are checked for consistency.
- If the target builds a generated index (e.g. a `knowledge-base.md` produced by
  a script), remind the user to regenerate it after manifest changes.
- Confirm you did not write content into `.agents/` and did not add
  `.team_manifest/skills/` or `.team_manifest/reference/` on a solo target.
- Summarize what was brought across and what was deliberately skipped and why.

## Decision Heuristic

Ask of every template diff: *"Is this a better way to organize ANY manifest, or
is it content about this template's own example project / about the target repo
specifically?"* Only the first kind crosses over. Then ask: *"Which tree does
this file belong in on *this* target?"* Place it there.
