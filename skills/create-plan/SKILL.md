---
name: create-plan
description: Assemble the final plan from all resolved subtasks at .scratch/<feature>/. Use after all subtasks are resolved.
disable-model-invocation: true
---

# Create Plan

Read `.scratch/<feature>/` and assemble the final plan.

## Process

Invoke the `orientation` skill first, unless it was already invoked this session.

1. **Read the goal.** Read `.scratch/<feature>/goal.md` for the goal statement. Done when the goal sentence is in hand.

2. **Read the resolved subtasks.** Walk `.scratch/<feature>/subtasks/`. Each subtask file has a `## Resolution` section when done. Done when every subtask's resolution has been read.

3. **Read the research files** (if any). Walk `.scratch/<feature>/research/`. These are findings from research subtasks. Done when the research has been read or the folder is absent.

4. **Verify completeness.** Every subtask should have a resolution. If any subtask is unresolved, surface the gap and ask the user how to proceed. Done when every subtask file has a non-empty `## Resolution` or the user has chosen how to proceed.

5. **Assemble the plan.** Use the plan template at `templates/plan.md`. From `goal.md`: copy the goal sentence into `## Goal`; copy `## Decisions` into `## Decisions` (the plan's `## Decisions` subsumes any decisions accumulated in `goal.md` during grilling — the plan is the durable record); fold `## Context` into `## Approach`; carry `## Blockers` into `## Open questions` (still-blocking items are open questions); copy `## Open questions` and `## Out of scope` as-is. Synthesize the resolved subtasks and research findings into the plan sections:
   - research findings → `## Decisions` (with inline link to `research/NN-name.md`)
   - task completions → `## Artifacts`
   - grill outcomes → `## Decisions`
   - prototype results → `## Decisions` (with inline link to `prototype/NN-name.md`, if a decision) or `## Approach` (if a validated pattern)

   `## Tickets` is filled by the `tickets` skill after the plan is approved — leave the template placeholder for it.

   Done when every section in `plan.md` is populated from the resolved material, with `## Tickets` left as its template placeholder.

6. **Write `.scratch/<feature>/plan.md`.** Read the template, fill it, write it.

   Done when `plan.md` is written at `.scratch/<feature>/plan.md`.

7. **Quiz the user.** Present the plan. Ask: granularity right? Anything missing or mis-scoped? Anything to merge or split? Wait for response before proceeding.

   Done when the user has approved the plan.

8. **Hand off.** Done when the user has the plan path and the `/tickets` invocation.

Future: archive `.scratch/<feature>/` after the feature ships — not now.
