# Skill Mechanics

The mechanics of writing a skill: frontmatter, description, when to invoke, when to split.

## Frontmatter

Every skill has YAML frontmatter:

- **name** — kebab-case identifier. The folder name and the slash command name.
- **description** — the most important field. The agent reads this to decide whether to invoke the skill. Front-load the leading word. One trigger per branch. Cut identity the body already carries.
- **disable-model-invocation** — where the model-vs-user invocation choice is made; see [Invocation](#invocation) below.
- **argument-hint** — hint shown when invoking with arguments.

## The description field

The description is a context pointer. It states what the material is and lists the branches that trigger reaching it.

Every word spends always-loaded context. Prune aggressively:

- **Front-load the leading word** — the description is where the triggering work happens.
- **One trigger per branch.** Synonyms rename one branch — collapse them.
- **Cut identity the body already carries.**

## Invocation

A skill is either **model-invoked** or **user-invoked**.

- **Model-invoked** (the default — omit `disable-model-invocation`): the agent reads the description and can fire the skill on its own, and other skills can invoke it by name. Costs a little always-loaded context for the description. Use it when the agent must reach the skill itself, or when another skill invokes it by name.
- **User-invoked** (`disable-model-invocation: true`): only a person typing the skill's name can invoke it. No other skill can reach it, and it costs no context. Use it for entry points only a person starts — nothing else invokes them by name, and auto-firing would misfire.

One rule decides most cases: **a skill another skill invokes by name must stay model-invoked.** If `implement` says "invoke the `commit` skill", `commit` cannot be user-invoked.

If user-invoked skills ever multiply past what you can remember, add one user-invoked **index** skill that names them all and when to reach each — but wait until there are enough to need it.

## When to split

Split one skill into two only when the cut earns it:

- **By sequence** — split steps where the post-completion steps tempt the agent to rush.
- **By invocation** — when two parts serve different triggers.
- **By size** — when a skill is over ~80 lines, the model's attention thins. Split.

## Composition

When a skill needs logic from another, it says "invoke the X skill" rather than re-stating the logic. The model handles the composition.

Two ways to reference another skill, and they mean different things: "invoke the `x` skill" is the agent running it now (only works for a model-invoked skill); "`/x`" is the human typing it next, used to reach a user-invoked skill or to hand a phase boundary to the user. Reference a primitive with "invoke"; an entry point with a slash.

Templates are external. If a skill produces a structured artifact, the template is a separate file. The skill reads, fills, writes.
