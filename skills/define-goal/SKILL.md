---
name: define-goal
description: Scope a project before building — grill a big idea into a goal and subtasks, or a medium one into a goal and tickets.
disable-model-invocation: true
---

# Define Goal

Take a big idea and break it into subtasks. Writes the goal and subtasks to `.scratch/<feature>/` so the rest of the workflow can find them.

## When to use

- **Big** — the path from here to the goal isn't visible yet; you can't name the steps.
- **Medium** — the shape is visible, but it splits into a few tickets and its decisions need settling first.

Small work goes straight to `implement`. The full routing rule lives in `orientation`.

## Process

The user invokes with a feature name: `/define-goal add-feature-X`. The skill creates the directory and walks the user through defining the goal.

Invoke the `orientation` skill first, unless it was already invoked this session.

1. **Name the goal.** One sentence. The goal fixes the scope. If the user names a specific file path, route, library, or system, verify it exists in the working directory or a documented spec. If a reference doesn't resolve — because it's vague ("the dashboard", "the auth system"), the user is in the wrong directory, or the target was deleted — ask the user to point at it before proceeding — verification deferred propagates the gap. Done when a single sentence captures the goal in the user's words AND any specific references resolve.

2. **Grill the goal.** Invoke the `grill` skill. Grill until the frontier is empty (see `grill`). Done when the grill frontier is empty.

3. **Break into subtasks.** Subtasks MAKE the decisions; tickets BUILD the deliverable. A subtask's Resolution holds an answer, a decision, or a record of setup.

   Subtask types:
   - **research** — gather facts from an external source before a decision can be made (library docs, API references, third-party services, specs, source code).
   - **grill** — a sub-decision that needs its own grilling session.
   - **prototype** — a design question answered by building: which of several approaches to pick, or whether a chosen approach holds up against the tooling or runtime. The build is throwaway evidence for that answer; the durable version is ticket work. Settled means the approach is proven feasible; a decision with no proof is still a prototype.
   - **task** — operational work against a live system or an already-built thing: sign up for a service, set up credentials, migrate data, verify a precondition (auth path, audit-log policy, license), or confirm a built change behaves as expected (a dry-run produces no drift). The output is the record — what was set up, moved, or verified, with the evidence: account created, data's new location, file path, commit, runbook.

   Two tests, in order. First, the deliverable: an answer, a decision, or a record of setup keeps it; a code artifact the repo keeps — file, template, script, module, playbook — fails the test, and the subtask is ticket work in disguise: rewrite it as the decision it unblocks or drop it for the ticket phase. Then, the type against the question: a prototype answers "which approach, or does it hold" with throwaway evidence; a task answers "what was set up, moved, or verified" with a record. Settled means proven feasible. A subtask that resists all four types goes to the user.

   Each subtask gets a title, a one-line description, and a type.

   Done when every subtask passes both tests — its Resolution would hold an answer, a decision, or a record of setup (not a code artifact), and its type matches its question (a throwaway build answering feasibility is prototype; an operational record is task). When every decision is already settled and no work passes the test, write goal.md with an empty task list and skip to step 7.

4. **Wire dependencies.** Each subtask lists the other subtasks that must be resolved before it can start. A subtask with no dependencies can start immediately. Number subtasks so dependencies always come before dependents. Renumber before writing if blockers carry higher numbers. Done when every subtask's `## Blocked by` references earlier-numbered subtasks only.

5. **Write the files.** Two templates are filled:
   - `.scratch/<feature>/goal.md` — the goal and the list of subtasks
   - `.scratch/<feature>/subtasks/NN-name.md` — one file per subtask

   Read the templates before filling — `goal.md` (Goal, Context, Tasks, Blockers, Decisions, Open questions, Out of scope) and `subtask.md` (Description, Type, Blocked by, Status, Resolution). The schema is the contract. Done when `goal.md` and every subtask file are written.

6. **Quiz the user.** Present the goal and subtasks. Ask: granularity right? Anything missing or mis-scoped? Subtasks can be merged or split. Are the dependencies right? Are the references in the goal real — is this goal buildable in the current repo, or does prerequisite work need to land first? Read each subtask's deliverable aloud and confirm it holds an answer, a decision, or setup — anything that builds repo code moves to the ticket phase. Every decision left open here is settled with the user; tickets build the deliverable from decisions already made. Wait for response before proceeding.

   Done when the user has approved the goal and subtasks, every open decision is settled, and any merges, splits, or ticket-phase moves are reflected in the files.

7. **Hand off.** With subtasks, the user resolves each by running `/resolve-subtask <feature> <subtask-id>` (one per session), then `/create-plan`. With an empty task list — the medium case, nothing to research or decide — `/tickets` is next, and `tickets` reads `goal.md` directly. Done when the handoff is delivered: the user has the goal, the subtask list (if any), and the invocation for the next phase.

## Scope

This skill defines the goal and breaks it into subtasks. Resolving subtasks is `resolve-subtask`'s job; assembling the plan is `create-plan`'s job. When the goal needs no subtasks, both are skipped and `tickets` reads `goal.md` directly. The user runs `resolve-subtask` per subtask, then `/create-plan` — or `/tickets` when there are none.

## Templates

- `templates/goal.md` — the goal template
- `templates/subtask.md` — the subtask template (one per subtask)
