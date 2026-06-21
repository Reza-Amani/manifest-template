# Notes

A scratch space for durable, human-authored notes that do not yet belong in a
formal ADR or reference. Keep entries short and dated. Promote anything that
becomes a real decision into an ADR, and anything that describes how a subsystem
works into a reference doc.

## Conventions

- Prefer one bullet per note. Add a date so stale notes are easy to spot.
- If a note grows into a decision, move it to [`../adr/`](../adr/) and link back.
- If a note explains mechanics, move it to [`../reference/`](../reference/).

## Operational notes

- _(example, 2025-01-01)_ Local dev uses an in-memory store by default; set
  `STORE=postgres` to test against a real database.

## Open questions

- _(example)_ Should the example subsystem stream large provider pages? Tracked
  in [`../plans/backlog.plan.md`](../plans/backlog.plan.md).
