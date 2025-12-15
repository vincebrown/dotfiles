---
description: Commit changes with a well-crafted commit message
agent: build
---

You are committing changes to git.

## Step 1: Understand What to Commit

Parse $ARGUMENTS for any exclusions or instructions:
- If "everything except @path" or "exclude @path": stage all except those paths
- If specific files mentioned: only stage those files
- If no arguments: stage all changes

## Step 2: Check Current State

**Current branch**: !`git branch --show-current`
**Unstaged changes**: !`git status --short`

**CRITICAL**: If there are no changes to commit, STOP and respond:
```
No changes to commit. Working tree is clean.
```

## Step 3: Stage the Changes

Based on $ARGUMENTS:

**If excluding files**:
```bash
git add -A
git restore --staged <excluded-paths>
```

**If specific files**:
```bash
git add <specific-paths>
```

**If no arguments (commit everything)**:
```bash
git add -A
```

Verify what's staged:
!`git diff --cached --stat`

## Step 4: Analyze Changes for Commit Message

Review the staged diff to understand what changed:
!`git diff --cached`

Determine:
- **Type**: feat, fix, refactor, test, docs, chore, style, perf
- **Scope** (optional): affected module/component (e.g., auth, api, ui)
- **Summary**: what changed and why, in imperative mood

## Step 5: Write Commit Message

Follow conventional commit format:

```
<type>(<scope>): <summary>

<body - optional, for complex changes>
```

**Rules**:
- Summary in imperative mood ("add" not "added", "fix" not "fixed")
- Summary under 72 characters
- No period at end of summary
- Body explains WHY if not obvious from summary
- Reference issue numbers if applicable (e.g., "fixes #123")

**Type guide**:
- `feat`: new feature or capability
- `fix`: bug fix
- `refactor`: code change that neither fixes bug nor adds feature
- `test`: adding or updating tests
- `docs`: documentation only
- `chore`: maintenance, dependencies, config
- `style`: formatting, whitespace (no logic change)
- `perf`: performance improvement

**Examples**:
- `feat(auth): add password reset flow`
- `fix: prevent crash when user has no profile`
- `refactor(api): extract validation into middleware`
- `test: add unit tests for payment calculator`

## Step 6: Commit

```bash
git commit -m "<commit-message>"
```

**IMPORTANT**: 
- Do NOT add `--author` or co-author trailers
- Do NOT mention AI or assistant in the commit
- Just commit the changes as the user's work

## Step 7: Confirm

Show the result:
!`git log --oneline -1`
!`git status --short`

Report:
```
Committed: <commit-hash> <commit-message>

{summary of what was included}
```

## Completion Checklist

- [ ] Exclusions/inclusions from $ARGUMENTS handled
- [ ] Changes staged correctly
- [ ] Commit message follows conventional format
- [ ] Commit message is concise and meaningful
- [ ] No AI/assistant attribution added
- [ ] Commit successful
