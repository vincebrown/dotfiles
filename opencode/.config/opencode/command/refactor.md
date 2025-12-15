---
description: Refactor code for readability and maintainability
agent: build
---

You are refactoring: $ARGUMENTS

## Refactoring Principles

**Code is for humans.** Always prioritize:
- **Clarity over cleverness** - readable code beats compact code
- **Explicit over implicit** - make intent obvious
- **Idiomatic code** - follow language/framework conventions
- **Maintainability** - future developers should understand this easily

## Step 1: Identify the Target

Parse $ARGUMENTS to determine what to refactor:
- If a file path: refactor that file
- If a function/method name: find and refactor that function
- If a module/service: refactor the core files in that module
- If a description (e.g., "the auth logic"): search and identify relevant code

Locate the target code and read it fully.

## Step 2: Study the Context

Before changing anything, understand:

1. **How is this code used?** - Find callers/consumers with Grep
2. **What are the existing patterns?** - Read similar code in the repo
3. **Are there tests?** - Find related test files

This ensures refactoring won't break consumers and will match repo conventions.

## Step 3: Identify Refactoring Opportunities

Analyze the code for these improvements:

### Readability
- **Naming**: Do names clearly describe purpose? (variables, functions, classes)
- **Function length**: Can long functions be broken into smaller, focused ones?
- **Nesting depth**: Can deeply nested code be flattened? (early returns, guard clauses)
- **Comments**: Is there commented code to remove? Are comments explaining "what" instead of "why"?

### Structure
- **Single responsibility**: Does each function/class do one thing?
- **Duplication**: Is there repeated logic that should be extracted?
- **Abstraction level**: Are high-level and low-level concerns mixed?
- **Dead code**: Is there unused code to remove?

### Idioms & Best Practices
- **Language idioms**: Is the code idiomatic for the language? (e.g., map/filter vs manual loops in JS)
- **Framework patterns**: Does it follow framework conventions?
- **Error handling**: Is error handling clear and consistent?
- **Type safety**: Can types be improved for better safety?

Create a list of specific improvements to make.

## Step 4: Refactor Incrementally

**CRITICAL**: Make one change at a time, verify after each.

For each improvement:

1. **Make the change** - Apply a single, focused refactor
2. **Verify it works** - Run tests or type check
3. **Move to next** - Only proceed if previous change is solid

```bash
# After each change, verify:
# Check for type errors
npx tsc --noEmit
# Or run tests
make test file={relevant-test}
npm test -- {relevant-test}
```

**If tests fail**: Fix or revert before continuing.

### Common Refactoring Patterns

**Extract function** - Pull out a block of code into a named function
```
# Before: inline logic
# After: descriptive function name explains intent
```

**Early return / Guard clauses** - Reduce nesting
```
# Before: if (valid) { ...lots of code... }
# After: if (!valid) return; ...code at root level...
```

**Rename for clarity** - Names should describe what, not how
```
# Before: const d = getData()
# After: const userProfile = fetchUserProfile()
```

**Simplify conditionals** - Make logic obvious
```
# Before: if (!(!isAdmin && !isOwner))
# After: if (isAdmin || isOwner)
```

**Remove dead code** - Delete unused functions, variables, imports

## Step 5: Final Verification

After all refactors:

1. Run the full test suite for affected areas
2. Verify no type errors
3. Check that behavior is unchanged

```bash
# Run related tests
make test
npm test
```

## Step 6: Summarize Changes

```markdown
## Refactoring Complete

**Target**: {what was refactored}

### Changes Made
- {change 1}: {why it improves the code}
- {change 2}: {why it improves the code}
- ...

### Files Modified
- `path/to/file.ts` - {brief description}

### Verified
- [ ] Tests pass
- [ ] No type errors
- [ ] Behavior unchanged
```

## Completion Checklist

- [ ] Target code identified and fully read
- [ ] Context understood (callers, patterns, tests)
- [ ] Refactoring opportunities identified
- [ ] Changes made incrementally with verification
- [ ] Code is now more readable and maintainable
- [ ] Tests pass, no regressions
- [ ] Changes summarized
