---
description: Write and run tests for files changed on current branch
agent: build
---

You are writing tests for changes on the current branch.

## Step 1: Identify Changed Files

**Current branch**: !`git branch --show-current`
**Base branch**: !`git remote show origin 2>/dev/null | grep 'HEAD branch' | cut -d' ' -f5 || echo "main"`

Get files changed on this branch (excluding test files):
!`git diff --name-only origin/$(git remote show origin 2>/dev/null | grep 'HEAD branch' | cut -d' ' -f5 || echo "main")..HEAD | grep -v -E '\.(test|spec)\.(ts|tsx|js|jsx)$' | grep -E '\.(ts|tsx|js|jsx|go|py)$'`

**CRITICAL**: If no files are shown above, STOP and respond:
```
No source files changed on this branch. Nothing to test.
```

## Step 2: Determine Test Runner

Check for test commands in order of preference:

**1. Check Makefile first**:
!`test -f Makefile && grep -E '^test|^unit-test|^integration-test' Makefile | head -5 || echo "No Makefile test targets"`

**2. Check package.json scripts**:
!`test -f package.json && cat package.json | grep -A 20 '"scripts"' | grep -E 'test|jest|vitest|mocha' | head -5 || echo "No package.json test scripts"`

**3. Check for Go**:
!`test -f go.mod && echo "Go project - use: go test ./..." || echo ""`

Determine the test command to use:
- If Makefile has `test` target with file param (e.g., `make test file=`): use that
- If package.json has test script: use `npm test` or the specific script
- If Go project: use `go test`
- **Last resort only**: `npx jest` or `npx vitest`

Store the test command for use in Step 5.

## Step 3: Study Existing Test Patterns

Find existing test files to understand conventions:
!`find . -name "*.test.*" -o -name "*.spec.*" | grep -v node_modules | head -5`

Read 1-2 existing test files to understand:
- Import patterns and test utilities used
- Describe/it structure or test function naming
- Mocking patterns (how are dependencies mocked?)
- Assertion style (expect, assert, etc.)
- Setup/teardown patterns

**Key conventions to follow**:
- Match the existing test file naming convention (`.test.ts` vs `.spec.ts`)
- Match the test file location convention (co-located vs `__tests__` folder)
- Use the same testing library and assertion style
- Follow the same mocking approach

## Step 4: Build Test Plan

For each changed source file, determine:

1. **Corresponding test file**: Does it exist? Where should it be?
2. **What to test**: Focus on important implementation details, not trivial getters/setters
3. **Action needed**: Create new test file OR update existing tests

Create a checklist:
```
Files needing tests:
- [ ] src/utils/parser.ts → src/utils/parser.test.ts (CREATE)
- [ ] src/hooks/useAuth.ts → src/hooks/useAuth.test.ts (UPDATE - add tests for new logout flow)
- [ ] src/api/client.ts → src/api/client.test.ts (UPDATE - add error handling tests)
```

## Step 5: Write and Run Tests (one file at a time)

For each file in the checklist:

### 5a. Write the test file

**Guidelines**:
- Keep tests concise - test behavior, not implementation details
- No comments unless explaining non-obvious test setup
- One logical assertion per test (can have multiple expects if testing one behavior)
- Test the important paths: happy path, error cases, edge cases
- Mock external dependencies, don't mock the unit under test

### 5b. Run the test

Run tests for just this file using the command from Step 2:
```bash
# Examples based on what was found:
make test file=src/utils/parser.test.ts
npm test -- src/utils/parser.test.ts
go test ./src/utils/...
```

### 5c. Verify it passes

- If tests pass: mark the checklist item complete, move to next file
- If tests fail: fix the test or identify a bug in the implementation, then re-run

**CRITICAL**: Do not move to the next file until current tests pass.

## Step 6: Final Verification

Run the full test suite to ensure nothing is broken:
```bash
# Use the appropriate command from Step 2
make test
npm test
go test ./...
```

Report results:
```
Test Summary:
- Files tested: {count}
- Tests written: {count new tests}
- Tests updated: {count updated tests}
- All tests passing: YES/NO

{If any failures, list them with file:line references}
```

## Completion Checklist

- [ ] Changed files identified from branch diff
- [ ] Test runner command determined (Makefile → package.json → fallback)
- [ ] Existing test patterns studied
- [ ] Test plan created with specific files
- [ ] Tests written/updated for each changed file
- [ ] Each test file runs and passes individually
- [ ] Full test suite passes
