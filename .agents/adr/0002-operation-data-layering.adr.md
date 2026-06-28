# ADR-0002: Example — Operation / Data Pipeline Layering

> **This is a filled-in example ADR for an operation / data repository.** It
> exists alongside the coding example
> [`0001-example-layered-architecture.adr.md`](0001-example-layered-architecture.adr.md)
> to show the format for a data-analyst / data-science repo (data sources,
> pipelines, dashboards). Replace it with a real decision for your project, or
> delete it.

## Status

Accepted

## Context

The repository began as a loose set of scripts and notebooks that pulled data
straight from sources (Google Analytics 4, Salesforce) into individual
dashboards. Each report re-implemented its own filters and metric math, so the
same number — for example, "active users" — came out differently in two
dashboards. Pulls were not reproducible because date ranges and query
parameters lived only inside one-off scripts.

We need clear layers so each step has one responsibility, metrics are defined
once, and any result can be re-derived.

## Decision

We organize data work into four layers with a strict, one-directional flow:

1. **Extract (raw)** — pull data from a source exactly as it is and land it
   untouched. No filtering, no business logic. One extract job per source.
2. **Stage (clean)** — type, rename, deduplicate, and standardize the raw data.
   Still no business metrics.
3. **Marts / metrics** — the **one** place business metrics are defined
   (for example, *active user*, *MQL*, *conversion*). See
   [`../rules/terms.rule.md`](../rules/terms.rule.md).
4. **Presentation** — dashboards and reports read **only** from the marts /
   metric layer.

Rules:

- Data flows **one way only**: Extract → Stage → Marts → Presentation. A
  dashboard never queries a raw source or a staging table directly.
- A metric is defined **once** in the marts layer and reused everywhere. Never
  redefine the same metric inside a dashboard.
- Every extract records its source, date range, and parameters so a pull is
  reproducible (see [`../findings/README.md`](../findings/README.md) for how
  one-off analyses capture the same).
- Credentials are never embedded in a layer; they are referenced per
  [`../rules/operation-secrets.rule.md`](../rules/operation-secrets.rule.md).

## Consequences

- One number means one thing everywhere; dashboards agree.
- A source can be swapped by changing only its extract and stage steps.
- Results are reproducible because parameters are captured, not implied.
- There is some overhead: a new metric needs a marts-layer definition before a
  dashboard can use it.
- **Agent directive:** Never pull a raw source straight into a dashboard. Never
  define a metric inside presentation code. New metrics are added to the marts /
  metric layer first, then read by dashboards.

## References

- Connection inventory and wiring:
  [`../reference/operation-connections.ref.md`](../reference/operation-connections.ref.md).
- Secret handling:
  [`../rules/operation-secrets.rule.md`](../rules/operation-secrets.rule.md).
- How we record decisions:
  [`0000-record-architecture-decisions.adr.md`](0000-record-architecture-decisions.adr.md).
