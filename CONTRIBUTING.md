# Contributing

## Commit convention

### Subject

`<type>(<scope>): <description>`

Allowed types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.

- Up to 72 characters.
- Imperative mood ("add", not "added").
- Legible to someone who has never opened this repo. Name the behaviour or the component in plain words. Symbols and function names go in the body.

### Body

Subject alone only when the diff is one change the subject fully states. Otherwise the body is the change list:

- Bullets only, one per change.
- Sharp and terse: one sentence per bullet. No verbosity, no over-explanation. If a bullet needs a second sentence, make it two bullets or drop it.
- Every bullet is exactly one physical line — never wrap or fold a bullet across lines. A long bullet stays on its own long line.
- The diff shows the details. The body states what changed; a bullet may name a non-obvious why, a tradeoff, or a system the change leans on — still in one line.

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
