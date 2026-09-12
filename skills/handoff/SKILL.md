---
name: handoff
description: Write the current conversation into a portable document for another agent to pick up.
argument-hint: "What will the next session focus on?"
disable-model-invocation: true
---

# Handoff

## Include

- A summary of where the conversation is and where it needs to go.
- Key decisions, with pointers to where they're recorded (plan files, tickets, commits).
- Open questions and unresolved decisions.
- A "suggested skills" section listing the skills the next session should invoke.

## Where things live

- Content already captured elsewhere (plans, tickets, commits, diffs). Reference by path or URL.
- Sensitive information: API keys, passwords, PII. Redact with `<REDACTED>`.

## Where to save

Save to a path you generate under `$TMPDIR` (e.g., `/tmp/handoff-<topic>-<date>.md`). The agent passes the absolute path back to the user. If the user passes arguments, treat them as a description of the next session's focus and tailor the document.

**Done when** the file is written to the temporary directory and the user is shown the path.
