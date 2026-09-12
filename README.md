# Skills

A small set of skills for planning and building software — from a one-line fix to a large feature. Each is a short instruction sheet that an AI agent (or a person) can follow. They share one vocabulary; this README explains the words so everyone — technical or not — reads them the same way.

Based on [Matt Pocock's skills](https://github.com/mattpocock/skills) — simplified and adapted to match my own workflow.

## The pipeline

Large pieces of work flow through five steps, in order, each leaving files under `.scratch/<feature>/` for the next to find:

1. **define-goal** — name the goal, grill it into shape, break it into subtasks.
2. **resolve-subtask** — settle each subtask by its type (research, grill, prototype, task).
3. **create-plan** — assemble everything resolved into one plan.
4. **tickets** — split the plan into small, self-contained tickets.
5. **implement** — build one ticket end to end, review it, commit it.

Small changes skip the pipeline and go straight to **implement**.

## The other skills

- **orientation** — the map; read it first in a fresh session.
- **diagnose** — hard bugs; builds a tight feedback loop before guessing.
- **grill** — interview the user to settle a decision.
- **prototype** — throwaway code that answers a design question.
- **research** — a background agent reads primary sources and returns a cited file.
- **tdd** — tests first, one small slice at a time.
- **code-review** — reviews a diff on two axes: does it match the standard, and does it match the ticket.
- **commit** — groups changes into clean commits.
- **domain-modeling** — keeps the project's shared vocabulary in `CONTEXT.md`.
- **handoff** — writes the conversation to a file a fresh session can pick up.

## Words the skills lean on

Some words already carry a precise meaning in the field, so the skills use them on purpose. Here is what each means in plain words.

**Testing**

- **tight loop** — a fast, reliable way to tell if something is broken: one command, runs in seconds, same answer every run.
- **red / green** — from tests: a failing test is "red", a passing one is "green". "Red before green" means write the failing test first.
- **vertical slice** — a small change that cuts all the way through every layer (data, logic, UI) instead of finishing one whole layer first.
- **seam** — the place you test from the outside, without reaching into internals.

**Code review smells** — signs code is off, named after Martin Fowler's list:

- **Mysterious Name** — a name that doesn't reveal what it does or holds.
- **Duplicated Code** — the same logic shape in two places.
- **Feature Envy** — a function that reaches into another thing's data more than its own.
- **Data Clumps** — the same few fields always travelling together.
- **Primitive Obsession** — a string or number standing in for a real concept.
- **Repeated Switches** — the same if/switch on the same type, again and again.
- **Shotgun Surgery** — one change forcing edits across many files.
- **Speculative Generality** — abstraction added for needs nobody has.

**Planning**

- **frontier** — in grilling, the questions you can ask *now* without guessing; you ask them, then recompute what's askable.

## The project's own words

A project's own shared vocabulary lives in `CONTEXT.md` — a short glossary. Read it when you start; update it when a term gets pinned down (see `domain-modeling`).
