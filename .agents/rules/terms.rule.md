# Project Terms

Project-wide terminology rules and conversational agreements. These definitions
apply across code, schemas, CLI flags, configuration, documentation, and agent
output. Use one name for one concept everywhere.

> **How to use this file:** Add a short entry for any term that has caused
> confusion or that must be used consistently. Keep each definition to a line or
> two. Replace the example entries below with your project's vocabulary.

## Example: canonical name for a concept

- **User** vs **Account:** A *User* is a human identity (one person). An
  *Account* is a billing entity that may contain many Users. Never use the two
  words interchangeably in code, UI, or docs.

## Example: a unit convention

- **Amount** is always stored in the **smallest currency unit** (e.g. cents),
  as an integer. Never store money as a floating-point major unit. When showing
  it to a person, format at the display layer only.

## Example: a verb the project uses in a specific way

- **Sync** means "reconcile local state with the remote source of truth and
  resolve conflicts." It does **not** mean a one-way copy; use **export** or
  **import** for one-way transfers.

---

_Add real terms below. Prefer fewer, high-value entries over an exhaustive
glossary._
