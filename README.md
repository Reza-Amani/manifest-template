# Agent Manifest Template

A reusable, tool-agnostic template for an **agent manifest** — a structured
`.agents/` directory that gives AI coding agents (GitHub Copilot, Cursor,
Claude, openCode, and others) the durable context they need to work in a
repository: decisions, mechanics, conventions, runbooks, and role definitions.

Copy this template into any repository, fill it with your project's specifics,
and your agents stop guessing intent — they read it.

It fits **two kinds of repository** with the same structure:

- **Software / development repos** — code, services, libraries.
- **Operation / data repos** — scripts and instructions for data sources (Google
  Analytics 4, Salesforce), dashboards, and data collection (data-analyst /
  data-science work).

Every folder ships a coding example and, where it helps, an `operation-`
prefixed example beside it so both audiences see the expected shape.

## Why a manifest?

AI agents are powerful but stateless. Without shared context they re-derive
architecture from scratch, miss hard constraints, and re-litigate settled
decisions. A manifest fixes this by giving agents a **single, organized source
of truth** that is:

- **Discoverable** — a routing rule maps any task to the exact doc that covers it.
- **Layered** — durable *decisions* are kept apart from current *mechanics* and
  step-by-step *how-tos*, so each can change at its own pace.
- **Tool-agnostic** — the canonical content lives in `.agents/`; tool-specific
  folders (`.github/`, `.cursor/`) just mirror it.
- **Low-noise** — agents read only what a task needs, not the whole manifest.

## How it works

1. Every agent starts at the root **[`AGENTS.md`](AGENTS.md)**.
2. `AGENTS.md` sends them to **[`.agents/rules/routing.rule.md`](.agents/rules/routing.rule.md)**.
3. The routing rule maps the task to the one decision record, reference, guide,
   skill, persona, plan, or action that applies.
4. The agent reads only that file and acts.

## Directory layout

```
your-repo/
├─ AGENTS.md                      # entry point; mandates + pointer to routing
└─ .agents/
   ├─ rules/                      # project-wide rules (REQUIRED: structure rule)
   │  ├─ manifest-structure.rule.md   # explains the whole structure (required)
   │  ├─ routing.rule.md              # task → document discovery map
   │  └─ terms.rule.md                # canonical vocabulary
   ├─ adr/                        # Architecture Decision Records (the "why")
   ├─ reference/                  # how subsystems actually work (the "how")
   ├─ guides/                     # operator how-to (setup, commands, notes)
   ├─ skills/                     # multi-step runbooks (<name>/SKILL.md)
   ├─ actions/                    # one-step checks/procedures
   ├─ personas/                   # role-focused agent definitions
    ├─ plans/                      # simple plans/specs, epic folders, backlog
   ├─ findings/                   # reproducible analysis/investigation records
   └─ learning/                   # teach skill session records
```

## What goes where

| Folder        | Holds                                   | Naming               |
| ------------- | --------------------------------------- | -------------------- |
| `adr/`        | Durable decisions and *why* they exist  | `*.adr.md`           |
| `reference/`  | Current mechanics, wiring, inventories  | `*.ref.md`           |
| `rules/`      | Project-wide rules, routing, terms      | `<category>.rule.md` |
| `personas/`   | Role-specific agent behavior            | `<role>.agent.md`    |
| `skills/`     | Multi-step procedures + assets          | `<name>/SKILL.md`    |
| `guides/`     | Tutorials and operator how-to           | descriptive `*.md`   |
| `plans/`      | Simple plans/specs, epic folders, backlog | `*.plan.md`, `*.spec.md`, epic files |
| `findings/`   | Reproducible analysis/investigation records | `YYYY-MM-DD-topic.md` |
| `learning/`   | Teach skill session records             | `YYYY-MM-DD-topic.md` |
| `actions/`    | One-step checks and procedures          | descriptive `*.md`   |

The full, authoritative placement rules live in
**[`.agents/rules/manifest-structure.rule.md`](.agents/rules/manifest-structure.rule.md)** —
this is the one required file; it explains the entire structure.

**Decisions vs. mechanics** is the key distinction: an ADR says *we chose X
because Y* and rarely changes; a reference says *here is how X is wired today*
and changes whenever the code does.

## Planning flow

For small work, `grill-to-spec` turns plain user intent into a human-readable
behavior spec. `spec-to-plan` creates a Cursor-style implementation plan without
acceptance criteria. `plan-to-criteria` studies the test setup, writes focused
tests where possible, and adds acceptance criteria to the plan. `implement-plan`
then builds and validates until every criterion passes.

An epic adds one stage at the front: `grill-to-master` preserves the human
initial idea and creates a high-level phased roadmap. Each phase then follows
the same spec, plan, criteria, and implementation flow in the epic's dedicated
directory. See the canonical [planning flow reference](.agents/reference/planning-flow.ref.md),
the [plan structure rule](.agents/rules/manifest-structure.rule.md#plans), and
the [template-only epic example](.agents/plans/example-epic/). Do not copy the
example directory into target repositories.

## Getting started

### Option A — Automated (recommended)

Let an agent do the work:

1. Open **your repo** in a VS Code workspace.
2. **Add this template repo** as a second folder in the same workspace.
3. Ask the agent to run the right apply skill for your repo type:
   - Software / development repo →
     [`apply-manifest-template`](.agents/skills/apply-manifest-template/SKILL.md)
   - Operation / data repo →
     [`operation-apply-manifest-template`](.agents/skills/operation-apply-manifest-template/SKILL.md)

   It studies your repo, then creates a tailored `.agents/` manifest (or upgrades
   an existing one) with real, project-specific content — replacing all the
   examples for you. To pull later template updates into an existing manifest,
   use the matching `sync-manifest-template` /
   `operation-sync-manifest-template` skill.

### Option B — Manual

1. **Copy** the root `AGENTS.md` and the `.agents/` directory into your repo.
2. **Edit `AGENTS.md`** — replace the example mandates with your project's real,
   non-negotiable rules (keep the list short).
3. **Edit `routing.rule.md`** — point the tables at your real documents.
4. **Replace the examples** — every folder ships with a worked example marked as
   such. Turn them into real docs or delete them once you have your own.
5. **Wire your tools** — follow
   [`.agents/guides/setup.md`](.agents/guides/setup.md) to mirror `.agents/` into
   `.github/` / `.cursor/` if your tools need it.
6. **Keep it in sync** — when a change makes a doc wrong, fix it in the same
   change. The [`verify-docs-in-sync`](.agents/actions/verify-docs-in-sync.md)
   action and the [`manifester`](.agents/personas/manifester.agent.md) persona
   help with this.

## What's included

This template ships at least one worked example in every folder so you can see
the format and the expected level of detail. Where it helps, a coding example and
an `operation-` prefixed example sit side by side:

- **rules/** — all three rule files (`manifest-structure`, `routing`, `terms`),
  plus an operation/data example rule (`operation-secrets`).
- **adr/** — the meta-ADR (*record architecture decisions*), a coding decision
  example, and an operation/data decision. example (`operation-data-layering`).
- **reference/** — a coding subsystem example and an operation/data connection
  inventory example (`operation-connections`), plus the canonical planning-flow
  reference.
- **guides/** — `setup.md`, `commands.md`, and `notes.md`.
- **skills/** — real `apply-manifest-template` / `sync-manifest-template`
  runbooks for code repos and `operation-apply-manifest-template` /
  `operation-sync-manifest-template` for data/ops repos, plus
  [`grill-to-master`](.agents/skills/grill-to-master/SKILL.md),
  [`grill-to-spec`](.agents/skills/grill-to-spec/SKILL.md),
  [`spec-to-plan`](.agents/skills/spec-to-plan/SKILL.md),
  [`plan-to-criteria`](.agents/skills/plan-to-criteria/SKILL.md), and
  [`implement-plan`](.agents/skills/implement-plan/SKILL.md) for the planning
  lifecycle, plus an `example-add-module` (coding) example and an
  `operation-add-data-source` (data) example.
- **actions/** — a `verify-docs-in-sync` one-step check.
- **personas/** — a `reviewer` and a `manifester` agent.
- **plans/** — a canonical `backlog.plan.md`, a simple example feature plan,
  and a template-only `example-epic/` directory that must not be copied into
  target repositories.
- **findings/** — a README for recording reproducible analyses/investigations,
  plus an example finding.
- **learning/** — a README for recording and resuming `teach` skill sessions,
  plus an example placeholder directory.

## Principles for keeping it useful

- **One fact, one place.** Define a thing once and link to it; never copy.
- **Read narrowly.** Routing exists so agents open one file, not all of them.
- **ADRs win.** When a reference and an ADR disagree, the ADR is right and the
  reference must be fixed.
- **Plain language.** Write so a new contributor understands every line on the
  first read.

## Third-party skills (Matt Pocock)

Parts of this template pair with or adapt skills from
[Matt Pocock's *Skills For Real Engineers*](https://github.com/mattpocock/skills)
([skills.sh](https://www.skills.sh/mattpocock/skills)). Install them with the
`skills` CLI:

```sh
npx skills add mattpocock/skills
```

| This template | Matt Pocock skill | Notes |
| ------------- | ----------------- | ----- |
| [`learning/`](.agents/learning/README.md) | [`teach`](https://www.skills.sh/mattpocock/skills/teach) | Session records in `learning/` pair with the `teach` skill. |
| [`grill-to-spec`](.agents/skills/grill-to-spec/SKILL.md) | [`grilling`](https://www.skills.sh/mattpocock/skills/grilling), [`domain-modeling`](https://www.skills.sh/mattpocock/skills/domain-modeling) | Adapted for manifest repos: grilling loop + domain sharpening, ending in a spec in the target repo's `.agents/plans/` tree. |
| [`grill-to-master`](.agents/skills/grill-to-master/SKILL.md) | [`grilling`](https://www.skills.sh/mattpocock/skills/grilling) | Adapted for epic-level grilling and phased master plans. |

For the original grilling workflow without manifest/spec output, use Matt's
[`grill-me`](https://www.skills.sh/mattpocock/skills/grill-me) or
[`grill-with-docs`](https://www.skills.sh/mattpocock/skills/grill-with-docs)
skills directly.

License terms for adapted material are in
[`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md).

## License

This project is licensed under the MIT License — see [`LICENSE`](LICENSE).
Third-party material may be under separate terms; see
[`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md).
