---
description: Debug and fix an issue with systematic investigation
agent: plan
---

You are debugging: $ARGUMENTS

## Step 1: Understand the Problem

Parse $ARGUMENTS to understand what's broken:
- If an error message is provided, note the exact error
- If a behavior is described, note expected vs actual behavior
- If a file/function is mentioned, that's the starting point

**Recent changes** (might have caused this):
!`git log --oneline -10`

## Step 2: Reproduce the Issue

Before debugging, confirm you can reproduce the problem:

1. If there's a test that should catch this, run it:
   - Check Makefile for test commands: `!cat Makefile | grep -E '^test' | head -3`
   - Or use package.json scripts

2. If no test exists, ask the user for reproduction steps if not clear from $ARGUMENTS

**CRITICAL**: If you cannot reproduce the issue, STOP and ask the user for more details:
```
I need more information to reproduce this issue:
- What steps trigger the problem?
- What do you expect to happen?
- What actually happens?
```

## Step 3: Locate the Problem

Use search tools to find relevant code:

1. **If error message provided**: Search for the error text in the codebase
2. **If function/file mentioned**: Read that file and trace the logic
3. **If behavior described**: Search for related keywords, function names, or UI text

Trace the code path:
- Find the entry point (API endpoint, event handler, component)
- Follow the data flow through the system
- Identify where the actual behavior diverges from expected

## Step 4: Identify Root Cause

Once you've located the problematic code, determine WHY it's failing:

**Common causes to check:**
- Logic error (wrong condition, off-by-one, incorrect operator)
- Missing null/undefined check
- Async/timing issue (race condition, missing await)
- Incorrect data transformation
- State not being updated correctly
- External dependency returning unexpected data

Document your finding:
```
Root Cause: {description}
Location: {file:line}
Why: {explanation of why this causes the observed behavior}
```

## Step 5: Implement the Fix

Make the minimal change needed to fix the issue:

1. Fix the code at the identified location
2. If the fix requires changes in multiple places, list them all first
3. Prefer simple, obvious fixes over clever ones

## Step 6: Verify the Fix

Run the reproduction steps again to confirm the fix works:

1. Run the specific test (if one exists)
2. Run related tests to check for regressions
3. If no tests, manually verify the fix

```bash
# Run tests using the command found in Step 2
make test file={test-file}
# or
npm test -- {test-file}
```

**If tests fail**: Re-examine the fix, you may have missed something or introduced a regression.

## Step 7: Report Results

```markdown
## Issue Fixed

**Problem**: {brief description of what was broken}
**Root Cause**: {what was causing it}
**Fix**: {what you changed}
**Location**: {file:line}

**Verified by**: {how you confirmed it works}
```

## Completion Checklist

- [ ] Problem understood and reproduced
- [ ] Relevant code located
- [ ] Root cause identified with file:line reference
- [ ] Fix implemented
- [ ] Fix verified (tests pass or manual verification)
- [ ] Results reported
