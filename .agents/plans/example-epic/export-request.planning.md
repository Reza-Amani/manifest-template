---
name: Export Request Detailed Plan
overview: Template-only implementation handoff for the export request spec.
todos:
  - id: add-job-contract
    content: Add the export job contract and request validation
    status: pending
  - id: implement-request-service
    content: Implement authorized idempotent job creation
    status: pending
  - id: expose-request-endpoint
    content: Expose the request endpoint and map errors
    status: pending
  - id: verify-request-flow
    content: Run the focused request checks and acceptance criteria
    status: pending
isProject: false
---

# Export Request Detailed Plan

> **Template-only example.** This file and its whole `example-epic/` directory
> show the epic planning layout. Do not copy them into a target repository.

## Spec

Source of truth: [`export-request.spec.md`](export-request.spec.md).

## Approach

Add a service operation that validates filters, checks admin access, and creates
or reuses a queued export job by idempotency key. Expose it through the existing
transport boundary. Keep job processing and file storage out of this part.

## File-level changes

Replace these example paths with real paths when creating a target plan:

- `src/exports/contracts` — define the request and queued-job result.
- `src/exports/service` — validate, authorize, and create or reuse the job.
- `src/exports/transport` — expose the request and map domain errors.

## Out of scope

- Running export jobs.
- Reporting progress or cancellation.
- Download authorization and file expiry.

## Risks

- Idempotency must be enforced at the storage boundary, not only in process.
- Authorization must happen before existing job details are returned.

## Acceptance criteria

> This section demonstrates what `plan-to-criteria` adds after the Cursor-style
> plan exists. The paths and commands are illustrative because this is a
> template-only epic.

- [ ] A valid admin request with report filters returns a queued job identifier
  without waiting for generation. Covered by
  `tests/exports/export-request.integration.test.ts`.
- [ ] Repeating a request with the same request key returns the same identifier
  and leaves only one stored job. Covered by
  `tests/exports/export-request.service.test.ts`.
- [ ] Invalid filters identify the invalid input and create no job. Covered by
  `tests/exports/export-request.integration.test.ts`.
- [ ] A storage or queue failure reports that the request was not accepted and
  a retry can create the job. Covered by
  `tests/exports/export-request.service.test.ts`.
- [ ] A non-admin request is denied, reveals no job details, and creates no job.
  Covered by `tests/exports/export-request.integration.test.ts`.
- [ ] The focused tests pass with
  `npm test -- tests/exports/export-request.service.test.ts tests/exports/export-request.integration.test.ts`.
- [ ] The repository's normal build, typecheck, and test commands pass.
