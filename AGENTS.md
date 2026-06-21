# AGENTS.md

Entry point for all AI agents and contributors working in this repository
(GitHub Copilot, Cursor, Claude, openCode, and future tools).

**Before acting, read [`.agents/rules/routing.rule.md`](.agents/rules/routing.rule.md)**
and follow its routing table to find the specific decision record, reference,
guide, skill, or persona for your task. Read only what the current task needs.
Do not bulk-read every file under `.agents/` at once.

## Project-wide mandates

> Replace this list with the non-negotiable rules of *your* project. These are
> the few constraints an agent must never violate. Keep the list short — long
> lists get ignored. Examples below; delete and rewrite for your repo.

- **Read the decisions first.** The files in [`.agents/adr/`](.agents/adr/) are the
  durable laws of this codebase and override generic conventions.
- **Keep docs in sync.** If your change makes a reference or guide wrong, fix it
  in the same change. See [`.agents/rules/manifest-structure.rule.md`](.agents/rules/manifest-structure.rule.md).
- **Check the backlog before proposing work.** The canonical task list lives in
  [`.agents/plans/backlog.plan.md`](.agents/plans/backlog.plan.md).
- _(Add your own: coding style, security boundaries, forbidden patterns, etc.)_

## What is `.agents/`?

`.agents/` is the source tree for agent-facing project context: decisions,
mechanics, conventions, runbooks, and role definitions. It is tool-agnostic.
Tool-specific folders such as `.github/` or `.cursor/` may mirror or link to it,
but the canonical content lives here. See the
[root README](README.md) for the full tour.
