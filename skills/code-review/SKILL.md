---
name: code-review
description: Review a branch, PR, or in-progress work against repo conventions and a ticket.
---

# Code Review

Two-axis review of the diff between `HEAD` and a fixed point. Both axes run as parallel sub-agents in separate contexts.

## Process

1. **Pin the fixed point.** Whatever the user said — commit SHA, branch, tag, `main`, `HEAD~5`. Ask when no fixed point was named.

   Capture `git diff <fixed-point>...HEAD` (three-dot) and `git log <fixed-point>..HEAD --oneline`. Confirm the fixed point resolves and the diff is non-empty before going further.

   Done when the fixed point resolves and the diff is in hand.

2. **Identify the ticket.** Locate it by path, commit message, or branch. Ask when no path, branch, or commit message identifies a ticket. If the user confirms no ticket exists, the Ticket sub-agent reports "No ticket available — Ticket axis skipped".

   Done when the ticket is in hand or the user confirms there's none.

3. **Identify the standards sources.** Anything in the repo that documents how code should be written.

   On top of whatever the repo documents, the Standards axis always carries this small fallback list of code smells — signs the code is off even when no standard is written down. The repo's own standards override the fallback; these are judgement calls, not hard rules; skip anything tooling already enforces:

   - **Mysterious Name** — a name that doesn't reveal what it does or holds. Rename it.
   - **Duplicated Code** — the same logic shape appears in more than one place. Extract it and call it from both.
   - **Feature Envy** — a function that reaches into another thing's data more than its own. Move it onto that data.
   - **Data Clumps** — the same few fields always travelling together. Bundle them into one type.
   - **Primitive Obsession** — a primitive or string standing in for a concept that deserves its own type. Give it one.
   - **Repeated Switches** — the same `switch`/`if` cascade on the same type appears again. Replace with one shared map or a type that handles the difference.
   - **Shotgun Surgery** — one logical change forces scattered edits across many files. Gather what changes together into one module.
   - **Speculative Generality** — abstraction, parameters, or hooks added for needs nobody has yet. Delete them.

   Done when the standards-source list is in hand.

4. **Identify the enforced tooling.** Scan the repo for linters, formatters, tsconfig strict mode, biome/eslint configs, CI style checks. Pass this list to the Standards sub-agent so it focuses on what falls outside tooling's automated checks.

   Done when the enforced-tooling list is in hand.

5. **Spawn both sub-agents in parallel.**

   **Standards sub-agent** gets:
   - The diff command and commit list.
   - The standards-source files.
   - The enforced-tooling list.
   - The fallback smell list from step 3, pasted in full — the sub-agent has no other access to it.
   - The brief: "Report per file/hunk every place the diff departs from a documented standard that falls outside tooling's automated checks: cite the standard (file + rule). Also report any fallback smell you spot, naming it and quoting the hunk. Distinguish hard violations from judgement calls: documented-standard breaches can be hard, but fallback smells are always judgement calls, and a documented standard overrides the fallback. Under 400 words."

   **Ticket sub-agent** gets:
   - The diff command and commit list.
   - The path or contents of the ticket, or an explicit note that no ticket is available.
   - The brief: "If no ticket was provided, report a single line: 'No ticket available — Ticket axis skipped.' Otherwise, report: (a) requirements missing or partial; (b) scope creep; (c) requirements implemented wrong. Quote the ticket line for each. Under 400 words."

   Done when both sub-agents return their reports under 400 words.

6. **Aggregate.** Present the two reports under `## Standards` and `## Ticket`. Report each axis under its own heading — they're separate dimensions, not a ranked list.

The review is complete when both reports are aggregated with a one-line summary: total findings per axis, worst issue within each axis.

A change can pass one axis and fail the other. Reporting them separately keeps one from masking the other.
