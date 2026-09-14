# Manual setup before `apply-manifest-template`

Use this for a repository with no valid manifest. If the repo still has a
legacy `.agents/` content tree, use
[`migrate-manifest-layout/user-setup.md`](../migrate-manifest-layout/user-setup.md)
instead.

The skill writes manifest documents but does not create tree roots or symbolic
links.

## 1. Choose the repo type

Choose `solo` when one person owns the repository. Choose `team` when several
people share it and each person needs a private local manifest.

The full definitions and canonical folder layouts are in
[`manifest-layout.md`](../../../.team_manifest/guides/manifest-layout.md).
Tell the skill which type you chose; a new repository does not yet contain
enough information to detect it.

## 2. Create the layout

From the canonical guide:

1. Create the folders shown for the chosen type.
2. For `team`, create the local tree in a private manifest repository and link
   it at `.local_manifest`.
3. Create the `.agents/skills` discovery links.
4. Merge the matching ignore rules.
5. Run the guide's verification checklist.

Do not create documents inside the roots yet. Empty `AGENTS.md` and routing
stubs are allowed when a tool needs the paths to exist; the skill will fill
them.

## 3. Invoke the skill

Open this template and the target repository in one workspace, then invoke
`apply-manifest-template`. State the target path and chosen repo type.
