---
name: tdd
description: Write tests first, then the smallest code to pass them, one slice at a time. Use when building a feature or fixing a bug test-first.
---

# TDD

The red → green loop: write a failing test, make it pass with the least code, repeat. One slice at a time.

Reach for this only when the change has real behaviour — logic, state, a bug. A config tweak or a one-file script usually doesn't need it; build those directly.

## The loop

1. Write one failing test for a small slice of behaviour. Watch it fail (red).
2. Write the smallest amount of code that makes it pass (green).
3. Move to the next slice. Don't anticipate future tests.

Refactoring is not part of the loop — do it in review (see `code-review`).

## What a good test is

- Tests behaviour from the outside, through the public interface — not internals.
- Reads like a spec: "a user can check out with a valid cart".
- Survives refactors: it breaks only when behaviour changes, not when the code's shape does.

## Where to test

Test at the **seam** — the public boundary you test from the outside, without reaching into internals. Agree the seams up front: which parts do we test, and from where? Testing every edge case is not the goal — the critical paths and the tricky logic are.

## Anti-patterns

- **Testing internals.** The tell: the test breaks when you refactor but behaviour hasn't changed.
- **Tautological tests.** The expected value is computed the same way the code computes it, so it can never disagree. Expected values come from a real example or the spec, not the code.
- **All tests first, then all code.** Bulk tests check imagined behaviour. One test → one implementation → repeat.
