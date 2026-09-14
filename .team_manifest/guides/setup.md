# Project Setup

Replace this template text with the target project's real setup instructions:
required tools, dependency installation, environment configuration, database
setup, and any other prerequisites.

Keep commands concrete and safe to copy. Name secrets only by environment
variable; never put secret values in this file.

## Manifest tooling

The canonical solo/team layouts, discovery-shim commands, and ignore rules live
in [`manifest-layout.md`](manifest-layout.md). After a clone, recreate the
machine-local shim and confirm the skill links resolve.

## Optional: bundle the manifest for an external reviewer

Some teams concatenate every manifest file into a single shareable document
for an external advisor or model. If you do this, generate it from
`.team_manifest/` and `.local_manifest/` with a script and treat the generated
file as read-only output — never edit it by hand, and never treat it as a
source of truth.
