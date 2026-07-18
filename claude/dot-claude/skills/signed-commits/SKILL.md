---
name: signed-commit
description: Create git commits following the user's conventions. Use whenever committing changes - splits work into appropriately sized commits, writes English commit messages with emoji prefixes, and signs every commit.
disable-model-invocation: true
---

# Commit

Create signed git commits with consistent messages and appropriate granularity.

## Workflow

1. Run `git status` and `git diff` (and `git diff --staged`) to understand all pending changes.
2. Group the changes into logical units (see "Commit granularity" below).
3. For each unit, stage only the relevant files (use `git add <paths>` or `git add -p` for partial staging), then commit.
4. Always sign commits with the `-S` flag:

   ```
   git commit -S -m "<message>"
   ```

5. After committing, run `git log --show-signature -1` if you need to verify the signature, and `git status` to confirm nothing was left behind unintentionally.

## Commit granularity

- Never squash unrelated changes into a single commit.
- Split commits so that each one represents a single logical change (one feature, one bug fix, one refactor, etc.).
- A change and its directly related updates (e.g. the implementation and its tests, or code and the docs describing it) may go in the same commit.
- Formatting-only changes, dependency updates, and config changes should each be separate commits from functional changes.
- Each commit should ideally leave the repository in a working state.

## Commit message format

```
<prefix> <subject>

[optional body]
```

- Write the entire message in **English**.
- Subject: imperative mood, concise (aim for 50 characters or less), no trailing period.
  - Good: `feat: ✨ add user authentication`
  - Bad: `feat: ✨ Added user authentication.`
- Body (optional): explain *why* the change was made when it is not obvious from the subject.

### Prefixes

Choose exactly one prefix from this list. The emoji is part of the prefix and always follows the colon.

| Prefix | Use for |
|---|---|
| `feat: ✨` | Adding or modifying a feature |
| `add: ⚡️` | Adding something that is not a feature |
| `change: 💫` | Modifying something that is not a feature |
| `fix: 🐛` | Bug fix |
| `remove: 🔥` | Removing code or files |
| `style: 🎨` | Formatting / lint fixes (no logic change) |
| `docs: 📚` | Documentation |
| `refactor: ♻️` | Refactoring (no behavior change) |
| `perf: 🦄` | Performance improvement |
| `package: 📦` | Library / dependency changes |
| `test: ✅` | Adding or updating tests |
| `ci: 💚` | CI configuration |
| `revert: ⏪️` | Reverting a previous commit |
| `chore: 🩹` | Changes that do not affect production (task files, tooling, etc.) |
| `wip: 🚧` | Work in progress |

If a change seems to need multiple prefixes, that is a sign it should be split into multiple commits.
