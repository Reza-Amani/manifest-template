---
name: sync-manifest-template
description: >-
  Brings recent updates from this manifest-template into a *target* repo's own `.agents/` manifest without overwriting its local content.
  Compares this template (source of structure) against the target repo, finds logical manifest-creation progress (new folder types, naming rules, routing/structure conventions), and applies only those — skipping template example content and edits that are specific to the target repo.
  Use when the user opens their own repo alongside this template and asks to "sync the manifest template", "bring in recent manifest updates", "update my manifest from the template", or "pull manifest-template changes". Requires both this template and the target repo open in one workspace.
---

# Sync Manifest Template

Pull **structural** updates from this `manifest-template` into a target repo's
`.agents/` manifest, while keeping the target's own real content intact. This
template is the source of truth for manifest *structure and conventions* — not
for the target's actual decisions, references, skills, or learning content.

This is the counterpart to [`apply-manifest-template`](../apply-manifest-template/SKILL.md):
that skill bootstraps a manifest from scratch; this one upgrades an existing one.

## When to Use

- The user wants the latest manifest conventions from this template.
- Both this template and the target repo are open in the same workspace.
- The template has had recent commits and the target's `.agents/` lags behind.

Do **not** use this to scaffold a manifest from scratch — use
`apply-manifest-template` instead.

## Hard Rules

1. **Never edit this `manifest-template` repo.** It is the read-only source.
2. Make the smallest possible surgical edit that brings the structural or behavioral change across. You may create a whole new folder/file in the target if the template added a new folder/file, but do not copy example files from the template into the target.
3. **Preserve the target's wording, links, and real content.** Adapt the
   template change to fit existing local phrasing instead of replacing it.
4. **When unsure whether a diff is structure or local content, list it for the
   user instead of guessing.**

## Procedure

### 1. Identify the two repos
- Confirm both folders are open. The **source** is this `manifest-template` repo
  (has example ADRs, `apply-manifest-template`, a template `README.md`).
- The **target** is the user's repo with its own `.agents/` tree.

### 2. Scope "recent updates" from template git history
Read this template's history to bound what changed (do not diff the whole tree blind):
```
git -C <template> log --oneline -30
git -C <template> show <commit> --name-status
git -C <template> show <commit> -- <path>   # inspect the actual diff
```
If the target repo has already applied some of those changes, skip them. Only bring across changes that are new to the target.

Important: if the user asks for a deeper sync, then checking the git history is not enough and you need to compare the two `.agents/` trees directly. Use a diff tool to find structural changes in the template that are not yet in the target. Still, use common sense to skip template example content and edits that are specific to the target repo.

### 3. Map common structural files
List both `.agents/` trees and find the files that exist in **both** and define
structure (not example content):
- `rules/manifest-structure.rule.md`
- `rules/routing.rule.md`
- `rules/terms.rule.md`
- `personas/manifester.agent.md` (and other shared personas)
- root `AGENTS.md`
- shared `actions/` and `guides/` conventions
Compare and consider skills, as they may be needed in the target repo. Skip Lessons examples and other examples entirely, as they are not part of the target repo's real content. 

### 4. Classify each template change — bring it or skip it
Use this table:

| Bring across (logical manifest progress) | Skip (not for the target) |
|---|---|
| New folder type documented (e.g. adding `learning/`) | Template example files: `*example*` ADRs, refs, skills, `example/` dirs |
| New naming-suffix / placement / cross-link rules | The `apply-manifest-template` meta-skill (template-only) |
| Routing discipline and discovery-flow wording | This template's `README.md` describing the template itself |
| Persona convention updates (plain-English rules, folder lists) | Edits the target already has, or is ahead on |
| Frontmatter / structure conventions | Anything that names the template's example domain |

If the target already has the change (or a more advanced local version), skip it.

### 5. Apply surgically
- Edit only the shared structural files in the **target**, matching the target's
  existing tone and link style (relative links, local terminology).
- If a template change references scaffolding the target doesn't have (e.g.
  `learning/README.md`), point at the target's real path instead, or omit the
  dead link.
- Do not copy template placeholder/example files into the target.

### 6. Validate and finish
- Check the edited target files for broken links and markdown errors.
- If the target builds a generated index (e.g. a `knowledge-base.md` produced by
  a script), remind the user to regenerate it after `.agents/` changes.
- Summarize what was brought across and what was deliberately skipped and why.

## Decision Heuristic

Ask of every template diff: *"Is this a better way to organize ANY manifest, or
is it content about this template's own example project / about the target repo
specifically?"* Only the first kind crosses over.
