---
description: Create a pull request with template-compliant description
agent: build
---

You are creating a pull request titled "$ARGUMENTS".

**Current branch**: !`git branch --show-current`
**Repository**: !`gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || echo "unknown"`

First, determine the base branch (usually main or master):
!`git remote show origin | grep 'HEAD branch' | cut -d' ' -f5`

Store this as the base branch for all subsequent commands.

## Step 1: Verify Clean Working Tree

Check for uncommitted changes:
!`git status --short`

**CRITICAL**: If the output above shows any uncommitted changes, STOP immediately and respond:
```
There are uncommitted changes on this branch. Would you like me to commit these changes first?
```

Do NOT proceed to Step 2 until the working tree is clean.

## Step 2: Review Commits Thoroughly

You must build a complete understanding of what changed and why before writing the PR description.

First, fetch the latest base branch:
!`git fetch origin`

**Commits on this branch** (comparing current branch to origin/{base}):
!`git log --oneline origin/$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)..HEAD`

**CRITICAL**: If the output above is empty, STOP and respond:
```
You are currently on the base branch or have no commits to open a PR with. Please create commits on a feature branch first.
```

**Files changed**:
!`git diff --stat origin/$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)..HEAD`

**Detailed changes**:
!`git diff origin/$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)..HEAD`

Analyze the commits and changes above to determine:
- **What** was changed (features added, bugs fixed, refactoring done)
- **Why** these changes were made (the problem being solved)
- **How** the changes work (key implementation details if non-obvious)
- **Impact** on the codebase (breaking changes, new dependencies, etc.)

## Step 3: Push Branch to GitHub

Check if the branch has been pushed:
!`git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null`

If the command above failed or shows the branch is ahead, push it:
```bash
git push -u origin $(git branch --show-current)
```

Verify the push succeeded:
!`git status -sb`

## Step 4: Determine Target Repository

**Target repository**: !`gh repo view --json nameWithOwner -q .nameWithOwner`
**Base branch**: !`git remote show origin | grep 'HEAD branch' | cut -d' ' -f5`
**Current branch**: !`git branch --show-current`

You will open a PR against the repository and base branch identified above. Proceed to Step 5.

## Step 5: Build PR Description

Check if a PR template exists at `.github/PULL_REQUEST_TEMPLATE.md`:
!`test -f .github/PULL_REQUEST_TEMPLATE.md && cat .github/PULL_REQUEST_TEMPLATE.md || echo "No template found"`

**If template exists**:
- Read the template structure carefully
- Fill in each section based on your analysis from Step 2
- Preserve all section headers and formatting from the template
- Mark sections as "N/A" only if genuinely not applicable
- Do NOT duplicate information already in the PR title

**If no template exists**, use this structure:
```markdown
## Summary
{2-4 concise bullet points describing what changed and why}

## Changes
{List key changes organized by category: features, fixes, refactoring, etc.}

## Testing
{Describe testing performed, or state "Manual testing required" if not yet tested}
```

## Step 6: Create Pull Request

Create the PR using GitHub CLI:
```bash
gh pr create \
  --title "$ARGUMENTS" \
  --body "{PR_DESCRIPTION_FROM_STEP_5}" \
  --base {base-branch} \
  --head {current-branch}
```

If `gh` CLI is unavailable, use GitHub MCP server's `createPullRequest` tool with the same parameters.

Capture the PR URL from the command output.

## Step 7: Report Results

Retrieve full PR details:
!`gh pr view --json url,number,title,baseRefName,headRefName,body`

Present a summary to the user:
```
✓ Pull Request Created

PR #{number}: {title}
URL: {url}
Base: {baseRefName} ← Head: {headRefName}
Commits: {count from Step 2}

Description:
{first 3-5 lines of PR body}
```

Include the full PR URL so the user can click directly to the GitHub PR page.

## Completion Checklist

Before considering this command complete, verify:
- [ ] Working tree was clean (or user committed changes)
- [ ] All commits on the branch were reviewed and understood
- [ ] Branch was pushed to GitHub successfully
- [ ] User confirmed target repository and base branch
- [ ] PR description follows template (if exists) or standard structure
- [ ] PR was created successfully via `gh` CLI or GitHub MCP
- [ ] Full summary with PR URL was provided to user
