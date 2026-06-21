# ADR-0001: Example — Layered Architecture and Module Boundaries

> **This is a filled-in example ADR.** It exists to show the format and the
> level of detail an ADR should have. Replace it with a real decision for your
> project, or delete it.

## Status

Accepted

## Context

The application started as a single module where HTTP handlers talked directly
to the database driver. As features grew, business logic leaked into the HTTP
layer and into SQL queries, making the code hard to test and risky to change.
We need clear boundaries so each layer has one responsibility and can be tested
in isolation.

## Decision

We organize the codebase into three layers with a strict, one-directional
dependency rule:

1. **Transport** (`/transport`) — HTTP/CLI entry points. Parses input, calls the
   service layer, formats output. Contains no business rules.
2. **Service / domain** (`/service`) — business logic and rules. Knows nothing
   about HTTP or SQL. Depends only on interfaces it defines.
3. **Storage** (`/storage`) — persistence adapters that implement the interfaces
   the service layer declares.

Rules:

- Dependencies point **inward only**: Transport → Service → Storage interfaces.
  The service layer never imports the transport or a concrete storage package.
- The service layer defines the storage interfaces it needs; storage packages
  implement them.
- Cross-cutting concerns (logging, config) are passed in explicitly, not reached
  through globals.

## Consequences

- Business logic is unit-testable without a server or a real database.
- Swapping a storage backend touches only the storage layer.
- There is some boilerplate: each capability needs an interface plus an adapter.
- **Agent directive:** Never call storage drivers directly from transport code.
  Never put business rules in handlers. New features add a service method first,
  then wire transport and storage to it.

## References

- Mechanics and current wiring: [`reference/example-subsystem.ref.md`](../reference/example-subsystem.ref.md).
- How we record decisions: [`0000-record-architecture-decisions.adr.md`](0000-record-architecture-decisions.adr.md).
