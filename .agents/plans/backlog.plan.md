---
name: Project Backlog
overview: The canonical multi-session backlog for this repository. Immediate work, longer-term items, and active context for agents and maintainers. Decisions in adr/ remain authoritative when a backlog item conflicts with architecture.
todos:
  - id: example-done
    content: Example of a completed item (kept to show the format)
    status: completed
  - id: example-pending
    content: Example of a pending item an agent could pick up next
    status: pending
isProject: true
---

# Project Backlog

> **Multi-session tracker.** This file is the canonical backlog. Keep the YAML
> `todos` block and the checklists below in sync. ADRs remain authoritative when
> a tracker item conflicts with architecture.

When you finish an item, check it off **and** update its status in the YAML
`todos` block above so tools and agents stay in sync.

## Purpose

- **Role:** One-line description of what this project does.
- **Tracking scope:** Sprint work, deferred R&D, and durable backlog items
  broader than a single ADR implementation plan.

## Immediate Work

- [x] _(example)_ A finished task, kept to show the checked format.
- [ ] _(example)_ The next task an agent should pick up.

## Long-Term Backlog

- [ ] _(example)_ Stream large provider pages in the example subsystem (see
  [`../reference/example-subsystem.ref.md`](../reference/example-subsystem.ref.md)).

## Active Context

- **Primary goal:** What the current focus is.
- **Related simple work:** Top-level plan, e.g.
  [`example-feature.plan.md`](example-feature.plan.md).
- **Related epic:** Link to its master roadmap, e.g.
  [`example-epic/example-epic-master.plan.md`](example-epic/example-epic-master.plan.md).
  The `example-epic/` directory is template-only and must not be copied into a
  target repository.
