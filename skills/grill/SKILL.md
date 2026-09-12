---
name: grill
description: Interview the user repeatedly until you reach a shared understanding. Use when the user wants to stress-test a decision before writing it down.
---

# Grill

Interview the user. Map the conversation as a **design tree**: every decision branches into the decisions that depend on it.

## The mechanic

Work the tree in **rounds**. The **frontier** is the set of decisions whose prerequisites are settled — the questions you can ask now without guessing. Ask the whole frontier in one round, and wait for the answers before the next round.

Each question gets a number. Use the format that fits the question:

**Choice question** — when the answer is one of a known set:

```
❓ **Q1** — **<title>**: <body>

(a) <short handle>: <longer description>
(b) <short handle>: <longer description>
(c) <short handle>: <longer description>

➡️ <your recommended answer>
```

Each option is a separate line. The handle is a short noun (`redis`, `postgres`, `in-memory`) that names the choice. The description is one or two clauses explaining what it means. Always include 2–4 options.

**Open question** — when the answer is a value, a description, or free-form input:

```
❓ **Q1** — **<title>**: <body>
```

Ask for what you need in one sentence. The user's answer is the input.

After each round, the tree reshapes: settled decisions open new questions at the frontier. Recompute and ask again. A question whose answer depends on another still-open question belongs to a later round.

## Facts vs decisions

Finding facts is your job. When a frontier question needs a fact from the environment, dispatch a sub-agent. Look up facts in the environment; ask the user only about decisions.

The decisions are the user's. Put each to them and wait.

## Vocabulary

When a term gets pinned down — a word that will mean one thing from now on — invoke the `domain-modeling` skill to record it in `CONTEXT.md`. Record it when it lands, not batched at the end.

## Persistence

By default, grilling leaves nothing behind. If the user wants persistence, write down "what we settled" and "what we left open" at the end. A hard-to-reverse decision deserves a short note: what was chosen, why, and what was rejected.

The frontier is empty when the persistence note lists every open question and the list is empty. If the open questions resist enumeration, the frontier isn't empty yet. Wait for the user to confirm before acting.
