---
name: domain-modeling
description: Maintain the project's shared vocabulary — a CONTEXT.md glossary — so a term means the same thing to every session and every person. Use when terms get fuzzy or you're naming a new concept.
---

# Domain Modeling

When several sessions (or several people) work on one project, they drift apart the moment one word means two things. This skill keeps the words shared. It is a light habit, not a pipeline step — reach for it only when terms actually start to blur.

## The glossary — CONTEXT.md

A `CONTEXT.md` at the repo root is a short glossary: one entry per concept the project names. Create it lazily — only once the first term is worth pinning down. A one-file change doesn't need one.

Each entry:

- picks **one** word for the concept and lists the ones to avoid, e.g. `**Order**: what a customer buys. _Avoid_: purchase, transaction.`
- keeps the definition to one or two sentences — what it *is*, not what it does.
- covers only terms specific to this project. General programming words (timeouts, caches, errors) don't belong.

## The habit

Do these as you work; don't batch them:

- **Challenge a fuzzy word.** When someone says "account" and it could mean customer, login, or billing record, ask which. Write the answer down.
- **Catch contradictions.** When the code and the conversation disagree ("your code cancels whole orders, but you said partial"), surface it.
- **Update in place.** When a term gets pinned down, fix `CONTEXT.md` right then.

## Decisions

When a call is hard to reverse *and* future-you will wonder why, jot one sentence — what was chosen and why — under a `## Decisions` heading in `CONTEXT.md` or in `docs/decisions/`. Skip it when the choice is obvious or easy to undo.

## When to skip

Reach for this only when words start costing time. A small tweak, a one-off script, or a repo you'll touch once: don't build a glossary. Keep the cost of the glossary below the cost of the confusion it prevents.
