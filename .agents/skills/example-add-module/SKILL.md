---
name: example-add-module
description: >-
  Adds a new feature module to the codebase following the layered architecture:
  service interface, storage adapter, transport wiring, tests, and docs.
  Use when the user asks to "add a module", "create a new feature", or "scaffold
  a new capability" end-to-end.
---

# Add a Module

> **This is an example skill.** It shows the runbook format: purpose, when to
> use, constraints, a numbered procedure, and completion checks. Replace its
> contents with a real multi-step procedure for your project, or delete it.

Engineer mindset: correctness first, clear boundaries, and tests for anything
non-trivial. Follow the layered architecture in
[`adr/0001-example-layered-architecture.adr.md`](../../adr/0001-example-layered-architecture.adr.md).

## Before coding

1. Read [`reference/example-subsystem.ref.md`](../../reference/example-subsystem.ref.md)
   to see how an existing module is wired.
2. Confirm the naming you will use against
   [`rules/terms.rule.md`](../../rules/terms.rule.md).
3. Skim [`reference.md`](reference.md) in this skill folder for the file layout
   and the copy-paste skeletons.

## Constraints

- Dependencies point inward only: transport → service → storage interface.
- The service layer defines its storage interface; the storage package
  implements it. No business logic in transport code.
- Add tests for any non-trivial behavior before declaring the work done.

## Procedure

Copy this checklist into your working notes and track progress:

```
Task progress:
- [ ] 1. Define the service interface and types in service/<module>/
- [ ] 2. Implement the service logic (no transport/SQL knowledge)
- [ ] 3. Implement the storage adapter in storage/<module>/
- [ ] 4. Wire the transport entry point (HTTP/CLI) to the service
- [ ] 5. Add config keys and defaults
- [ ] 6. Add unit tests for the service; an integration test for the adapter
- [ ] 7. Update docs: reference/, and check off the backlog item
```

1. **Service interface.** Create `service/<module>/` with the public type and the
   storage `Port` interface it needs. See the skeleton in [`reference.md`](reference.md).
2. **Service logic.** Implement the orchestration and rules using only the
   interface. Keep it framework-free.
3. **Storage adapter.** Implement the `Port` in `storage/<module>/`. This is the
   only place that touches the driver/SDK.
4. **Transport wiring.** Add the handler/command that parses input, calls the
   service, and formats output.
5. **Config.** Add new settings with sane defaults and document them in the
   subsystem reference.
6. **Tests.** Unit-test the service with a fake `Port`; integration-test the
   adapter against a real or in-memory backend.
7. **Docs.** Update or add a `reference/*.ref.md` for the module and check off
   the backlog item in [`plans/backlog.plan.md`](../../plans/backlog.plan.md).

## Completion checks

- The new module compiles and all tests pass.
- No transport code imports a storage package directly.
- A reference doc describes the module's wiring and config.
- The backlog entry is checked off (and the YAML `todos` block kept in sync).
