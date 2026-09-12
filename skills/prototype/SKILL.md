---
name: prototype
description: Build a throwaway prototype to answer a design question — a state model, a UI shape, or a piece of logic.
---

# Prototype

## Pick a branch

- **"Does this logic / state model feel right?"** → build a single shareable HTML file with free-play buttons and tabbed guided walkthroughs that pushes the state through cases hard to reason about on paper. A non-developer should be able to drive it.
- **"What should this look like?"** → generate several radically different UI variations on a single route, switchable via a URL search parameter and a floating bottom bar.
- **"How does this perform / integrate / behave under X?"** → write a focused mini-script that drives the question end-to-end with a fixture input. Output the answer (timing, sequence, returned value) so the user can read it.

If the question is ambiguous and the user isn't reachable, default to whichever branch matches the surrounding code (backend module → logic; page or component → UI) and state the assumption at the top.

## Rules

1. **Dummy values.** Feed the prototype placeholders — a dummy endpoint, token, or name. Real credentials, keys, endpoints, and environment values enter a prototype only after the operator gives explicit permission, asked for first.
2. **Reachable and throwaway.** Put the prototype where a later session can open it: a pipeline prototype in `.scratch/<feature>/prototype/<NN>-<name>/`, a standalone one next to the module or page it prototypes. Name it so a casual reader sees it's a prototype.
3. **Trivial to run.** A UI prototype starts from one command in the project's task runner. A logic demo is a single HTML file the user double-clicks.
4. **State lives in memory by default.** If the question involves a database, hit a scratch DB or a local file with a clear "PROTOTYPE — wipe me" name.
5. **Just enough to run.** Tests, error handling, and abstractions belong in the real implementation.
6. **Surface the state.** After every action (logic) or variant switch (UI), print or render the full relevant state so the user can see what changed.
7. **Capture it when done.** Fold any validated decision into the real code. Commit the prototype itself to a branch out of main. The main branch keeps only the validated decision.

## Record

After the prototype runs, fill `templates/prototype.md` (Question, Built, Outcome, Decision implications) and write it to `.scratch/<feature>/prototype/<NN>-<name>.md`, alongside the prototype code. If the `prototype/` folder doesn't exist, create it. The plan and the eventual implementation ticket cite this file.

**Done when** the prototype file is written and a short outcome has been delivered to the user.
