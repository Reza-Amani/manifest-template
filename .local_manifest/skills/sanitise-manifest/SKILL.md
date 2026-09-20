---
name: sanitise-manifest
description: "Sanitise or sanitize a target repository's manifest: repair duplicate, outdated, conflicting, or misplaced information; de-bloat ADRs by moving mechanics, recommendations, and future ideas to their proper homes; trim fluff. Use when asked to clean up, deduplicate, audit, shorten, or de-bloat a manifest or its ADRs."
---

# Sanitise Manifest

Repair the target repository's manifest in place. Keep one authoritative home
for each fact, preserve decision intent, and leave less text to maintain.
This is a repair workflow, not just a report or a template upgrade.

The manifest better to end smaller and sharper than it started. Work autonomously:
make obvious repairs without asking, and do not narrate them as you go.

## Inputs and Scope

- Use the repository named by the user, or the sole unambiguous target in the
  workspace. Ask if several repositories could be the target; do not assume
  the template repository is the target.
- Read the target's root `AGENTS.md`, manifest entry points, routing files,
  placement rules, and ADR policy before editing. Follow its conventions,
  not a fresh copy of this template.
- Detect the existing solo/team layout and shared/personal ownership. Resolve
  symlinks for inventory purposes so the same file is not processed twice.
  Do not migrate the layout, edit discovery-shim copies, or move personal
  content into shared storage without authorization.
- Inspect existing changes and preserve unrelated work. Limit edits to
  manifest documents and affected documentation links or discovery entries;
  do not change application code to make a document true.

## Procedure

### 1. Inventory and Compare

List documents in both manifest trees, including files absent from routing.
Review them in small topic groups rather than loading everything at once.
Cover each group's decisions, rules, references, and workflows together;
retain a short working list of issues and canonical owners across groups.
Treat the entry points and discovery maps as part of the audit.

Look for repeated facts or procedures, incompatible instructions, stale paths
or commands, obsolete descriptions, misplaced sections, and unnecessary prose.
Distinguish current guidance from examples, proposals, and dated history.
Old age, an unlinked file, or different wording alone does not prove a defect.

For each candidate repair, identify the source, evidence, intended canonical
home, and any readers or links affected. Inspect relevant code, configuration,
tests, or history only as needed to verify a concrete claim.

### 2. Resolve by Authority and Evidence

- **Duplicates:** merge unique, still-valid information into the owning
  document; replace other copies with short links only where discovery needs
  them. Prefer an existing owner over creating another file.
- **Outdated mechanics:** correct descriptive references using verified
  implementation evidence. Remove obsolete instructions only when their
  replacement or lack of relevance is established.
- **Conflicts:** follow the target's authority rules and ADR status or explicit
  supersession chain, not file timestamps. Accepted decisions govern intended
  behavior; code establishes current mechanics. If they disagree, describe the
  implementation gap accurately and flag it, rather than silently changing
  the decision or claiming the code complies.
- **Autonomy:** make obvious repairs on your own judgment, including moving
  clearly misplaced content out of an ADR. Ask only when a repair would change
  what a decision requires, move personal content into shared storage, or rests
  on a fact you cannot verify. Collect those few questions for the final
  summary instead of interrupting. Do not invent facts, choose between equally
  authoritative decisions, or accept a proposal on the user's behalf.

### 3. Keep ADRs to Decisions

Inspect every ADR section, not just its title. An ADR is bloated when it also
carries current mechanics, command walkthroughs, configuration samples,
inventories, advisory preferences, interim habits, or future ideas.

Apply the commitment test to each passage. Keep it in the ADR when it states a
choice the project committed to, or supplies the context, trade-offs,
constraints, or consequences needed to understand that choice. Interim and
reversible decisions still pass. Guidance an agent could reasonably set aside
within an ordinary task does not; neither does detail that merely mentions an
API or tool. Move what fails the test to its proper home under the target's
placement rules, without inventing new document types:

| Content found in an ADR | Home |
| --- | --- |
| Current mechanics, wiring, inventories, config, API detail | `reference/*.ref.md` |
| Recommended defaults and "best way for now" guidance | `reference/*.ref.md`, worded plainly as guidance rather than a requirement |
| Project-wide conventions or canonical terminology | `rules/` |
| Repeatable multi-step or one-step agent procedures | `skills/` or `actions/` |
| Human-facing tutorials and operator how-to material | `guides/` |
| Future idea or improvement worth keeping | Backlog, or a new initial plan under `plans/` |
| Evidence from an investigation or measurement | `findings/` |

Relocation is not preservation. Delete stale, self-evident, or low-value
material instead of rehoming it, and prefer an existing owner over a new file.
Verify extracted mechanics against current evidence before presenting them as
current, and keep the reasoning that makes a decision understandable.

Preserve ADR identifiers, statuses, supersession links, and historical context.
Extraction leaves the decision itself intact, so it is neither a decision
change nor grounds for a replacement ADR. Demoting an accepted requirement to
advice, or altering what a decision requires, follows the target's supersession
process and needs user confirmation. Where the target forbids editing accepted
ADRs outright, leave those bodies intact and list the proposed extractions in
the summary.

Where the target already documents ADR authority, make sure it separates the
binding decision from the claims around it: accepted decisions govern
implementation within their scope, factual claims and assumptions inside an ADR
stay open to verification, and agents may propose a superseding decision with
evidence instead of treating every ADR sentence as settled. Correct that wording
in place; do not add a document for it.

### 4. Trim and Repair Discovery

Remove filler, repeated introductions, redundant examples, and restatements
of linked authority. Prefer short, direct sentences. Retain necessary caveats,
safety checks, rationale, and actionable detail; brevity is not a word quota.
Do not split a small coherent document into many tiny files.

Hold the line on volume. Do not add framing, transitional prose, migration
notes, or fresh caveats to justify a repair, and do not let a move turn two
lines of ADR text into a page elsewhere.

Preserve plan progress, checkboxes, and historical records. Do not rewrite
archives as current guidance, archive active work, delete scratch artifacts,
or edit records reserved for another workflow, such as `teach` learning files.
Report issues in protected records rather than changing them.

Delete an editable duplicate file only after preserving its useful content
and updating incoming links. Repair relative paths, section anchors, routing,
and affected entry points or inventories in the same change. Search for both
the old path and distinctive section names to catch non-link references.

### 5. Verify and Summarise

- Review the diff for lost meaning, accidental decision changes, ownership
  changes, and unrelated edits. Each repair must have an evidence-based reason.
- Confirm the manifest did not grow: no new document that an existing owner
  could have absorbed, and no section that only restates what it replaced.
- Check moved content has one canonical home, remaining references resolve,
  routing points to the right documents, and skill frontmatter remains valid.
- Run the target's relevant documentation checks and whitespace check. Report
  unavailable checks and inaccessible files instead of claiming full coverage.
- Recheck repaired topic groups for remaining duplication or contradictions;
  do not broaden the task into implementation fixes or new architecture.

## Output

Leave the repaired files in the target repository. Give a brief summary of
what was consolidated, corrected, moved, or removed, followed by verification
results and a short closing list of anything that needs the user: unresolved
issues, blocked extractions, and proposed decision changes, each with its path
and the decision needed. State any coverage exclusions. Do not add a permanent
audit report unless requested.