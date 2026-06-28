# Operation Secrets & Credentials Rule

> **This is an example rule for an operation / data repository, marked as a
> placeholder — overwrite it with your project's real policy.** It exists
> because data repos (GA4, Salesforce, warehouses, dashboards) live and die by
> API keys, OAuth tokens, and service accounts. Coding repos can adopt it too.

This rule defines how credentials and sensitive data are handled in this repo.
It applies to every script, notebook, config file, reference doc, and agent
action.

## Hard rules

1. **Never commit a secret.** No API keys, tokens, passwords, OAuth secrets,
   service-account JSON, or connection strings in tracked files — including
   docs, notebooks, and example data.
2. **Reference, do not embed.** Code and docs name the **environment variable**
   (or secret-store key) that holds a credential, never the value. The
   connection inventory
   [`../reference/operation-connections.ref.md`](../reference/operation-connections.ref.md)
   lists env-var names only.
3. **Secrets live in the secret store**, not the repo: _(name your store here —
   for example a git-ignored `.env` file, your cloud secret manager, or CI
   secrets)_.
4. **Least privilege.** Use read-only, scoped credentials for extraction. Never
   use an admin or owner credential for a routine pull.
5. **Agents must never print, log, or ask for secret values.** If a step needs a
   secret, the agent tells the human to set the env var and continues — it does
   not request the value in chat.

## Data privacy

- Mark any source or dataset that contains **personal data (PII)** in the
  connection inventory, and follow the retention and access limits your
  organization requires.
- Do not copy raw PII into findings, examples, or sample data. Aggregate or
  anonymize first.

## On accidental exposure

- If a secret is committed, treat it as compromised: rotate it immediately and
  remove it from history. Deleting the file in a later commit is **not** enough.

---

_Replace the placeholders above with your real secret store, privacy tiers, and
rotation process._
