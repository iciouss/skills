---
name: resolve-subtask
description: Resolve one subtask by its type.
disable-model-invocation: true
---

# Resolve Subtask

Resolve one subtask from `.scratch/<feature>/subtasks/`.

## Process

Invoke the `orientation` skill first, unless it was already invoked this session.

1. **Check dependencies.** Read the subtask's `## Blocked by` field. List the unresolved blockers and tell the user which subtasks gate this one. Done when the user knows its blockers (or has none).

2. **Read the subtask.** Read `.scratch/<feature>/subtasks/<subtask-id>.md`. Check the type against the deliverable: a subtask's Resolution holds an answer, a decision, or a record of setup — when the deliverable is a code artifact the repo keeps (file, template, script, module, playbook), the subtask is mistyped; say so, ask the user whether it should be ticket work instead, and wait. Then check the type against the question: a prototype answers a feasibility question with a throwaway build; a task answers "what was set up, moved, or verified" with a record — settled means proven feasible; flag a mismatch, propose the correct type, and wait. Done when the type is known, the type matches the question, and the deliverable holds an answer, a decision, or a record of setup.

3. **Dispatch by type.**

   - **research** → invoke the `research` skill. The research skill writes the full findings to `.scratch/<feature>/research/<NN>-<name>.md`. The subtask file gets a short summary and a link.
   - **grill** → invoke the `grill` skill in persistence mode — the settled/open note IS the content for `## Resolution`.
   - **prototype** → invoke the `prototype` skill. The skill writes the outcome to `.scratch/<feature>/prototype/<NN>-<name>.md`. The subtask file gets a short summary and a link.
   - **task** → do the task manually. Setup or verification work that unblocks decisions: sign up for a service, set up credentials, move data into an external system, verify a precondition. Record what was set up, moved, or verified (service, credentials, data's new location, evidence cited) — this IS the content for `## Resolution`; there is no separate folder.

   Done when the invoked skill (or manual action) has returned its output and the outcome is captured in agent context — ready for `## Resolution`.

4. **Write the resolution in the subtask file.** Open `.scratch/<feature>/subtasks/<subtask-id>.md` and fill in the `## Resolution` section with a short summary of the outcome and a link to the extended record (`research/NN-name.md` or `prototype/NN-name.md` when applicable). For research and prototype, the dedicated folder holds the full record — answers, reasoning, what was done. Done when `## Resolution` holds the summary, and the link is present for research and prototype subtasks.

5. **Set Status.** If the work produced an answer, set Status to `resolved`. If the work surfaced a hard blocker (the target doesn't exist, the verification failed, the setup couldn't complete) and downstream phases cannot proceed without human intervention, set Status to `blocked` and add the blocker explicitly to the subtask's `## Resolution`. Done when the file's `## Status` reflects the actual state.

6. **Update goal.md.** Set the corresponding task's `**Status**` in `.scratch/<feature>/goal.md` to match the subtask file (`resolved` or `blocked`). Done when the matching task's `**Status**` in `goal.md` matches the subtask file.

## Scope

This skill resolves one subtask.
