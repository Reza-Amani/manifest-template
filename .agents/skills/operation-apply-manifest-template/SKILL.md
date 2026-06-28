---
name: operation-apply-manifest-template
description: >-
  Bootstraps or upgrades an agent manifest in a *target operation / data
  repository* (scripts and instructions for data sources like GA4 or Salesforce,
  dashboards, data collection) using this template as the source of truth.
  Studies the target's data sources, pipelines, metrics, and dashboards, then
  creates a tailored `.agents/` manifest with real, repo-specific content.
  Use when the user opens their data/ops repo alongside this template and asks to
  "apply the manifest template for my data repo", "set up the manifest in my
  operations repo", or "scaffold .agents for this analytics project".
---

# Apply Manifest Template — Operation / Data Repos

The final goal is to reshape the target repo into a manifest that is tailored to its real content. At the end, we want the target repo to have a `.agents/` folder with the same structure as this template, but filled with the target's real data sources, pipelines, metrics, dashboards, and other operation/data-specific content.

This is the operation/data counterpart to
[`../apply-manifest-template/SKILL.md`](../apply-manifest-template/SKILL.md). The
**mechanics are the same** — identify source and target, study the target, fill
the manifest with real content, and keep one clearly marked example per folder.
Read that skill for the shared procedure, decision tree, and safety rules. This
file lists only what is **different for a data-analyst / data-science repo**.

**Persona:** Run as the Manifester
([`../../personas/manifester.agent.md`](../../personas/manifester.agent.md)) —
plain English, one fact in one place, correct placement and links.

> **Safety:** Never write into this template repo. Never read, print, or request
> secret values — see
> [`../../rules/operation-secrets.rule.md`](../../rules/operation-secrets.rule.md).

## What to study in an operation repo

Instead of services and modules, gather:

- **Data sources:** GA4 properties, Salesforce orgs, APIs, files — their auth
  method and refresh cadence. Note which hold PII.
- **Pipelines / flow:** extract → stage → marts → dashboard scripts, schedulers,
  and warehouse layout.
- **Metrics:** how key numbers (active user, MQL, conversion) are defined and
  where.
- **Dashboards / reports:** what exists and which layer each reads from.
- **Credentials handling:** where secrets live today (env vars, secret store).
  Record env-var **names** only.
- **Open work:** requested dashboards, pending data pulls, and known
  data-quality issues.

The goal of this study is to understand the target's real content so the manifest can be filled with it in a logical and accurate manner. 

## What to produce (tailored, not example copies)

Follow the structure in
[`../../rules/manifest-structure.rule.md`](../../rules/manifest-structure.rule.md).
Beyond the required core (`AGENTS.md`, `manifest-structure.rule.md`,
`routing.rule.md`, `terms.rule.md`), produce the operation-flavored docs:

- `adr/` — start with the meta-ADR, then real decisions such as data-layering or
  metric ownership (see the example
  [`../../adr/0002-operation-data-layering.adr.md`](../../adr/0002-operation-data-layering.adr.md)).
- `reference/operation-connections.ref.md` — the real connection inventory
  (env-var names only, never secrets).
- `rules/operation-secrets.rule.md` — the repo's real secret & privacy policy.
- `rules/terms.rule.md` — the real **metric glossary** (one definition per
  metric).
- `skills/` — real data runbooks (onboarding a source, refreshing an extract,
  building a dashboard).
- `findings/` — seed [`../../findings/README.md`](../../findings/README.md) so
  analyses are captured reproducibly.
- `plans/backlog.plan.md` — seeded from real requested reports and data work.

## Interview the user

Ask only what the repo cannot reveal, for example: which metrics are canonical; where the secrets are kept; and
the non-negotiable data-governance rules; what is the purpose of that dashboard.
Provide logical options for each question, including "I don't know yet". If the user cannot answer, provide further options to treat the topic; do your best to provide the most logical approach.  

## Finish

Verify links, naming suffixes, and placement as in the base skill, then
summarize what was created and flag anything needing human review.
