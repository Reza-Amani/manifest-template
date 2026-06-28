---
name: operation-add-data-source
description: >-
  Onboards a new data source (e.g. a Google Analytics 4 property, a Salesforce
  org, or an API) end-to-end for an operation / data repository: register the
  connection, store credentials safely, build the extract, stage and transform,
  define metrics, wire the dashboard, and document it.
  Use when the user asks to "add a data source", "onboard GA4 / Salesforce",
  "connect a new dataset", or "wire up a new report" end-to-end.
---

# Add a Data Source

> **This is an example skill for an operation / data repository.** It shows the
> runbook format for data-analyst / data-science work and sits alongside the
> coding example [`../example-add-module/SKILL.md`](../example-add-module/SKILL.md).
> Replace its contents with a real procedure for your project, or delete it.

Analyst mindset: reproducibility first, one metric defined once, and no secret
ever committed. Follow the layered data flow in
[`../../adr/0002-operation-data-layering.adr.md`](../../adr/0002-operation-data-layering.adr.md)
and the secret rule in
[`../../rules/operation-secrets.rule.md`](../../rules/operation-secrets.rule.md).

## Before you start

1. Read [`../../reference/operation-connections.ref.md`](../../reference/operation-connections.ref.md)
   to see how existing sources are wired and where the inventory lives.
2. Confirm metric names against [`../../rules/terms.rule.md`](../../rules/terms.rule.md).
3. Confirm where credentials must live per
   [`../../rules/operation-secrets.rule.md`](../../rules/operation-secrets.rule.md).

## Constraints

- Data flows one way: extract → stage → marts → dashboard. A dashboard never
  reads a raw source.
- A metric is defined once in the marts layer, never inside a dashboard.
- No credential is committed; reference the env-var name only.

## Procedure

Copy this checklist into your working notes and track progress:

```
Task progress:
- [ ] 1. Register the connection in operation-connections.ref.md (env-var name only)
- [ ] 2. Store the credential in the secret store (never in the repo)
- [ ] 3. Build the extract: land raw data with source, date range, and params
- [ ] 4. Stage: type, rename, dedupe, standardize
- [ ] 5. Define / extend metrics in the marts layer
- [ ] 6. Wire the dashboard to read from the marts layer only
- [ ] 7. Document: update the inventory and check off the backlog item
```

1. **Register the connection.** Add a row to
   [`../../reference/operation-connections.ref.md`](../../reference/operation-connections.ref.md)
   with the account/property, auth method, **env-var name**, refresh, and owner.
   Mark it if it holds PII.
2. **Store the credential** in the secret store (not the repo). Use a read-only,
   least-privilege credential.
3. **Extract.** Build one extract job that lands the raw data untouched and
   records the source, date range, and query parameters so the pull is
   reproducible.
4. **Stage.** Clean the raw data: types, names, dedupe, standard units.
5. **Marts / metrics.** Define any new metric once in the marts layer; reuse
   existing definitions rather than re-deriving them.
6. **Dashboard.** Point the report at the marts layer only.
7. **Document.** Confirm the inventory is current and check off the backlog item
   in [`../../plans/backlog.plan.md`](../../plans/backlog.plan.md). Capture any
   one-off analysis result as a finding in
   [`../../findings/README.md`](../../findings/README.md).

## Completion checks

- The new source appears in the connection inventory with an env-var name (no
  secret value).
- The extract is reproducible (source, date range, parameters recorded).
- Any new metric is defined once in the marts layer, not in a dashboard.
- The dashboard reads only from the marts layer.
- The backlog entry is checked off (and the YAML `todos` block kept in sync).
