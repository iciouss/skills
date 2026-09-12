---
name: writing-for-agents
description: Reference for writing documents agents consume — skills, instruction files, or any doc reached by a pointer. Read when creating new skills or modifying skill structure.
---

# Writing for Agents

Reference for writing any document an agent consumes. The packaging differs; the writing does not: the same levers make each one predictable.

When the document is a skill, see [SKILL-MECHANICS.md](SKILL-MECHANICS.md) for frontmatter and skill structure.

## The two loads

Every document and pointer you add spends one of two budgets:

- **Context load** — cost of always-loaded material on the agent's window: a skill description, anything in context every turn.
- **Cognitive load** — cost on the human: which documents exist and when to reach for each. Not a cost to minimise — it is the price of human agency.

Material reached through a pointer escapes context load at the price of the pointer's own line. Material with no pointer rides entirely on cognitive load.

## Information hierarchy

A document is built from two content types — **steps** (the ordered actions) and **reference** (definitions, rules, facts consulted on demand) — that mix freely. The core decision is where each piece sits on the hierarchy:

1. **In-file step** — the primary tier.
2. **In-file reference** — consulted on demand.
3. **Disclosed reference** — pushed into a separate file, reached by a pointer.

Push too little down and the top bloats; push too much and you hide material the agent needs. That tension is the whole decision.

**Progressive disclosure** is the move down the ladder. Branching is the cleanest disclosure test: inline what every branch needs, push behind a pointer what only some branches reach.

**Co-location** is the within-file companion: keep a concept's definition, rules, and caveats under one heading.

## Size discipline

A skill the model has to follow end-to-end should be **under ~80 lines**. If it's longer, the model's attention thins.

- **If a skill needs more than ~80 lines, split it.** Move the long-running parts to subordinate skills and invoke them by name.
- **Composition is by name.** When a skill needs logic from another, it says "invoke the X skill" — not by re-stating the logic.
- **Templates are external.** If a skill produces a structured artifact, the template is a separate file. The skill reads the template, fills it, writes it.

## Steps and completion criteria

Every step ends on a **completion criterion** — the condition that tells the agent the work is done.

- **Clarity** — can the agent tell done from not-done? Vague bounds invite premature completion.
- **Demand** — how much it requires. "Every modified model accounted for" forces thorough work where "produce a change list" does not.

The strongest criteria are both checkable and exhaustive.

## Leading words

A **leading word** is a compact concept already living in the model's pretraining that the agent thinks with while running the document. Repeated as a token, it anchors a whole region of behaviour in few tokens.

Coining your own works if you define it clearly, but a made-up word recruits no priors — you pay in definition tokens what a pretrained word gives free. Reach for an existing word first.

It anchors twice. In the body, it focuses attention on a class of thing. In a pointer, the shared word links prompts, docs, and codebase to the material.

## Negation

Steering by prohibition drags the forbidden behaviour into context and makes it more available, not less. Prompt the positive — state the target behaviour so the banned one is never spoken. A prohibition earns its place only as a hard guardrail you cannot phrase positively.

## Pruning

- Keep each meaning in a single source of truth. Duplication costs maintenance and tokens.
- The environment is a source of truth too — config files, directory layout, `--help` output — and a document that restates it is a cache. Cache what the agent cannot find by looking.
- Hunt no-ops sentence by sentence. The test — does it change behaviour versus the default? — is model-relative. When a sentence fails, delete the whole sentence.
