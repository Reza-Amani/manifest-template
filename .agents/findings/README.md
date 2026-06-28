# Findings

Durable records of **discoveries, analyses and investigations** — what question was asked (if any),
how it was answered, and what the result was. Findings make one-off analysis
work reproducible and reusable so the next person (human or agent) does not
repeat the query from scratch. Also howme for whatever you discovered all of a sudden!

Findings are useful for **both** repo types: an operation / data repo captures
data analyses here; a software repo captures investigation results here (a
performance dig, a root-cause analysis).

> Findings are **not** decisions and **not** mechanics. A decision goes in
> [`../adr/`](../adr/); how a subsystem works goes in
> [`../reference/`](../reference/). A finding records a specific question and its
> answer at a point in time.

## Naming

Use dated, descriptive Markdown files:

- `YYYY-MM-DD-topic.md`

Example-only placeholder material may live under [`example/`](example/). Do not
put real findings there.

## What belongs in a finding (all optional)

- **Question:** what was asked and why.
- **Sources & parameters:** which data sources, date range, filters, and query
  parameters — enough to **reproduce** the result. Reference env-var names for
  any credential, never secret values (see
  [`../rules/operation-secrets.rule.md`](../rules/operation-secrets.rule.md)).
- **Method:** the steps, query, or notebook used.
- **Result:** the numbers/charts and what they mean.
- **Caveats:** data-quality issues, assumptions, and open questions.

## What does not belong here

- Decisions → [`../adr/`](../adr/).
- Subsystem / pipeline mechanics → [`../reference/`](../reference/).
- Multi-session project work → [`../plans/`](../plans/).
- `teach` session records → [`../learning/`](../learning/).

## Promote durable insights

If a finding leads to a lasting decision, write an ADR and link back. If it
documents how a pipeline works, move that into a reference doc.
