---
name: Example Epic Master Plan
overview: Template-only high-level roadmap for background report exports, split into independently plannable phases.
todos:
  - id: export-request
    content: Accept and queue an authorized export request
    status: pending
  - id: job-lifecycle
    content: Process jobs and expose progress, failure, and cancellation
    status: pending
  - id: secure-downloads
    content: Authorize downloads and expire completed files
    status: pending
  - id: operations-rollout
    content: Add operational controls and roll out background exports
    status: pending
isProject: true
---

# Example Epic Master Plan

> **Template-only example.** This file and its whole `example-epic/` directory
> show the epic planning layout. Do not copy them into a target repository.

## Source

Human starting intent: [`example-epic-initial.md`](example-epic-initial.md).
This roadmap must remain consistent with that note. It does not replace it.

## Purpose

This master plan is the epic backlog and roadmap. It splits the work into parts
and records order and dependencies. It is not detailed enough to implement.
Each part must move through a user-approved spec before `spec-to-plan` creates
its detailed implementation plan. `plan-to-criteria` then adds proof before
`implement-plan` builds the phase.

## Intended outcome

Workspace admins can request large report exports, leave the browser, follow
progress, and securely download completed files for a limited time.

## High-level requirements

- Export work must not slow normal report views.
- Only authorized workspace admins may request or download exports.
- Jobs must expose a stable lifecycle from request through expiry.
- Operators must be able to observe failures and control rollout.

## High-level architecture

The existing report boundary accepts export requests and stores jobs for
background workers. Workers create files outside the request path. Job state
connects the request, progress, cancellation, and download phases. File storage
enforces retention after completion.

## Phases

- [ ] **export-request: Accept and queue requests** — validate admin requests,
  create one durable job, and return without generating the file. This phase
  has no worker or download behavior.
  - Spec: [`export-request.spec.md`](export-request.spec.md)
  - Detailed plan: [`export-request.plan.md`](export-request.plan.md)
- [ ] **job-lifecycle: Process and track jobs** — run queued work and expose
  progress, failure, retry, and cancellation. Depends on `export-request`.
- [ ] **secure-downloads: Deliver and expire files** — authorize completed-file
  downloads and enforce retention. Depends on `job-lifecycle`.
- [ ] **operations-rollout: Operate the feature** — add monitoring, limits, and
  staged rollout controls. Depends on the earlier behavior phases.

## Out of scope

- Changing how interactive report views are generated.
- Supporting non-admin export requests.
