---
name: orientation
description: Pipeline map for engineering work. Invoke before any pipeline skill (define-goal, resolve-subtask, create-plan, tickets, implement) in a fresh session.
---

# Orientation

The engineering workflow is a five-skill pipeline, in order. Each hands off to the next by naming it. Each writes artifacts under `.scratch/<feature>/` where the next skill finds them.

If `CONTEXT.md` exists at the repo root, read it first — it is the project's shared vocabulary, and its terms are the ones to use.

## Choosing a path

Sort the work with two questions, in order:

1. **Can you name the steps?** State the result *and* the concrete steps to it, without making decisions you haven't made yet. If not, it's **big**.
2. **Is it more than one bite?** More than one "fits-one-context-window" piece. If not, it's **small**; if yes, it's **medium**.

- **small** — one sentence, one context window, no open decisions → `implement`.
- **medium** — the shape is visible, it splits into a few tickets, and a short conversation settles the decisions → `define-goal`, then `tickets` (skip `resolve-subtask` and `create-plan`).
- **big** — you can't enumerate the steps yet; something needs researching, prototyping, or deciding on its own → the full pipeline.

Medium vs big is one question: *does anything need to be researched, prototyped, or decided on its own before the first line can be written?* Yes → big; no → medium.

When unsure, the asymmetry decides: over-planning a small task wastes minutes; under-planning a big one wastes hours. Cheap to redo → default down; expensive to reverse → default up.

## Pipeline

1. **define-goal** — grill a big idea, break it into subtasks, write `goal.md` and `subtasks/`.
2. **resolve-subtask** — resolve one subtask by its type (research, grill, prototype, task), write its `## Resolution`.
3. **create-plan** — read the goal and resolved subtasks, assemble `plan.md`.
4. **tickets** — read the plan, split it into ticket files in `tickets/`.
5. **implement** — build one ticket end-to-end (read, code, review, commit).

## File layout

```
.scratch/<feature>/
├── goal.md             # goal statement and subtask list
├── subtasks/           # one file per subtask
├── research/           # research artifacts
├── prototype/          # prototype records
├── tickets/            # one file per ticket
└── plan.md             # the final plan
```

## Vocabulary

- **subtask** — pre-implement work, after define-goal, before create-plan. Holds an answer, a decision, or a record of setup.
  - **research** — gather facts from an external source before a decision can be made.
  - **grill** — a sub-decision that needs its own grilling session.
  - **prototype** — a design question answered by a throwaway build; settled means proven feasible.
  - **task** — operational work against a live system or built thing: credentials, migrations, precondition checks, drift checks. The deliverable is the record.
- **ticket** — ready-to-implement work, after tickets, before implement. Builds a deliverable the repo keeps.

A subtask resolves a question. A ticket builds the thing.

The full list of skills — and the vocabulary they lean on — lives in the README.
