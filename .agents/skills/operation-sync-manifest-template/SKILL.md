---
name: operation-sync-manifest-template
description: >-
  Brings recent structural updates from this manifest-template into a *target
  operation / data repo's* `.agents/` manifest without overwriting its real
  content (connection inventories, metric glossary, secret policy, dashboards).
  Use when the user opens their data/ops repo alongside this template and asks to
  "sync the manifest template into my data repo", "bring in recent manifest
  updates for my operations repo", or "update my analytics manifest".
---

# Sync Manifest Template — Operation / Data Repos

This is the operation/data counterpart to
[`../sync-manifest-template/SKILL.md`](../sync-manifest-template/SKILL.md). The
**mechanics are identical** — pull only *structural / convention* changes from
this template into the target, preserve the target's real content, and never
edit this template. Read that skill for the full procedure and decision
heuristic. This file lists only the operation-specific care.

> **Safety:** Never edit this template. Never surface secret values — see
> [`../../rules/operation-secrets.rule.md`](../../rules/operation-secrets.rule.md).

## Operation-specific cautions

When classifying each template change as *bring across* vs *skip*, treat the
following as the target's own content and do **not** overwrite it:

- The target's **connection inventory** (`operation-connections.ref.md`) — real
  sources, accounts, env-var names.
- The target's **secret & privacy policy** (`operation-secrets.rule.md`).
- The target's **metric glossary** in `terms.rule.md`.
- The target's **findings**, dashboards, and data runbooks.

Bring across only structural progress that helps **any** manifest:

- New folder types (for example `findings/`) and their naming rules.
- Updated placement, routing, and cross-link conventions.
- Persona and frontmatter convention updates.

Skip template example content entirely (anything named `operation-*` example,
`example-*`, or the apply/sync meta-skills themselves).

## Finish

Validate links and markdown in the edited target files, then summarize what was
brought across and what was deliberately skipped and why.
