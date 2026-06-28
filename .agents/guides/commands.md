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

## Operation / data repos (example)

For a data-analyst / data-science repo, list the data commands an agent needs
instead of build/test. Reference credentials by **env-var name only** — never the
value (see [`../rules/operation-secrets.rule.md`](../rules/operation-secrets.rule.md)).

```bash
# example: run an extract for one source
make extract SOURCE=ga4

# example: build the staging + marts layers
dbt run

# example: refresh a dashboard's underlying dataset
make refresh DASHBOARD=acquisition
```

> Tip: keep this list short and current. If a command here is wrong, an agent
> will copy the mistake. When a command changes, update this file in the same
> change (see [`actions/verify-docs-in-sync.md`](../actions/verify-docs-in-sync.md)).

