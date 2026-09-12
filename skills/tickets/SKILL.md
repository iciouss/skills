---
name: tickets
description: Convert a plan into actionable ticket files. Use when a plan is ready to split.
disable-model-invocation: true
---

# Tickets

## Process

Invoke the `orientation` skill first, unless it was already invoked this session.

1. **Read the plan.** Locate the plan at `.scratch/<feature>/plan.md`. If there is no plan, read `goal.md` instead — for a goal that needed no subtasks, the goal and its decisions *are* the plan. Ask only when neither exists. Done when the plan (or goal) is in hand.

2. **Read the template.** Read `templates/ticket.md` — sections are Origin, What to build, Size, Depends on, Acceptance criteria, Verification, Notes. This is the schema. Every ticket you write MUST match it. Done when the section list is in hand.

3. **Draft vertical slices.** Break the plan into vertical slices — each cuts a narrow but COMPLETE path through every layer (schema, API, UI, tests). Each slice is sized to fit in one fresh context window. Done when each slice cuts a complete path and fits one context window.

   Default to vertical slices. Sequence wide refactors (rename a column, retype a shared symbol) as expand → migrate batches → contract. Each batch is its own ticket.

4. **Wire dependencies.** Each ticket lists the tickets that must complete before it can start. A ticket with no dependencies can start immediately. Done when every dependent ticket references blockers numbered lower.

5. **Quiz the user.** Present the proposed breakdown. For each ticket show: title, depends on, what it delivers. Ask: granularity right? Dependencies correct? Anything to merge or split? Wait for response before writing.

   Done when the user has approved the breakdown.

6. **Write the tickets.** One file per ticket at `.scratch/<feature>/tickets/NN-name.md`. Naming: `<NN>-<kebab-case-title>.md`, numbered from `01` in dependency order (dependencies first). Each file's "Depends on" lists the numbers/titles it depends on. Done when every ticket file is written with all template sections filled.

   Then update `.scratch/<feature>/plan.md` (if there is one): replace the `## Tickets` placeholder with the bullet list of ticket paths (one per line, e.g. `- tickets/01-export-foundation.md`). Working from `goal.md` with no plan, skip this. Done when every ticket is written and, where a plan exists, it lists every ticket.

The template is the source of truth. Edit it when the schema needs to change.

Reference decisions and sections by name from the plan. Paths go stale. Exception: if a prototype produced a snippet that encodes a decision precisely (state machine, reducer, schema, type shape), inline it and note it's from a prototype.
