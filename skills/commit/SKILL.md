---
name: commit
description: Make one or more git commits that follow the project's conventions.
---

# Commit

Group the changes into logical units. A logical unit is a self-contained change that can be reviewed in isolation.

## Process

1. **Check status.** Run `git status` and `git diff --staged` to see what will be committed. Done when the working-tree and staged files are in hand.

2. **Plan the commits.**
   - Group by type (feat, fix, docs, refactor) — one type per commit when possible.
   - Group by component — one logical component per commit.
   - Group by concern — one concern per commit.

   Aim for 2–4 commits for a typical change, or as many as there are logical units. **A single commit is fine when the change is minimal** — one logical unit, all related files.

   Done when every file appears in exactly one group, sorted by type/component/concern.

3. **Present the plan.** Show the proposed commits: which files go into which commit, and the subject line for each. Done when the user approves the grouping and each proposed subject.

4. **Stage and commit each group.** For each approved group:
   - Stage the relevant files by name — entire files with their final state, never partial hunks.
   - Draft the subject. Check the rules. Iterate until they pass.
   - Draft the body if needed. Bullets only.
   - Commit.

   Done when each approved group has landed as its own commit.

5. **Verify.** Run `git log` to confirm the commits landed. Done when `git log` shows every approved commit.

If the project has pre-commit hooks, run them. If they fail, fix what's fixable and ask the user about the rest.

## Message conventions

The subject and body follow the project's commit convention — see the project's `CONTRIBUTING.md` (typically at the repo root). If no `CONTRIBUTING.md` exists, follow standard Conventional Commits.
