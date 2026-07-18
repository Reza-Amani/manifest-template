# Export Request Spec

> **Template-only example.** This file and its whole `example-epic/` directory
> show the epic planning layout. Do not copy them into a target repository.
>
> Produced from user input for one part of
> [`example-epic-master.plan.md`](example-epic-master.plan.md). Status: ready
> for planning.

Workspace admins should be able to ask for a large report export without
waiting for the file to be built or keeping the browser open.

## Intended behavior

### Requesting an export

- When a workspace admin requests an export with valid report filters, the
  system accepts it and gives the admin a job they can follow later.
- The admin does not wait for file generation. The request finishes once the
  job is safely queued.
- Closing the browser after the request does not cancel the job.
- When the same request is repeated with the same request key, the admin gets
  the original job instead of creating a duplicate.

### When the request cannot be accepted

- When report filters are invalid, the admin sees which input needs attention
  and no export job is created.
- When the job cannot be stored or queued, the admin sees that the request was
  not accepted and can safely try again.
- When someone who is not a workspace admin requests an export, access is
  denied without revealing export or job details.

### Boundary of this phase

- This phase ends once the request has produced a durable queued job.
- Generating the file, showing progress, cancelling work, downloading files,
  and expiring files belong to later phases of the epic.
