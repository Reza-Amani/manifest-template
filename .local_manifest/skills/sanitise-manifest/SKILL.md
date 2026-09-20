---
name: sanitise-manifest
description: "Sanitise or sanitize a target repository's manifest: repair duplicate, outdated, conflicting, or misplaced information; separate durable ADR decisions from implementation references; trim fluff. Use when asked to clean up, deduplicate, audit, or shorten a manifest."
---

# Sanitise Manifest

Repair the target repository's manifest in place. Keep one authoritative home
for each fact, preserve decision intent, and leave less text to maintain.
This is a repair workflow, not just a report or a template upgrade.

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
- **Uncertainty:** ask only for an unresolved decision, ownership question, or
  permission that blocks a repair. Continue independent repairs. Do not invent
  facts, choose between equally authoritative decisions, or accept a proposal
  on the user's behalf.

### 3. Separate Decisions from Mechanics

Inspect every ADR section, not just its title. Keep the durable choice, its
context and rationale, real alternatives or trade-offs, constraints, and
consequences. Technical detail belongs in an ADR when it defines or explains
the decision; it is not misplaced merely because it mentions an API or tool.

Move changeable wiring, file inventories, command walkthroughs, configuration
examples, API indices, rollout steps, and debugging recipes to their proper
homes under the target's placement rules:

| Content | Home |
| --- | --- |
| Current implementation mechanics and inventories | `reference/*.ref.md` |
| Operator tutorials and how-to instructions | `guides/` |
| Repeatable multi-step or one-step agent procedures | `skills/` or `actions/` |
| Project-wide conventions or canonical terminology | `rules/` |
| Pending work or point-in-time investigation results | Plans/backlog or findings |

Use an existing document where possible. For an editable ADR, extract only
the misplaced material, leave a concise decision-focused record, and add
relative links between it and the destination when useful. Check the extracted
mechanics against current evidence before presenting them as current guidance.
Never remove the reasoning that makes a decision understandable.

Respect ADR immutability. If the target forbids editing accepted ADRs, leave
their bodies intact and report the proposed extraction and destination as
blocked pending explicit authorization. Do not create a replacement ADR just
to relocate prose. A genuine decision change follows the target's supersession
process and requires user confirmation; cleanup alone is not a new decision.
Preserve ADR identifiers, statuses, and historical context.

### 4. Trim and Repair Discovery

Remove filler, repeated introductions, redundant examples, and restatements
of linked authority. Prefer short, direct sentences. Retain necessary caveats,
safety checks, rationale, and actionable detail; brevity is not a word quota.
Do not split a small coherent document into many tiny files.

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
- Check moved content has one canonical home, remaining references resolve,
  routing points to the right documents, and skill frontmatter remains valid.
- Run the target's relevant documentation checks and whitespace check. Report
  unavailable checks and inaccessible files instead of claiming full coverage.
- Recheck repaired topic groups for remaining duplication or contradictions;
  do not broaden the task into implementation fixes or new architecture.

## Output

Leave the repaired files in the target repository. Give a brief summary of
what was consolidated, corrected, moved, or removed, followed by verification
results and any unresolved issues with paths and the decision needed. State
any coverage exclusions. Do not add a permanent audit report unless requested.