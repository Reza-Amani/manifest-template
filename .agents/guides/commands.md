# Useful Commands

A quick reference of the project's most-used commands. Replace these examples
with your real build, test, run, and maintenance commands so an agent can act
without guessing.
Also, the project may have its own CLI commands provided by the codebase; they are listed and kept up-to-date here, as well. 

## Build

```bash
# example
make build
```

## Test

```bash
# example: run the full suite
make test

# example: run one package/folder
make test PKG=./service/usersync
```

## Run locally

```bash
# example
make run
```

## Lint / format

```bash
# example
make lint
make fmt
```

## Common maintenance

```bash
# example: apply database migrations
make migrate

# example: regenerate any generated code or docs
make generate
```

> Tip: keep this list short and current. If a command here is wrong, an agent
> will copy the mistake. When a command changes, update this file in the same
> change (see [`actions/verify-docs-in-sync.md`](../actions/verify-docs-in-sync.md)).
