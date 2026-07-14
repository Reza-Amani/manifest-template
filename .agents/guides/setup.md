# Setup Guide — Wiring the Manifest into Your Tools

This guide explains how to set up the project:
- how to drop the `.agents/` manifest into a repository and
make it visible to AI coding tools. Adjust paths and commands for your OS and
toolchain.
- how to install the required tools and dependencies to run the project.
-  any other setup steps specific to your project (e.g., environment variables, API keys, database setup, etc.).

# Custom setup instructions

## 1. install the build tools

## 2. install project dependencies

# set up the manifest

# set up the manifest

The manifest fits two repo types: **software / development** and **operation /
data** (data sources, dashboards, data collection). The structure is identical;
only the content differs. If you are letting an agent scaffold it, use the apply
skill that matches your repo type:

- Software / development → [`apply-manifest-template`](../skills/apply-manifest-template/SKILL.md)
- Operation / data → [`operation-apply-manifest-template`](../skills/operation-apply-manifest-template/SKILL.md)

## 1. Copy the template into your repo

Copy the `.agents/` directory and the root `AGENTS.md` from this template into
the root of your repository. Then:

1. Edit `AGENTS.md` to state your project's real mandates.
2. Edit [`.agents/rules/routing.rule.md`](../rules/routing.rule.md) to point at
   your real docs.
3. Replace the example ADR, reference, skill, plan, action, and finding with
   real ones (or delete the examples once you have your own). Operation/data
   repos start from the `operation-` prefixed examples; coding repos start from
   the coding examples.

## 2. Make tools discover the manifest

Most agent tools look for a root `AGENTS.md` automatically. Some tools expect
their own folders. `.agents/` is the **canonical source**; mirror it into
tool-specific folders rather than maintaining separate copies.

### Option A — Symbolic links (recommended)

On Windows (PowerShell, run as Administrator):

```powershell
New-Item -ItemType SymbolicLink -Path .\.github\skills   -Target .agents\skills
New-Item -ItemType SymbolicLink -Path .\.github\agents   -Target .agents\personas
New-Item -ItemType SymbolicLink -Path .\.cursor\skills   -Target .agents\skills
```

On macOS/Linux:

```bash
ln -s ../.agents/skills   .github/skills
ln -s ../.agents/personas .github/agents
ln -s ../.agents/skills   .cursor/skills
```

### Option B — Generated mirror

If your platform does not support symlinks in version control, add a small
script (or CI step) that copies `.agents/` subfolders into the tool-specific
folders on build. Never hand-edit the mirrored copies.

## 3. Keep mirrors out of git

Local mirror folders should **not** be committed. Add to the repo root
`.gitignore` (merge with existing entries):

```gitignore
# Local IDE / tool mirrors (canonical source: .agents/). Recreate with this guide.
.cursor/
.github/skills
.github/agents
```

- **`.cursor/`** — IDE wiring, symlinks, and user-specific state. Each developer
  recreates this locally.
- **`.github/skills`** and **`.github/agents`** — only when you use symlink
  mirrors as above. Do not gitignore all of `.github/` if you commit workflows
  under `.github/workflows/`.

The canonical manifest lives in `.agents/`. The goal: one source of truth, no
divergent copies in version control.

## 4. Verify

- Open your AI tool and confirm it can see `AGENTS.md` and the personas/skills.
- Ask the agent to "read the routing rule and tell me which doc covers X" to
  confirm discovery works.

## Optional: bundle the manifest for an external reviewer

Some teams concatenate every `.agents/` file into a single shareable document
for an external advisor or model. If you do this, generate it with a script and
treat the generated file as read-only output — never edit it by hand, and never
treat it as a source of truth.
