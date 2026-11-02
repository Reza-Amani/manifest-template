---
name: manager
description: >-
  Manages one task or one named epic phase through grilling, specification,
  planning, criteria, implementation, independent review, and wrap-up with
  minimal user involvement. Use when the user asks manager to run this delivery
  flow, resume it, or reopen its archived task. Does not execute a whole epic
  or advance to another phase.
---

# Manager

Keep user decisions and orchestration in the main agent. Delegate substantial
stage work to fresh, direct workers. Execute the existing skills in order;
do not copy their procedures into this skill. Follow the canonical
[planning flow](../../reference/planning-flow.ref.md), including its
**Managed completion** policy.

## Scope and authority

- Resolve the target repository and exactly one task or numbered epic phase.
  A master plan is context for selecting a phase, never an instruction to
  implement the entire epic. Ask only if the selection is ambiguous.
- Invoking this delivery flow authorizes stage transitions, delegation,
  plan-local scratch cleanup, and task/selected-phase archival. Do not ask
  for intermediate document approvals or another permission to start coding.
- Keep the agreed behavior and scope authoritative. Escalate new consequential
  behavior decisions, incompatible requirements, or changes to protected
  planning requirements. Routine implementation choices belong to the agents.
- Pending human checks and minor review findings follow Managed completion;
  they do not interrupt or prevent wrap-up. Known failing executable checks
  and severe defects are not human-check deferrals.

## Main agent and workers

Read the [delegator persona](../../../.team_manifest/personas/delegator.agent.md)
for its task-size/model table and briefing discipline. Manager explicitly
activates that delegation policy; workers do not inherit the orchestrator role.
Delegate aggressively: repository exploration, planning drafts, criteria and
test authoring, implementation, verification, review, and wrap-up are worker
tasks. Keep interviewing, consequential judgment, scheduling, and final reporting
in the main agent. Small orchestration edits need no separate worker.

Use the cheaper, faster models in the persona's table when available. Match the
actual runtime and available model IDs; do not invent model availability. Prefer
the small tier for bounded searches, narrow fixes, and wrap-up; use the mid-size
tier for substantial plans, tests, implementation, and independent review.
Escalate only when complexity or observed shortcomings justify it. Announce
requested model and task size briefly; disclose an override or unavailable
selection. If the runtime is unclear, choose from its exposed models rather
than interrupting the user to identify an IDE.

Spawn stage workers without the full parent transcript when supported (for
example, `fork_turns: "none"`). Supply useful decisions and constraints explicitly.
Prefer sibling helpers spawned by the main agent. A stage worker may spawn its
own bounded helpers when the harness supports nested agents and that keeps
independent work focused. Give those helpers the same scope and constraints,
avoid concurrent edits to the same files, and account for the whole agent tree's
concurrency limit. The stage worker returns their combined result and any
questions to the main agent. The main agent still owns cross-stage decisions
and dispatches fixes for severe review findings. Dependent stages remain
sequential. If delegation is unavailable, disclose the fallback and run stages
in the main agent without claiming a fresh independent review.

## Explicit handoffs

Every spawn brief must contain:

- Absolute target repo and skill paths; the exact task or phase ID.
- Explicit input and output paths, including the previous stage's actual
  output. Require reading those files, not guessing their contents from a summary.
- Relevant manifest routing, constraints, user decisions, approved assumptions,
  and the Managed completion policy when applicable.
- Allowed edit scope, protected files, and whether bounded nested helpers are
  appropriate for this stage and supported by the harness.
- A compact return contract: status (`done`, `needs-helper`, or `blocked`),
  actual artifact paths, changed files, checks/evidence, and unresolved decisions.

Wait for a stage and verify its artifact exists and matches the task before
starting its dependent stage. Spot-check consequential claims. Pass returned
paths explicitly into the next brief. Read summaries and relevant excerpts in
the main thread; leave exploration logs with the worker or in scratch.

## Run state

After the spec path is known, keep a sibling `<stem>.manager.md` as a durable
checkpoint. Record target, task/phase, artifact paths, current stage, user
decisions, delegation assignments, initial working-tree baseline, changed-file
scope, verification evidence, review findings, pending human checks, and archive
moves. Link requirements instead of duplicating spec, plan, or criteria text.
Update the checkpoint after each stage and before any interruption. Evidence
must identify the code/diff state checked so later edits invalidate affected proof.

Record pre-existing changes before workers edit; review this run's complete
delta, including new/untracked files, without attributing unrelated user work
to the run. Preserve durable evidence in the checkpoint or criteria before
scratch cleanup. Resume by reading the checkpoint and inspecting actual files
and repository state; file existence alone does not establish stage completion.
Revalidate evidence affected by subsequent changes. Do not replay completed
stages or recreate intentional red failures after implementation has begun.

## Stage sequence

1. **Grill and specify — main agent.** Use
   [grill-to-spec](../grill-to-spec/SKILL.md). Ask consequential questions one
   at a time and reuse prior answers. Delegate fact-finding with compact replies;
   retain the conversation and behavioral decisions in the main thread. Write
   the spec once understanding is reached. A ready existing spec can enter at
   planning after a focused gap check; do not repeat resolved grilling.
2. **Plan — fresh worker.** Run
   [spec-to-plan](../spec-to-plan/SKILL.md) with the explicit spec path, target,
   and expected sibling plan path. Have it return planning gaps to the main
   agent. Use sufficient detail for the selected implementation model.
3. **Criteria — fresh worker.** Run
   [plan-to-criteria](../plan-to-criteria/SKILL.md) with both the spec and returned
   plan paths. Pass the expected sibling criteria path. Include human checks
   with inputs and expected outcomes. Preserve the skill's red-test and
   production-integrity rules. Run this stage by default; if the user explicitly
   skips it, record that and use the spec and plan for subsequent verification.
4. **Implement — fresh worker.** Run
   [implement-plan](../implement-plan/SKILL.md) with explicit spec, plan,
   criteria (or recorded absence), checkpoint, and selected master-phase paths.
   Reading the spec is required in this flow. Execute all required checks the
   environment allows, including applicable UI/manual and narrative checks.
   Under manager, return implementation and evidence without final task/master
   completion statuses or scratch cleanup; those wait for independent review.
5. **Review — fresh worker independent of implementation.** Give a new worker
   the spec, criteria (or recorded absence), plan, relevant manifest constraints,
   run diff/baseline, changed files, and evidence locations. Do not supply the
   implementer's conclusions as the review verdict. Use the review contract
   below. The reviewer edits no production or planning requirements. It may use
   bounded read-only helpers when supported, then returns its own consolidated
   findings and evidence to the main agent.
6. **Repair severe findings — main agent dispatches.** Assess the evidence,
   then spawn a separate fix worker for confirmed severe findings. Pass exact
   locations, triggering scenarios, unchanged spec/criteria, and required checks.
   Fix workers must not weaken tests or acceptance requirements. Rerun affected
   checks, then obtain a fresh independent review of the resulting state. Do not
   spawn fix workers for minor findings. After two attempts on the same severe
   issue without meaningful progress, report the blocker and seek the missing
   decision or evidence; do not loop or archive unresolved severe defects.
7. **Close and wrap up — worker.** Once Managed completion is satisfied, record
   final review evidence and every pending human check/minor finding. Complete
   the selected plan todos and, for a phase, only its matching master status and
   checkbox. Remove this plan's scratch artifacts after preserving evidence;
   verify the resolved deletion target stays within the target repo's scratch
   directory. Run [wrap-up-plan](../wrap-up-plan/SKILL.md), passing exact plan,
   spec, criteria, checkpoint, and optional master-phase paths. Force **Task**
   or **Epic phase** mode; keep the master and initial idea active even when this
   happens to be the last phase. Archive the checkpoint with its companions,
   repair links, and stop. Never start another phase.

## Independent review contract

Inspect the generated code and tests against the original spec and criteria,
not only against the implementation plan. Check each in-scope behavioral and
design requirement, significant regressions, and evidence that tests actually
prove the intended outcomes. Run focused missing checks when possible; reuse
valid evidence for unchanged code rather than blindly rerunning everything.

Return a compact requirement-to-evidence assessment plus actionable findings
with severity, precise file/line, trigger, consequence, and supporting evidence:

- **Severe:** a demonstrated bug or design flaw with substantial impact, such
  as data loss, an exploitable security failure, a broken core workflow, or a
  material violation of the agreed behavior/architecture. These require repair.
- **Minor:** a bounded low-impact defect or flaw without severe consequences.
  Record and report it; do not implement its fix or turn it into a repair gate.
- **Human check pending:** a specific check that needs unavailable human access,
  hardware, environment, or judgment. Record why it could not run and exact
  steps/expected results. Never report it as passed.

Severity follows demonstrated impact, not stylistic preference. Do not suppress
an unmet requirement, relabel an executable test failure as minor to close it,
or invent findings. Missing runnable evidence is a verification task; an
unavailable non-human prerequisite is a blocker to resolve or report, not a
fabricated human-check exemption.

## Report and reopen

Report completion and archived paths briefly, followed by pending human checks
and minor findings. State the successful verification scope and any independent
review limitation without dumping routine logs. Link the archived checkpoint
for exact evidence and human instructions.

When the user reports a failed human check and asks to reopen, locate the
archived checkpoint and restore exactly its task/phase companions to their
original active paths without overwriting existing files. Reset affected plan
todos and only the matching master phase to incomplete; preserve prior evidence
as history and record the failed check. Keep unaffected phases and archives
unchanged. Resume implementation, verification, independent review, and wrap-up
for the reported failure under the existing spec/criteria. Ask only when the
failure requires a new behavior decision or the restore targets conflict.
