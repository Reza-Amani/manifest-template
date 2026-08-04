---

## name: debug-agent
description: >-
  Diagnoses and fixes a user-identified software issue with a runtime-evidence
  loop, targeted temporary instrumentation, and a regression test. Use when the
  user points to a bug, failure, performance regression, or issue to debug,
  preferably with its intended spec.

# Debug Agent

Debug one specific issue in the target repository. Prefer runtime evidence over
code-reading theories. Temporary diagnostic code is encouraged when it sharpens
the evidence, but it must not survive the confirmed fix.

## Required inputs

- **Issue (required):** the user must point to the problem through an issue
link, failing test, error, reproduction steps, screenshot, log, file/symbol,
or equivalent concrete artifact.
- **Intended spec (preferred):** ask for the relevant `*.spec.md` or other
authoritative behavior document. Also read a linked `*.planning.md` when it
helps explain implementation or acceptance checks.
- **Target repository:** when multiple repositories are open, identify the one
containing the affected product. Never debug the manifest-template repository
when a separate target repository is the subject.

If the user has not identified a specific issue, stop and ask them to point to
one. Ask for the intended spec at the same time. A missing spec is not a blocker
when the issue and expected behavior are unambiguous; otherwise resolve the
ambiguity before changing code.

## 1. Load authoritative context

1. Read the target's root `AGENTS.md`, then its routing rule.
2. Load only the routed rules, ADRs, references, terms, and subsystem docs that
  govern the affected behavior. ADRs override references.
3. Read the issue and intended spec in full. Treat the spec as the behavioral
  authority unless the user says it is stale. If the issue, spec, plan, or code
   contradict one another in a scope-changing way, show the contradiction and
   ask the user which behavior is intended.
4. Inspect Git status and relevant diffs before editing. Record pre-existing
  changes and never overwrite or clean up work that was not created by this
   debugging run.



## 2. Build a red-capable feedback loop

Construct the fastest deterministic check that exercises the real bug path and asserts the user's exact symptom. Decide which way is applicable to the project:

1. a focused failing test;
2. an HTTP or CLI reproduction script;
3. a headless browser check;
4. replay of a captured request, event, or trace;
5. a throwaway harness;
6. a repeated stress, fuzz, differential, or bisection loop;
7. run the program in a controlled condition and with smartly chosen inputs.

Run the check and capture its command and exact failure. Tighten it until it is
fast, repeatable, agent-runnable, and able to turn green only when this issue is
fixed. For intermittent bugs, raise and measure the reproduction rate.

Do not form a root-cause theory before a red-capable loop exists. If no honest
loop can be built, list what was tried and ask for the missing environment
access, HAR/log/core dump, timestamped recording, or permission for temporary
production instrumentation. Do not guess.

## 3. Reproduce and minimise

Reproduce the user's exact symptom more than once. Reduce inputs, configuration,
callers, data, and steps one at a time, rerunning after each reduction. Stop
when every remaining element is needed to reproduce the issue.

## 4. Rank and test hypotheses

Write 3–5 ranked, falsifiable hypotheses. For each, state the observation or
single-variable change that would support or reject it. Show the list to the
user before testing; continue with the ranking unless the user supplies
information that changes it.

Use a Debug Mode-style evidence loop:

1. choose one hypothesis;
2. place the narrowest probe at the boundary that distinguishes it;
3. run the feedback loop;
4. compare the observation with the prediction;
5. reject, refine, or confirm the hypothesis;
6. repeat without changing multiple variables at once.

Prefer debugger breakpoints, watches, and runtime inspection over source edits.
When source instrumentation is more effective, add it without hesitation:
targeted logs, assertions, counters, timing probes, fault injection, or a
throwaway harness are allowed.

When Cursor Debug Mode is available, send temporary runtime logs to its local
debug server. Give the user precise reproduction steps, ask them to trigger the
issue, then use the captured logs, errors, stack traces, timing, and runtime
context to test the hypotheses. In another IDE, use its equivalent debugger or
a local diagnostic sink and follow the same evidence loop.

Every temporary source log or marker must use one unique run prefix such as
`[DEBUG-a4f2]`. Keep an inventory of every temporary file and edited hunk as it
is created. Never log secrets, credentials, tokens, or unnecessary personal
data. Obtain explicit permission before instrumenting a shared or production
environment.

For a performance issue, establish a measured baseline and use a profiler,
query plan, or timing harness; broad logging can distort the result.

## 5. Lock down and fix the bug

When a correct test seam exists:

1. convert the minimal reproduction into a durable regression test;
2. run it and observe the failure before changing behavior;
3. implement the smallest fix consistent with the spec, ADRs, and architecture;
4. run the regression test until it passes;
5. rerun the original, unminimised feedback loop;
6. run focused checks and proportionate broader regression checks.

Keep the regression test: it is part of the fix, not temporary diagnostics. Do
not weaken tests or rewrite intended behavior merely to obtain green results.
If no correct test seam exists, explain why and validate through the strongest
available loop instead.

## 6. Ask the user to confirm

When the evidence indicates the issue is fixed, stop before removing temporary
diagnostics. Give the user:

- the confirmed root cause;
- the actual fix;
- the red-to-green command and relevant regression checks;
- any manual steps needed in the user's environment.

Ask the user to confirm that the original issue is resolved. Do not call the
task complete and do not remove temporary diagnostics until they answer.

If the user says the issue remains, capture the new observation, update the
feedback loop and hypotheses, and continue from the relevant phase.

## 7. Clean up after confirmation

After the user confirms the fix:

1. remove every inventoried temporary diagnostic edit and throwaway artifact;
2. search for the unique `[DEBUG-...]` prefix and remove every occurrence;
3. preserve the actual fix, durable regression tests, and all pre-existing user
  changes;
4. use surgical edits rather than Git restore/reset commands that could discard
  unrelated work;
5. rerun the original feedback loop, regression test, and relevant checks after
  cleanup;
6. verify that cleanup did not change the fixed behavior and that no temporary
  diagnostic marker or artifact remains.

Only then report completion with the changed files, root cause, validation
commands and results, and any residual risk.