# Finding (example): GA4 organic traffic drop, week of 2026-01-08

> **Example finding — replace or delete.** It shows the format an analysis
> record should follow. Real findings live as dated files in
> [`../`](../), not under `example/`.

## Question

Why did organic sessions fall ~30% in the week of 2026-01-08 versus the prior
week?

## Sources & parameters

- Source: GA4 property `123456789` (see
  [`../../reference/operation-connections.ref.md`](../../reference/operation-connections.ref.md)).
- Credential: `GA4_SA_KEY_PATH` (env-var name only; never the value).
- Date range: 2026-01-01 → 2026-01-14, compared week over week.
- Dimensions: `sessionDefaultChannelGroup = "Organic Search"`; Country = all.

## Method

Pulled daily organic sessions from the marts layer (not raw), split by landing
page and device, and compared the two weeks.

## Result

The drop concentrated on a single landing page that was de-indexed after a
deploy on 2026-01-07. Other pages were flat. Estimated impact: ~28% of the
organic decline.

## Caveats / open questions

- One day (2026-01-09) had a partial data gap from a failed refresh.
- Does the de-indexed page recover after the fix ships? Tracked in
  [`../../plans/backlog.plan.md`](../../plans/backlog.plan.md).
