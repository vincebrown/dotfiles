---
description: Review local branch changes before pushing
agent: plan
---

You are reviewing your local branch changes before pushing for PR.

## Step 1: Gather Branch Context

**Current branch**: !`git branch --show-current`
**Base branch**: !`git remote show origin 2>/dev/null | grep 'HEAD branch' | cut -d' ' -f5 || echo "main"`

Fetch latest to ensure accurate comparison:
!`git fetch origin 2>/dev/null`

**Commits on this branch**:
!`git log --oneline origin/$(git remote show origin 2>/dev/null | grep 'HEAD branch' | cut -d' ' -f5 || echo "main")..HEAD 2>/dev/null || git log --oneline -10`

**Files changed**:
!`git diff --stat origin/$(git remote show origin 2>/dev/null | grep 'HEAD branch' | cut -d' ' -f5 || echo "main")..HEAD 2>/dev/null || git diff --stat HEAD~5`

**CRITICAL**: If no commits are shown above, STOP and respond:
```
No commits found on this branch compared to the base branch. Nothing to review.
```

## Step 2: Parallel Context Exploration

Launch 3 explorer subagents in parallel to gather context before detailed
review. Each agent should analyze the diff and provide their findings:

1. **Integration Explorer**: Map how changed files integrate with the rest of
   the codebase. Find all call sites, dependencies, and consumers of modified
   code.

2. **Pattern Explorer**: Find similar patterns and features elsewhere in the
   codebase. How do existing implementations handle similar concerns?

3. **Test Coverage Explorer**: Identify test coverage for modified code. Are
   there existing tests that need updates? What new tests are needed?

Provide each explorer with the branch context from Step 1 and the diff:
!`git diff origin/$(git remote show origin 2>/dev/null | grep 'HEAD branch' | cut -d' ' -f5 || echo "main")..HEAD 2>/dev/null || git diff HEAD~5`

For large diffs, also list changed files and read key files using the Read
tool to understand full context.

## Step 3: Parallel Specialized Review

Launch 4 code-reviewer subagents in parallel to independently review the
changes. Each agent should focus on their specialty and return only
high-confidence issues (≥80):

1. **Bugs & Logic Reviewer**: Focus on correctness, logic errors, off-by-one,
   null/undefined handling, race conditions, edge cases. Does the
   implementation solve the intended problem correctly?

2. **Security & Performance Reviewer**: Focus on security vulnerabilities,
   input validation, access controls, hardcoded secrets, N+1 queries,
   inefficient loops, resource leaks.

3. **Code Quality Reviewer**: Focus on readability, complexity, naming,
   function size, unnecessary complexity. Does this follow existing patterns
   in the codebase?

4. **AGENTS.md Compliance Reviewer**: Focus on adherence to project guidelines
   in AGENTS.md or similar files. Check import patterns, framework
   conventions, error handling, testing practices.

**CRITICAL**: Only report issues with confidence ≥80. Focus on high-signal
issues that truly matter. Do NOT flag:
- Pre-existing issues (only flag new problems in this diff)
- Subjective preferences or nitpicks
- Issues a linter will catch
- Style/formatting concerns

Provide each reviewer with:
- Branch context from Step 1
- Findings from explorers in Step 2
- The full diff
- Context from AGENTS.md or similar guideline files

## Step 4: Aggregate Review Findings

Collect and combine findings from all 7 subagents (3 explorers + 4
reviewers). Remove duplicate issues. Organize by severity and category.

## Step 5: Format Review Report

Present findings in this structure:

```markdown
# Branch Review: {branch-name}

**Commits**: {count} commits
**Files Changed**: {count} files (+{additions}/-{deletions})

## Summary

{2-3 paragraphs covering:
- What these changes accomplish
- Overall quality assessment
- Key concerns or highlights}

## Issues Found

{Bullet points with specific issues:
- File:line - description of issue
- Categorize as: bug, security, performance, maintainability}

If no issues: "No significant issues found."

## Suggestions

{Bullet points with improvements:
- Refactoring opportunities
- Missing tests
- Code simplifications}

If no suggestions: "Code looks good as-is."

## Ready to Push?

**Verdict**: READY | NEEDS WORK

{1-2 sentences on whether this is ready for PR or what should be addressed first}
```

## Completion Checklist

Before finishing, verify:
- [ ] Branch context was gathered (commits, files changed)
- [ ] 3 explorer agents launched in parallel (integration, patterns, tests)
- [ ] 4 reviewer agents launched in parallel (bugs, security, quality,
      guidelines)
- [ ] Findings aggregated and deduplicated
- [ ] Report follows the format with all sections
- [ ] Clear verdict given on readiness to push
