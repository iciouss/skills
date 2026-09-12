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
   - Stage the relevant files by name.
   - Draft the subject. Check the rules. Iterate until they pass.
   - Draft the body if needed. Bullets only.
   - Commit.

   Done when each approved group has landed as its own commit.

5. **Verify.** Run `git log` to confirm the commits landed. Done when `git log` shows every approved commit.

If the project has pre-commit hooks, run them. If they fail, fix what's fixable and ask the user about the rest.

## The subject

Format: `<type>(<scope>): <description>`

**Allowed types:** `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.

**Rules:**
- Up to 72 characters.
- Imperative mood ("add", not "added").
- Legible to someone who has never opened this repo. Name the behaviour or the component in plain words. Symbols and function names go in the body.

## The body

Subject alone only when the diff is one change the subject fully states. Otherwise the body states every change — one tight line each — and only the non-obvious ones earn expansion. An expansion names:
- a non-obvious why
- a tradeoff taken
- a system the change leans on

Bullets only. The diff shows the details; the body is the change list, not the change explanation.

## Where things live

- The subject and body carry the change description — ticket numbers, issue references, and `.scratch` paths live in the trailers or commit metadata.
- Trailers credit human collaborators only — add them when there are collaborators to credit.
