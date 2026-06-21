# example-add-module — Supporting Reference

> Skills may include supporting files alongside `SKILL.md` (skeletons, schemas,
> checklists, sample data). This file is an example asset for the `example-add-module`
> skill. Keep heavy detail here so `SKILL.md` stays short and scannable.

## Target file layout

```
service/<module>/
  service.go      # public type + Run/Do methods (business logic)
  port.go         # storage interface this service depends on
  service_test.go # unit tests using a fake Port
storage/<module>/
  adapter.go      # implements service/<module>.Port
  adapter_test.go # integration test
transport/<module>/
  handler.go      # HTTP/CLI entry; parse → call service → format
```

## Service interface skeleton

```go
package <module>

import "context"

// Port is the storage capability this service needs.
// The storage package implements it; the service never imports storage.
type Port interface {
    Get(ctx context.Context, id string) (Record, error)
    Save(ctx context.Context, r Record) error
}

type Service struct {
    store Port
}

func New(store Port) *Service { return &Service{store: store} }
```

## Adapter skeleton

```go
package <module>store

import (
    "context"

    "example.com/app/service/<module>"
)

type Adapter struct {
    // db, client, etc.
}

// compile-time check that Adapter satisfies the service's Port.
var _ <module>.Port = (*Adapter)(nil)

func (a *Adapter) Get(ctx context.Context, id string) (<module>.Record, error) {
    // ...
}
```

## Review checklist

- [ ] Dependencies point inward only (transport → service → storage interface).
- [ ] Compile-time interface assertion (`var _ Port = ...`) is present.
- [ ] Errors are wrapped with context, not swallowed.
- [ ] Inputs are validated at the transport boundary.
- [ ] Tests cover the happy path and at least one failure path.
