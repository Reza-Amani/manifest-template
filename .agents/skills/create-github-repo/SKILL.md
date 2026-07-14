---
name: create-github-repo
description: >-
  Creates a new GitHub repository under the user's account with gh CLI: checks
  installation and auth, gathers repo details, writes README and MIT license,
  commits, and pushes. Optionally applies the manifest template to the new repo.
  Use when the user asks to create a GitHub repo, bootstrap a new repository,
  or set up a remote repo with initial docs.
---

# Create GitHub Repo

End-to-end workflow to create a new GitHub repository, scaffold initial files,
push the first commit, and optionally install an agent manifest from this
template.

**Persona:** Run as the Manifester
([`../../personas/manifester.agent.md`](../../personas/manifester.agent.md)) —
plain English, smallest useful change, correct placement.

## Prerequisites

- The user must be able to authenticate with GitHub in a browser.
- To apply a manifest afterward, this template repo and the new repo must both
  be open in the same workspace.

## Procedure

Copy this checklist and track progress:

```
Task progress:
- [ ] 1. Check gh CLI is installed
- [ ] 2. Check gh is authenticated
- [ ] 3. Gather repo details from the user
- [ ] 4. Validate paths and repo name
- [ ] 5. Create the GitHub repo and local clone
- [ ] 6. Write README, LICENSE, and .gitignore
- [ ] 7. Initial commit and push
- [ ] 8. Offer to apply manifest template
```

### 1. Check gh CLI is installed

Run:

```bash
gh --version
```

If the command is not found, **stop** and tell the user to install and reopen
their terminal. Do not continue until `gh` works.

**Install (pick one for the user's OS):**

| OS | Command |
|----|---------|
| Windows | `winget install --id GitHub.cli -e --accept-source-agreements --accept-package-agreements` |
| macOS | `brew install gh` |
| Linux (Debian/Ubuntu) | `sudo apt install gh` |

**Windows note:** After install, existing terminals may not see `gh` until the
user opens a new terminal or refreshes PATH:

```powershell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
```

Wait for the user to confirm `gh --version` works before continuing.

### 2. Check gh is authenticated

Run:

```bash
gh auth status
```

If not logged in, **stop** and tell the user to authenticate manually:

```bash
gh auth login
```

Suggested choices: **GitHub.com** → **HTTPS** → **Login with a web browser**.

Wait for the user to confirm `gh auth status` shows a logged-in account before
continuing.

### 3. Gather repo details from the user

Ask for these four items. Use `AskQuestion` when available; otherwise ask in chat.

| Input | Notes |
|-------|-------|
| **Repo name** | Lowercase with hyphens is fine. Becomes the GitHub repo name and local folder name. |
| **Destination directory** | Parent folder where the repo will live. Final path: `<destination>/<repo-name>/`. |
| **Visibility** | `public` or `private`. |
| **Purpose** | One or two sentences on what the repo is for. Used to write the README. |

Do not guess the purpose. Do not create the repo until all four are confirmed.

Optional: ask whether to use **MIT** (default) or another open license. If the
user does not care, use MIT.

### 4. Validate paths and repo name

Resolve the local path: `<destination>/<repo-name>/`.

Before creating anything, check:

- **GitHub:** `gh repo view <owner>/<repo-name>` — if it exists, stop and ask
  for a different name.
- **Local path:** if the folder exists and is non-empty or already a git repo
  with a different remote, stop and ask how to proceed.

Prefer a clean empty folder or a path that does not exist yet.

### 5. Create the GitHub repo and local clone

From the **destination directory** (parent folder), run:

```bash
cd <destination>
gh repo create <repo-name> --<public|private> --clone --description "<short purpose>"
```

This creates the repo on GitHub and clones it to `<destination>/<repo-name>/`.

If `--clone` is not suitable (folder already exists empty), create from source
instead:

```bash
cd <destination>/<repo-name>
gh repo create <repo-name> --<public|private> --source=. --remote=origin --description "<short purpose>"
```

Use `--push` with `--source=.` only after step 6 files exist.

### 6. Write README, LICENSE, and .gitignore

In the new repo root, create:

**README.md** — short and clear. Include:

- Project title (repo name)
- Purpose (from step 3, in the user's words where possible)
- High-level structure if known (components, languages, layout)
- A **License** section linking to `LICENSE`
- A **Status** line if the repo is early / empty code

Keep it under ~40 lines unless the user asked for more.

**LICENSE** — MIT by default. Copyright holder: the GitHub username from
`gh auth status`, or the git `user.name` if clearer. Year: current year.

**`.gitignore`** — add sensible defaults for the stack mentioned in the purpose
(e.g. C build artifacts, Node `node_modules/`, Python `__pycache__/`). If
unknown, use a minimal generic ignore (OS junk + editor files).

Do not add application code unless the user asked for it.

### 7. Initial commit and push

From the repo root:

```bash
git add README.md LICENSE .gitignore
git commit -m "Add README, MIT license, and gitignore."
git branch -M main
git push -u origin main
```

If the branch is already `main` and tracking, skip rename. Report the repo URL
from `gh repo view --web` or the `gh repo create` output.

### 8. Offer to apply manifest template

Ask the user:

> Do you want to apply the manifest template to this new repo?

**If no:** stop with a short summary (repo URL, local path, files created).

**If yes:** both repos must be roots in the **same Cursor/VS Code workspace**
before `apply-manifest-template` can run. Prepare the workspace first (below),
then run that skill.

#### Prepare workspace (required before manifest apply)

Check whether `<destination>/<repo-name>/` is already a workspace root (the agent
can read and write files there alongside the template folder).

**Already in workspace** → continue to step 8b.

**Not in workspace** — try in this order:

1. **Multi-root `.code-workspace` file open:** add the new repo path to the
   `folders` array in that file, save it, and tell the user to reload the
   workspace if Cursor does not pick it up automatically.

   ```json
   { "path": "<absolute-path-to>/<repo-name>" }
   ```

2. **Single-folder workspace (most common):** the agent **cannot** add a folder
   from here. **Stop** and ask the user to do this manually:

   > Add the new repo to this workspace:
   > 1. **File → Add Folder to Workspace…**
   > 2. Select `<destination>/<repo-name>`
   > 3. Confirm when both folders appear in the sidebar

   Wait for the user to confirm before continuing. Do not run
   `apply-manifest-template` until the new repo is visible as a workspace root.

#### 8b. Run apply-manifest-template

1. Confirm the workspace has **both** this template repo and the new repo as
   roots. If still ambiguous, ask which folder is the target.
2. Read and follow [`../apply-manifest-template/SKILL.md`](../apply-manifest-template/SKILL.md)
   in full. The **target repo** is the repo just created; the **source** is this
   template.
3. Run that skill as the Manifester persona.

## Completion checks

- `gh auth status` was valid before repo creation.
- Repo exists on GitHub at `https://github.com/<owner>/<repo-name>`.
- Local clone at `<destination>/<repo-name>/` has `README.md`, `LICENSE`, and
  `.gitignore`.
- Initial commit is on `main` and pushed to `origin`.
- User was offered manifest template application; if yes, workspace was prepared
  (both repos as roots) and apply-manifest-template procedure was followed.

## Decision tree

```
gh installed?
├─ No .............. STOP: give install steps; wait for user
└─ Yes
    gh authenticated?
    ├─ No .......... STOP: gh auth login; wait for user
    └─ Yes
        Have name, destination, visibility, purpose?
        ├─ No ...... ASK user
        └─ Yes
            Create repo → write files → commit → push
            Offer manifest template?
            ├─ No ...... DONE
            └─ Yes
                New repo in workspace?
                ├─ No .. user adds folder (or agent edits .code-workspace)
                └─ Yes .. run apply-manifest-template skill
```
