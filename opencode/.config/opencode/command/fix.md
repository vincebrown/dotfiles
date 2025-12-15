---
description: Quick fix for a known issue
agent: build
---

You are fixing: $ARGUMENTS

This command is for quick fixes where the problem is roughly known. For deeper investigation of unknown issues, use `/troubleshoot` instead.

## Step 1: Understand the Issue

Parse $ARGUMENTS to understand what needs fixing:
- Error message or type
- Behavior that's broken
- File or function mentioned
- Any context about when it happens

## Step 2: Locate the Problem

Based on $ARGUMENTS, find the relevant code:

**If error message provided**: Search for the error text or related code
**If file/function mentioned**: Read that file directly
**If behavior described**: Search for related keywords, component names, or API endpoints

Use Grep and Glob to find relevant files, then Read the key files.

## Step 3: Identify the Fix

Once you've found the problematic code:

1. Understand what's going wrong
2. Determine the minimal change needed
3. Consider edge cases the fix might affect

**Common quick fixes**:
- Missing null/undefined check
- Wrong condition or operator
- Missing await on async call
- Incorrect import/export
- Typo in property name
- Wrong function arguments
- Missing error handling

## Step 4: Apply the Fix

Make the change. Keep it minimal and focused.

**Guidelines**:
- Fix the immediate problem, don't refactor unrelated code
- If the fix reveals a larger issue, note it but stay focused
- Match the existing code style

## Step 5: Verify the Fix

Run tests to confirm the fix works:

**Check for test command**:
!`test -f Makefile && grep -E '^test' Makefile | head -3 || echo ""`
!`test -f package.json && cat package.json | grep -A5 '"scripts"' | grep test | head -3 || echo ""`

Run the relevant tests:
```bash
# Use appropriate command based on what exists
make test file={test-file}
npm test -- {test-file}
go test ./...
```

**If no tests exist**: Note this and suggest the user manually verify.

## Step 6: Report the Fix

```markdown
## Fixed

**Issue**: {brief description of what was broken}
**Cause**: {what was causing it}
**Fix**: {what you changed}
**Location**: `{file}:{line}`

**Verified**: {tests pass / needs manual verification}
```

If the fix revealed larger issues worth addressing:
```
**Note**: While fixing this, I noticed {observation}. Consider addressing this separately.
```

## Completion Checklist

- [ ] Issue understood from $ARGUMENTS
- [ ] Relevant code located
- [ ] Root cause identified
- [ ] Minimal fix applied
- [ ] Fix verified (tests or noted for manual check)
- [ ] Results reported
