# Project Setup

Replace this template text with the target project's real setup instructions:
required tools, dependency installation, environment configuration, database
setup, and any other prerequisites.

Keep commands concrete and safe to copy. Name secrets only by environment
variable; never put secret values in this file.

## Manifest tooling

The canonical solo/team layouts, discovery-shim commands, and ignore rules live
in [`manifest-layout.md`](manifest-layout.md). `.agents/skills/` is gitignored,
so it is empty after a clone. Rebuild it from the repo root, and again whenever
a skill is added, renamed, or removed:

```powershell
.\.team_manifest\scripts\sync-skill-links.ps1
```

```bash
bash .team_manifest/scripts/sync-skill-links.sh
```

Then restart the editor and type `/` in chat to confirm the skills appear.

## Optional: bundle the manifest for an external reviewer

Some teams concatenate every manifest file into a single shareable document
for an external advisor or model. If you do this, generate it from
`.team_manifest/` and `.local_manifest/` with a script and treat the generated
file as read-only output — never edit it by hand, and never treat it as a
source of truth.
