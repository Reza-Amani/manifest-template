---
name: Example Feature Plan
overview: A worked example of a single-feature, multi-step plan with a YAML todos block. Replace with a real plan or delete.
todos:
  - id: design
    content: Agree the interface and config for the feature
    status: completed
  - id: implement-service
    content: Implement the service-layer logic with tests
    status: in-progress
  - id: implement-adapter
    content: Implement the storage adapter
    status: pending
  - id: wire-transport
    content: Wire the HTTP/CLI entry point
    status: pending
  - id: docs
    content: Add a reference doc and check off the backlog item
    status: pending
---

# Example Feature Plan

> **This is an example plan.** A plan tracks one piece of work across multiple
> sessions so an agent can resume where the last one stopped. Replace it with a
> real plan, or delete it.

## Goal

Deliver the example feature end-to-end following
[`../adr/0001-example-layered-architecture.adr.md`](../adr/0001-example-layered-architecture.adr.md)
and the [`example-add-module`](../skills/example-add-module/SKILL.md) skill.

## Milestones

- [x] **Design** — interface and config agreed.
- [ ] **Service** — logic implemented with unit tests. _(in progress)_
- [ ] **Storage** — adapter implemented and integration-tested.
- [ ] **Transport** — entry point wired and validated at the boundary.
- [ ] **Docs** — reference doc added; backlog item checked off.

## Notes / decisions made along the way

- _(dated note)_ Keep brief context here so the next session does not repeat
  research. Promote anything durable into an ADR or reference.
