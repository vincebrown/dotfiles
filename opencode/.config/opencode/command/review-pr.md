---
description: Thorough PR review focused on quality, maintainability, and goal achievement
agent: plan
---

You are reviewing the pull request: $ARGUMENTS

This is an internal review - do NOT post comments or submit reviews to GitHub. Your analysis will be returned directly to the user.

## Step 1: Fetch PR Metadata

Use GitHub CLI or GitHub MCP to get PR information:
!`gh pr view $ARGUMENTS --json number,title,body,author,baseRefName,headRefName,additions,deletions,changedFiles,state`

**PR Summary:**
- Number: {extract from above}
- Title: {extract from above}
- Author: {extract from above}
- Base ← Head: {extract from above}
- Changes: +{additions}/-{deletions} across {changedFiles} files
- State: {extract from above}

## Step 2: Get PR Diff and Context

Fetch the PR diff for review:
!`gh pr diff $ARGUMENTS`

For large PRs (≥ 10 files or ≥ 500 lines changed), also:
- List changed files: `!gh pr diff $ARGUMENTS --name-only`
- Read key changed files using the Read tool to understand full context
- Review the complete implementation, not just the diff

**CRITICAL**: For large PRs, you MUST read the full files to understand:
- Surrounding context and existing patterns
- How changes integrate with the broader codebase
- Whether the implementation follows established conventions
- Full impact of the changes, not just isolated hunks

## Step 3: Understand PR Intent

Read the PR description and analyze what problem this PR aims to solve:
- What is the stated goal or feature being implemented?
- Are there linked issues or tickets referenced?
- What acceptance criteria or requirements are mentioned?
- What testing has been described?

Parse the PR body from Step 1 to extract this context.

## Step 4: Parallel Context Exploration

Launch 3 explorer subagents in parallel to gather context before detailed
review. Each agent should analyze the PR diff and provide their findings:

1. **Integration Explorer**: Map how changed files integrate with the rest of
   the codebase. Find all call sites, dependencies, and consumers of modified
   code.

2. **Pattern Explorer**: Find similar patterns and features elsewhere in the
   codebase. How do existing implementations handle similar concerns?

3. **Test Coverage Explorer**: Identify test coverage for modified code. Are
   there existing tests that need updates? What new tests are needed?

Provide each explorer with:
- PR metadata from Step 1 (title, description, author)
- The diff from Step 2
- For large PRs, context from reading full files

## Step 5: Parallel Specialized Review

Launch 4 code-reviewer subagents in parallel to independently review the
changes. Each agent should focus on their specialty and return only
high-confidence issues (≥80):

1. **Bugs & Logic Reviewer**: Focus on correctness, logic errors, off-by-one,
   null/undefined handling, race conditions, edge cases. Does the
   implementation solve the stated problem correctly? Are boundary conditions
   handled?

2. **Security & Performance Reviewer**: Focus on security vulnerabilities,
   input validation, access controls, hardcoded secrets, authentication/
   authorization, N+1 queries, inefficient algorithms, resource leaks.

3. **Code Quality Reviewer**: Focus on readability, maintainability, structure,
   naming, complexity. Will future developers easily understand and modify
   this? Does this follow existing patterns in the codebase?

4. **AGENTS.md Compliance Reviewer**: Focus on adherence to project guidelines
   in AGENTS.md or similar files. Check import patterns, framework
   conventions, error handling, testing practices, documentation standards.

**CRITICAL**: Only report issues with confidence ≥80. Focus on high-signal
issues that truly matter. Do NOT flag:
- Pre-existing issues (only flag new problems in this PR)
- Subjective preferences or nitpicks
- Issues a linter will catch
- Style/formatting concerns
- General suggestions without clear impact

Provide each reviewer with:
- PR metadata from Step 1 (title, description, author, intent)
- Findings from explorers in Step 4
- The full diff from Step 2
- Context from AGENTS.md or similar guideline files

## Step 6: Assess Goal Achievement

Collect and combine findings from all 7 subagents (3 explorers + 4 reviewers).
Remove duplicate issues. Organize by category.

Compare the implementation against the stated intent from Step 3:
- Does this PR fully achieve what it set out to do?
- Are there gaps between intent and implementation?
- Is the scope appropriate or is this trying to do too much?
- Should this be broken into smaller PRs?

## Step 7: Format Review Report

Present your findings in this exact structure:

```markdown
# PR Review: {title}

**PR**: {url}
**Author**: {author}
**Size**: {additions} additions, {deletions} deletions across {changedFiles} files

## Summary

{2-4 paragraphs covering:
- What this PR does and why
- Overall code quality assessment
- Whether it achieves its stated goals
- Key concerns or highlights
- Maintainability and future impact}

## The Good

{Bullet points highlighting:
- What was done well
- Strong implementations or patterns
- Good practices followed
- Clever solutions to complex problems}

## The Bad

{Bullet points identifying issues:
- Bugs or logic errors
- Security vulnerabilities
- Performance concerns
- Maintainability issues
- Missing error handling
- Technical debt being added}

**Note**: If there are no significant issues, state "No major issues identified."

## Suggestions

{Bullet points with improvement recommendations:
- Refactoring opportunities
- Alternative approaches
- Missing test coverage
- Documentation improvements
- Code simplifications}

**Note**: If there are no suggestions, state "No significant improvements needed."

## Recommendation

**Decision**: APPROVE | REQUEST CHANGES | COMMENT
**Confidence**: {percentage}%

**Reasoning**: {1-2 sentences explaining your recommendation and confidence level}

---

**Next Steps**: {What should happen next - merge, address issues, split PR, etc.}
```

## Completion Criteria

Before finishing, verify:
- [ ] PR metadata was fetched successfully
- [ ] PR diff was retrieved
- [ ] PR intent was understood from description
- [ ] 3 explorer agents launched in parallel (integration, patterns, tests)
- [ ] 4 reviewer agents launched in parallel (bugs, security, quality,
      guidelines)
- [ ] Findings aggregated and deduplicated
- [ ] Goal achievement was assessed
- [ ] Report follows the exact format with all sections
- [ ] Recommendation is clear with confidence score
- [ ] Review was NOT submitted to GitHub (internal only)
