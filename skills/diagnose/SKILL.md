---
name: diagnose
description: Find and fix a bug by building a tight feedback loop first. Use when the user reports something broken.
---

# Diagnose

A discipline for hard bugs. Run all six phases. Get explicit approval to drop one.

## Phase 1 — Build a feedback loop

This is the skill. If you have a tight pass/fail signal that goes red on _this_ bug, you will find the cause. Spend disproportionate effort here.

**Ways to construct one** (try in order):

1. Failing test at the interface that hits the bug.
2. Script against a running thing (curl, CLI fixture, headless browser, replayed trace).
3. Throwaway harness — a minimal subset that exercises the bug.
4. Property or fuzz loop — 1000 random inputs.
5. Bisection harness for `git bisect run`.
6. Differential loop — same input through old vs new.
7. HITL bash script — last resort, if a human must click.

Tighten the loop once you have one: faster, sharper signal, more deterministic. A 2-second deterministic loop is a debugging superpower.

When a loop is out of reach, surface the gap — ask for env access, a redacted artifact, or permission to add temporary instrumentation. Hypothesise from a working loop.

**Done when** you can name **one command you have already run** that:

- goes **red** on *this* bug — it asserts the user's exact symptom, not just "runs without erroring",
- gives the **same result every run** (for a flaky bug, a reliably high reproduction rate),
- runs in **seconds**, not minutes,
- you can run **unattended** — no human in the loop.

If you catch yourself reading code to build a theory before that command exists, stop. Jumping to a hypothesis without a loop is the exact failure this skill prevents.

## Phase 2 — Reproduce and minimise

Run the loop. Watch it go red. Confirm the failure matches the user's symptom, reproduces across runs, and is captured.

Once red, shrink the repro to the smallest scenario that still goes red. Cut inputs, callers, config, data, steps — one at a time, re-running after each cut. Done when every remaining element is load-bearing — removing any one makes the loop go green.

## Phase 3 — Hypothesise

Generate 3–5 ranked hypotheses before testing any. Each must be falsifiable:

> "If X is the cause, then changing Y will make the bug disappear / changing Z will make it worse."

Show the ranked list to the user before testing. They often have domain knowledge that re-ranks instantly. Proceed without the user when they're AFK — the ranking is a sanity check, not a gate.

**Done when** the ranked list is in hand and the user has reviewed it (or is AFK).

## Phase 4 — Instrument

Each probe maps to a specific prediction. Change one variable at a time.

1. Debugger or REPL inspection. One breakpoint beats ten logs.
2. Targeted logs at the boundaries that distinguish hypotheses.

Tag every debug log with a unique prefix, e.g. `[DEBUG-a4f2]`. Cleanup is a single grep. For performance regressions, logs are usually wrong — establish a baseline measurement (timing, profiler, query plan), then bisect.

**Done when** one hypothesis survives instrumentation.

## Phase 5 — Fix

Write the regression test before the fix — but only if a correct interface exists. A correct interface is one where the test exercises the real bug pattern at the call site. When none exists, the codebase architecture is preventing the bug from being locked down — flag it as a finding.

If a correct interface exists:

1. Turn the minimised repro into a failing test at that interface.
2. Watch it fail.
3. Apply the fix.
4. Watch it pass.
5. Re-run the Phase 1 loop against the original (un-minimised) scenario.

**Done when** the regression test fails on the original code and passes on the fixed code, or the missing interface is flagged as a finding.

## Phase 6 — Cleanup

- Original repro no longer reproduces.
- Regression test passes (or absence of interface is documented).
- All `[DEBUG-...]` instrumentation removed.
- Throwaway prototypes deleted.
Then ask: what would have prevented this bug? If architecture change would help (missing test interface, tangled callers, hidden coupling), note it for the next architecture review. Make the recommendation after the fix is in — you have more information now than when you started.

**Done when** every item in the cleanup checklist is satisfied and the architecture note (if any) is captured.
