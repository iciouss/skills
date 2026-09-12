# Contributing

## Commit convention

### Subject

`<type>(<scope>): <description>`

Allowed types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.
- Optional scope: a component or area of the project (`auth`, `wizard`, `pipeline`, ...), never a filename or file path.
- Drop the scope when there is nothing to disambiguate.

- Up to 72 characters.
- Imperative mood ("add", not "added").
- Legible to someone who has never opened this repo. Name the behaviour or the component in plain words. Symbols and function names go in the body.
- Reasons never go in the subject. The subject states what changed; don't explain why or pair it with its replacement. When the reason is non-obvious from the diff, it earns one line in the body:

```
# Wrong — explains and pairs instead of stating
refactor: drop legacy.sh now that the new generator replaces it

# Right
refactor: remove legacy generator script
- superseded by the new generator
```

### Body

Subject alone only when the diff is one change the subject fully states and the reason is obvious from the diff. Otherwise the body opens one of two doors, per line:

- The change list: each change gets one bullet. Required when the diff has more than one change.
- The reason: one bullet carrying the non-obvious why, tradeoff, or system the change leans on. Required when the diff doesn't make the reason obvious.
- Bullets only, one per change.
- Sharp and terse: one sentence per bullet. No verbosity, no over-explanation. If a bullet needs a second sentence, make it two bullets or drop it.
- Every bullet is exactly one physical line — never wrap or fold a bullet across lines. A long bullet stays on its own long line.
- The diff shows the details. Never repeat in the body what the diff already shows.

Example:

```
feat(auth): session expiry warning before logout
- track last activity timestamp in the session store
- show a persistent warning banner five minutes before expiry
- extend the session in place on any user interaction while the banner is visible
- expired sessions redirect to the login page with a return path
```

### Staging

- Stage entire files with their final state.
- Never stage partial hunks (`git add -p`).
- Never amend, rebase, or redo history to redistribute changes. Grouping happens at file level: if a file seems to belong to two logical units, reconsider the grouping — don't split the file.

### References and credits

- Commit messages reference only repo content — tracked files, ticket and issue numbers. Never local working paths or scratch areas.
- Trailers credit human collaborators only.
