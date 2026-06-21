---
name: apply-manifest-template
description: >-
  Bootstraps or upgrades an agent manifest in a *target* repository using this
  template as the source of truth. Reads the template structure and conventions,
  explores the target repo's real business and tech stack, then creates a
  tailored `.agents/` manifest (or fixes an existing one) with real, repo-specific
  content instead of the template's example files.
  Use when the user opens their own repo alongside this template in one workspace
  and asks to "apply the manifest template", "set up the manifest in my repo",
  "scaffold .agents for this project", or "bootstrap an agent manifest".
---

# Apply Manifest Template

This skill installs a working agent manifest into **another repository** in the
same workspace, using this template repo as the pattern. It does **not** copy the
example files verbatim — it produces real documents that match the target repo's
actual business, architecture, and commands.

**Persona:** Run this skill as the Manifester
([`../../personas/manifester.agent.md`](../../personas/manifester.agent.md)) —
plain English, one fact in one place, correct placement and links.

## The scenario

1. The user has their own repository (target repo) open in a VS Code workspace.
2. They add **this template repo** as a second folder in the same workspace.
3. They invoke this skill from the template repo.
4. The agent reads the template, studies the target repo, and writes a tailored
   `.agents/` manifest into the **target** repo — creating it if absent, or
   upgrading it if one already exists.

## Inputs you must resolve first

- **Template repo (source):** the folder that contains this skill. This is the *pattern*,  never the edit target.
- **Target repo (destination):** the other workspace folder. This is where the
  manifest is written.

If the workspace has exactly two folders, the one that is **not** this template
is the target. If there are more than two folders, or it is ambiguous, **ask the
user** which folder is the target before writing anything. If only this template
folder is open, stop and tell the user to add their repo to the workspace.

> **Safety:** Never write manifest files into the template repo itself. All
> creates/edits in this skill target the destination repo.

## Procedure

Copy this checklist into your working notes and track progress:

```
Task progress:
- [ ] 1. Identify source (this template) and target repo
- [ ] 2. Learn the template structure and conventions and agent rules/instructions 
- [ ] 3. Detect whether the target already has a .agents/ manifest
- [ ] 4. Study the target repo's business, architecture, stack, and commands
- [ ] 5. Interview the user for what code cannot reveal (mandates, decisions). Proactively, ask concise questions that cannot be answered by reading the repo.
- [ ] 6. Create or upgrade the target manifest with REAL, tailored content
- [ ] 7. Replace every example with real content; keep one leftover example in each manifest directory, if no file exists there, but mark it clearly as an example for future reference.
- [ ] 8. Verify links, naming, and placement; report a summary
- [ ] 9. Do NOT remove the existing ADRs, instructions, skills, etc. in the target repo; only edit them if required, move them if required, or add new ones. If you find something that seems wrong in an existing manifest, list it for the user instead of guessing. At the end, report any major content change in the existing manifest and report any items that need human review instead of silently guessing or leaving them broken.
```

### 1. Identify the repos

Determine the source and target folders per **Inputs** above. Confirm the target
with the user if there is any ambiguity.

### 2. Learn the template structure

Read these template files so your output follows the conventions exactly:

- [`../../rules/manifest-structure.rule.md`](../../rules/manifest-structure.rule.md)
  — folder purpose, naming suffixes, placement rules. **This file is required in
  the target.**
- [`../../rules/routing.rule.md`](../../rules/routing.rule.md) — how the routing
  map is laid out.
- [`../../rules/terms.rule.md`](../../rules/terms.rule.md) — the terms format.
- [`../../../AGENTS.md`](../../../AGENTS.md) — the root entry-point shape.
- The example docs in each folder (`adr/`, `reference/`, `guides/`, `skills/`,
  `actions/`, `personas/`, `plans/`) — use these for **format only**, not content.

### 3. Detect an existing manifest in the target

Check the target repo for `AGENTS.md` and a `.agents/` directory.

- **No manifest:** you will create the full structure (step 6, "Create" path).
- **Partial or full manifest exists:** do **not** overwrite blindly. Audit it
  against the template structure, keep good content, and fill gaps (step 6,
  "Upgrade" path). Treat existing ADRs as authoritative — never rewrite a
  decision; only add or flag.

### 4. Study the target repo

Build an accurate picture of the target before writing. Gather:

- **Purpose & domain:** READMEs, docs, package metadata, top-level comments.
- **Architecture & layering:** directory structure, module boundaries,
  entry points, key abstractions.
- **Tech stack:** language(s), framework(s), build system, package manager.
- **Real commands:** build, test, run, lint, format, migrate (from `Makefile`,
  `package.json` scripts, `*.toml`, CI config, etc.).
- **The code's CLI commands, if any** — these are not the same as the build/test/run commands; they are the commands provided by the codebase for users to interact with the system. Like commands created by Cobra for Go code bases. List them and their purpose in `guides/commands.md` so agents can find and use them without guessing.
- **Conventions & vocabulary:** recurring domain nouns/verbs that belong in
  `terms.rule.md`.
- **Existing decisions & constraints:** anything already written down that should
  become an ADR or a mandate.
- **Open work:** `TODO`/`FIXME` markers, issue trackers, or a backlog to seed
  `plans/backlog.plan.md`.

Prefer a read-only exploration pass (search + read) over guessing. Use the
`Explore` subagent if available for a fast survey.

### 5. Interview the user for what code cannot reveal

Some manifest content is human knowledge, not in the code. Ask the user concise
questions (only those you cannot answer from the repo) such as:

- What are the project's **non-negotiable mandates** (security boundaries,
  forbidden patterns, performance rules)?
- What **major decisions** are already settled and should be recorded as ADRs?
- Which **personas** would help (e.g. a reviewer, a domain specialist)?
- What is the **current focus / backlog** an agent should know about?
- Are there any **unwritten conventions** or terminology that should be codified in
  `terms.rule.md`?
- What are the architecture/Devops decisions that should be captured in ADRs, but not discoverable from the code alone (e.g., deployment strategies, scaling policies)?

Keep it short; offer sensible defaults inferred from step 4 so the user can just
confirm. Never ask for secrets.

### 6. Create or upgrade the target manifest

Write into the **target** repo. Follow the template's folder layout and naming
suffixes from `manifest-structure.rule.md`.

**Always produce (required core):**

- `AGENTS.md` at the target root — real, short project mandates and a pointer to
  `.agents/rules/routing.rule.md`.
- `.agents/rules/manifest-structure.rule.md` — copy the template's version
  verbatim (it is generic and required). Adjust only if the target genuinely
  diverges from the standard folders.
- `.agents/rules/routing.rule.md` — real routing tables that point at the docs
  you actually create for the target. Remove example rows.
- `.agents/rules/terms.rule.md` — real terms from the target's vocabulary (step 4).

**Produce as the repo warrants (tailored, not example copies):**

- `.agents/adr/` — start with the meta-ADR (record architecture decisions), then
  one ADR per real, already-settled decision from steps 4–5.
- `.agents/reference/` — a `*.ref.md` per real subsystem worth documenting.
- `.agents/guides/` — `setup.md` and `commands.md` filled with the target's real
  setup steps and commands; add `notes.md` if useful.
- `.agents/plans/backlog.plan.md` — seeded from the target's real open work.
- `.agents/personas/` — only personas that fit the target (adapt `reviewer`;
  include `manifester` so the target can maintain its own docs).
- `.agents/skills/` and `.agents/actions/` — only if the target has a real
  repeatable procedure or check worth capturing. Do **not** copy
  `example-add-module` or `verify-docs-in-sync` unless they genuinely apply.

**Upgrade path specifics:** for an existing manifest, make the smallest set of
changes that brings it in line with the structure — add missing required files,
fix misplaced docs, repair naming suffixes and links, and fill obvious gaps.
List anything that needs human judgment instead of guessing.

### 7. Replace examples with real content

This is the point of the skill. Every document you write must describe the
**target's** real business — not the template's example domain.

- No "example subsystem", "example feature", "User Sync", or placeholder rows
  should remain in the target.
- Delete any example file you scaffolded but did not turn into real content,
  rather than leaving filler in the target.
- Keep `manifest-structure.rule.md` (generic and required) and the structural
  shape of `routing.rule.md`, but their entries must reference real target docs.

### 8. Preserve, verify and report

- Keep existing ADRs, instructions, skills, etc. in the target — only edit them if required, move them if required, or add new ones. Never delete or rewrite an existing ADR without explicit approval; feel free add to it or flag it for review.
- All internal links in the target manifest resolve (relative paths correct).
- Naming suffixes match the folder (`*.adr.md`, `*.ref.md`, `*.rule.md`,
  `*.agent.md`, `SKILL.md`).
- No template/example content leaked into the target.
- `AGENTS.md` points to `routing.rule.md`, and routing points to docs that exist.

Then summarize for the user: files created/updated in the target, decisions
recorded, anything flagged for human review, and the tool-wiring next step
(point them to the target's new `setup.md`, mirrored from
[`../../guides/setup.md`](../../guides/setup.md)).

## Decision tree

```
Workspace folders?
├─ Only this template open ............ STOP: ask user to add their repo
├─ Exactly two ........................ target = the other folder
└─ More than two / ambiguous .......... ASK which folder is the target

Target has .agents/ ?
├─ No ................................. CREATE full structure (step 6)
└─ Yes ................................ UPGRADE in place; never overwrite ADRs
```

## Completion checks

- The target repo has at minimum: `AGENTS.md`, `rules/manifest-structure.rule.md`,
  `rules/routing.rule.md`, and `rules/terms.rule.md`.
- Every file written reflects the target's real business; no example content
  remains.
- Existing ADRs in the target were preserved (added to or flagged, never
  silently rewritten).
- The summary lists created/updated files and any items left for the user.
