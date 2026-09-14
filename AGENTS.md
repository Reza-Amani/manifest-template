# AGENTS.md

Entry point for all AI agents and contributors working in this repository
(GitHub Copilot, Cursor, OpenCode, and future tools).

The manifest lives in two directories plus a discovery shim. Both directories
are tracked.

- `.team_manifest/` — decisions (`adr/`), rules, guides, personas, actions,
  and `backlog.plan.md`.
- `.local_manifest/` — plans, findings, learning, scratch, reference docs,
  skills, and `AGENTS.md`.
- `.agents/` — gitignored shim holding a `skills/local` symlink so tools
  auto-discover skills. Nothing else lives there.

**Before acting, read
[`.team_manifest/rules/routing.rule.md`](.team_manifest/rules/routing.rule.md)
and
[`.local_manifest/AGENTS.md`](.local_manifest/AGENTS.md)
and follow their routing.** Read only what the current task needs; do not
bulk-read either directory.

## Generic rules

- **Read the decisions first.** `.team_manifest/adr/` holds the durable laws
  of this codebase and overrides generic conventions.
- **Keep docs in sync.** If your change makes a reference or guide wrong, fix
  it in the same change. See
  [`.team_manifest/rules/manifest-structure.rule.md`](.team_manifest/rules/manifest-structure.rule.md).
- **Check the backlog before proposing work.** Future tasks live in
  [`.team_manifest/backlog.plan.md`](.team_manifest/backlog.plan.md).
