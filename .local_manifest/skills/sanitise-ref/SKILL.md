---
name: sanitise-ref
description: "Critically review and sanitise (sanitize) a single user-specified reference doc (*.ref.md) with an open mind: check against ADRs (violations), codebase facts (drifts and important omissions), other manifest files (duplications and conflicts), and placement (wrong file, mixed irrelevant content, unnecessary topic splits); demonstrate each problem with fix options; and apply approved edits following manifester standards. Use when asked to review, audit, verify, clean up, or sanitise a specific reference file."
---

# Sanitise Ref

Critically review one reference document (`*.ref.md`) chosen by the user,
demonstrate every finding with concrete options, and apply the approved changes
cleanly.

## Mindset: Treat the Reference Doc as Unverified Notes

While this skill runs, **do not assume the reference doc is right.**

- Read the target `*.ref.md` with an open, critical mind. Question every claim,
  path, command, diagram, and rule in it.
- Follow manifest authority: **ADRs govern intended decisions**
  (`ADRs > reference notes`), and **the codebase establishes current
  mechanics**.
- If the ref doc disagrees with an ADR or with the code, flag the mismatch
  plainly. If the code itself appears to violate an accepted ADR, report that
  gap honestly rather than hiding it or changing the ADR.

## Inputs and Scope

- **Target ref file:** the `*.ref.md` file, path, or title given by the user.
  If none is given or several files match (including across repositories in a
  workspace), ask the user to pick one before reviewing.
- **Read context narrowly:** before auditing, read the target repo's root
  `AGENTS.md`, both `routing.rule.md` files, `manifest-structure.rule.md`, and
  the `manifester` persona (`.team_manifest/personas/manifester.agent.md` if
  present).
- **Detect repo layout:** check whether `.local_manifest` is a real directory
  (`solo`) or a symlink (`team`) per
  [`.team_manifest/guides/manifest-layout.md`](../../../.team_manifest/guides/manifest-layout.md).
  Use this when proposing `.team_manifest/` vs. `.local_manifest/` paths.
- **No edits before approval:** do not edit any file until the user chooses what
  to do. Never change application code.

## Procedure

### 1. Audit Against ADRs (Violations)

Find ADRs relevant to the ref doc's domain using routing and `.team_manifest/adr/`
listings. Read only the relevant ADRs and check for:

- **Direct violations:** guidance, wiring, or defaults in the ref doc that
  contradict an accepted ADR.
- **Silent overrides:** wording that softens, reinterprets, or adds exceptions
  to an ADR without authority.
- **Code-vs-ADR gaps:** places where the ref doc accurately describes current
  code that appears to diverge from an accepted ADR. Distinguish a wrong ref
  doc from an implementation gap.

### 2. Audit Against the Codebase (Drifts and Important Omissions)

Inspect the codebase (source files, config, schemas, CLI commands, scripts, and
tests) wherever possible to verify concrete claims in the ref doc and check the
related topic's code for high-value gaps. Look for:

- **Stale mechanics:** outdated file paths, symbols, function names, pipelines,
  wiring, config keys, defaults, or command flags.
- **Wrong behavior:** steps, caveats, or edge cases that no longer match how
  the code actually runs.
- **Important omissions:** facts present in the related code that are absent
  from the ref doc and genuinely matter for future implementation or debugging
  (for example, non-obvious caveats, failure modes, active flags/config, key
  wiring, or pipeline steps added since the doc was written). Skip trivial or
  self-evident code details so the ref doc stays concise.
- **Unverifiable claims:** statements about external systems or runtime state
  that cannot be checked from the repo — note them as unverified rather than
  guessing.

Cite the exact file paths and symbols you checked as evidence.

### 3. Audit Against Other Manifest Files (Duplications and Conflicts)

Check routing and related manifest files in the same domain (other
`reference/*.ref.md`, `rules/`, `guides/`, `skills/`, `actions/`, `adr/`). Look
for:

- **Duplications:** facts, rules, canonical terms, or procedures copied from
  another manifest file that already owns them.
- **Conflicts:** statements that disagree with `terms.rule.md`, another
  reference doc, a rule, a guide, or a skill.

### 4. Audit Placement and Structure (Incorrect Placing)

Check whether every part of the file belongs in this `*.ref.md`:

- **Wrong document type / folder:** content that does not belong in `reference/`
  at all:

| Non-reference content found | Best manifest home |
| --- | --- |
| Durable architectural or business decisions | `.team_manifest/adr/*.adr.md` (only with explicit user approval) |
| Project-wide conventions or canonical terms | `.team_manifest/rules/<category>.rule.md` |
| Human-facing tutorials or operator how-tos | `.team_manifest/guides/<name>.md` |
| Repeatable multi-step or one-step agent procedures | `skills/<name>/SKILL.md` or `.team_manifest/actions/<name>.md` |
| Point-in-time investigation or measurement evidence | `.local_manifest/findings/YYYY-MM-DD-<topic>.md` |
| Future ideas, TODOs, or deferred work | `.team_manifest/backlog.plan.md` or `.local_manifest/plans/` |
| Revision history or changelog blocks | Remove (version control tracks history) |

- **Mixed with irrelevant content:** unrelated topics bundled into this file
  that hurt narrow context loading.
- **Unnecessary topic split:** one coherent topic split across multiple
  reference files when keeping it in one file is simpler and clearer.

Respect solo/team ownership when suggesting a path:

- **`solo` repo:** `reference/` and `skills/` live only in `.local_manifest/`.
  Do not suggest `.team_manifest/reference/` or `.team_manifest/skills/`.
- **`team` repo:** team-wide `reference/` and `skills/` go in
  `.team_manifest/`; personal ones go in `.local_manifest/`.

Prefer removing stale/low-value text or merging into an **existing** manifest
file before proposing a new file.

### 5. Demonstrate Problems and Ask for Direction

Before making any edits, present every finding clearly, grouped by category:

1. **ADR violations**
2. **Codebase drifts and important omissions**
3. **Manifest duplications and conflicts**
4. **Placement and structure issues**

For **each** item:

- **Demonstrate the problem:** quote or cite the section in the ref file (or
  note where the topic is silent for an omission), show the concrete evidence
  (ADR passage, code path/symbol, other manifest file, or placement rule), and
  explain why it matters.
- **Provide fix options** with one marked **(Recommended)** — for example:
  - Update the ref doc to match verified code,
  - Add a missing high-value fact to the ref doc (name the target section),
  - Align with the ADR (or document a code-vs-ADR gap explicitly),
  - Replace duplicated text with a short relative link to the canonical owner,
  - Merge split files into one canonical ref file (name the exact path),
  - Move misplaced content to an existing or new manifest file (give exact path,
    suffix, and section),
  - Remove stale or low-value text,
  - Keep as-is / skip.

Ask the user to pick an option for each item (or approve all recommended options
with any overrides). If a category has no issues, say so plainly.

### 6. Apply Approved Changes (Manifester Standards)

Apply **only** what the user chose. Follow the
[`manifester`](../../../.team_manifest/personas/manifester.agent.md) persona and
[`manifest-structure.rule.md`](../../../.team_manifest/rules/manifest-structure.rule.md):

- **Plain English:** short sentences, common words, no jargon, no fluff. A new
  team member should understand every line on the first read.
- **One fact, one place:** do not copy moved content. Leave a short relative
  link only where a reader needs it.
- **Smallest edit:** change only what the user approved; leave sound parts
  untouched.
- **No revision history:** do not add changelog blocks inside manifest files.
- **Verify written facts:** ensure every updated or moved mechanical detail
  matches the code you inspected.
- **Respect ADR authority:** never edit or create an ADR unless the user
  explicitly chose that option.
- **Correct placement and naming:** use the right tree (`.team_manifest/` vs.
  `.local_manifest/`), folder, suffix (`*.ref.md`, `*.adr.md`, `*.rule.md`,
  etc.), and frontmatter (only when required).
- **Keep discovery in sync:** update the matching `routing.rule.md` for any new,
  renamed, merged, or removed file, and fix any affected relative links or
  incoming references. If a skill was created or renamed, run
  `.team_manifest/scripts/sync-skill-links.ps1` (or `.sh`) or remind the user to
  run it.

### 7. Verify and Summarise

- Review your diff to confirm every change matches the user's choices, no
  application code was edited, and no broken links or duplicate facts remain.
- Confirm the ref doc is accurate, focused on one coherent topic, and reads
  clearly.
- Give a short, plain-English summary covering:
  - Changes applied to the ref file,
  - Content updated, added, merged, moved, removed, or placed in new files
    (with exact paths),
  - Routing or link updates made,
  - Any items the user chose to keep, defer, or note as follow-up (such as
    code-vs-ADR gaps).
