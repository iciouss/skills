---
name: research
description: Investigate a question against primary sources and capture the findings as a Markdown file.
---

# Research

Spin up a background agent to do the research, so you keep working while it reads.

## Scope

Research is mainly for **external verification** — official primary sources like library docs, API references, third-party services, specs. Source code (including the project's own code) can be read as part of the research when relevant.

## Process

The agent's job:

1. Investigate the question against primary sources — library docs, API references, third-party services, specs. Source code can be read as relevant. Follow every claim back to the source that owns it.
2. Fill `templates/research.md` (Question, Method, Findings, Sources, Caveats, Decision implications) and write it to `.scratch/<feature>/research/<NN>-<name>.md`, citing each claim's source.
3. If the `research/` folder doesn't exist, create it.

**Done when** the research file is written, every claim cites a primary source, and the file lives at `.scratch/<feature>/research/<NN>-<name>.md`.
