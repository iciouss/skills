---
name: implement
description: Build a ticket end-to-end.
disable-model-invocation: true
---

# Implement

Build the work described in a ticket. One ticket per session.

## Process

Invoke the `orientation` skill first, unless it was already invoked this session.

1. **Read the ticket.** If a ticket file exists at `.scratch/<feature>/tickets/<ticket-id>.md`, read it. If not, the request itself is the ticket — build from what the user asked. Find the plan at `.scratch/<feature>/plan.md` if you need context. Done when what to build and its acceptance criteria are in hand.

2. **Read the codebase.** If `CONTEXT.md` exists at the repo root, read it first — its terms are the project's vocabulary. Before writing code, read the relevant files. If the working directory doesn't contain a source tree relevant to the ticket (no package manifests, no source files, no build config), stop and ask the user whether to (a) point the work at a different directory, (b) treat the ticket's Notes as a stack-agnostic contract, or (c) abandon the ticket. The code-review and commit steps below run against a real codebase — choose the option that gives them one. Done when the files you'll change and the patterns they follow are in hand, OR the user has chosen how to proceed.

3. **Check the ticket is tight.** If the ticket is vague — open-ended verbs like "improve" or "investigate" with no concrete acceptance — invoke `grill` to scope it before building. The ticket should be executable. Done when the ticket is tight enough to build from.

4. **Size cap.** A ticket fits one context window. If mid-build scope grows past that, re-split via `/tickets` and resume on the new ticket.

5. **Build it.** Write the code. For a behaviour-heavy change, invoke the `tdd` skill and build test-first — one failing test, then the smallest code to pass it, one slice at a time. For a simple change — a config tweak, a one-file script — just build and verify. Run typecheck and tests as you go. Done when typecheck and tests pass against the acceptance criteria.

6. **If something breaks:** invoke the `diagnose` skill. Find the root cause. Done when the build is green again or the break is escalated.

7. **Code-review.** When the build is done, invoke the `code-review` skill. Two axes: Standards (does it follow the repo's conventions?) and Ticket (does it match what the ticket asked for?). Done when both axes are aggregated and clean.

8. **Verify with the user.** Green typecheck and tests prove the code, not the behavior — the user is the only one who can confirm the change works. Hand over the verification: exact commands, what to expect, what counts as correct. Wait for the user's verdict. Done when the user confirms the behavior is correct; a reported problem loops back to step 6. Until the user confirms, stop after this step — the tick and commit steps below are gated on this confirmation.

9. **Tick the acceptance criteria.** If there's a ticket file, open it and mark each `[ ]` in `## Acceptance criteria` as `[x]` where the work satisfies it. If there's no file (you built from a request), confirm the acceptance criteria in your closing summary instead. Done when the user has confirmed (step 8) and every criterion is accounted for.

10. **Commit.** Invoke the `commit` skill. The skill enforces the project conventions. Done when every criterion is ticked and the commits land per `commit`.

Iterate the build → review → verify → tick → commit cycle (invoking `code-review` and `commit`) until the build is clean, the user has confirmed the behavior, and every acceptance criterion is checked. Re-open this skill via `/implement` only when scope grows past one session.
