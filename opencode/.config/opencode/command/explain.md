---
description: Explain how something works in the codebase
agent: plan
---

You are explaining: $ARGUMENTS

## Step 1: Determine What to Explain

Parse $ARGUMENTS to understand what needs explanation:

- **If a file/path is given** (e.g., `@src/hooks/useAuth.ts`): Explain that specific code
- **If a concept is given** (e.g., "authentication flow"): Find and explain relevant code
- **If a feature is given** (e.g., "how search works"): Trace the full implementation

## Step 2: Find the Relevant Code

Use Glob and Grep to locate all relevant files:

1. Find entry points (where it starts)
2. Find core logic (where the work happens)
3. Find related files (helpers, types, tests)

Read the key files to understand the implementation.

## Step 3: Trace the Flow

For the code you're explaining, trace how it works:

1. **Entry point**: Where does execution start? (API route, event handler, component mount)
2. **Data flow**: What data comes in? How is it transformed?
3. **Core logic**: What decisions are made? What are the key functions?
4. **Side effects**: What external calls happen? (DB, API, state updates)
5. **Output**: What gets returned or rendered?

## Step 4: Explain Concisely

Present the explanation in this format:

```markdown
# How {thing} Works

## Overview
{1-2 sentences on what this does and why it exists}

## Key Files
- `path/to/entry.ts` - {role}
- `path/to/core.ts` - {role}
- `path/to/helper.ts` - {role}

## How It Works

{2-4 paragraphs explaining the flow, referencing specific files and line numbers}

### Key Points
- {important detail 1}
- {important detail 2}
- {gotcha or non-obvious behavior}

## Example Usage
{show how this is used in practice, with code if helpful}
```

## Guidelines

- **Be concise** - explain what's needed, not everything possible
- **Reference specific code** - use `file:line` format
- **Focus on the "why"** - not just what, but why it's designed this way
- **Surface gotchas** - non-obvious behavior the user should know
- **Skip the obvious** - don't explain basic language features

## Completion Checklist

- [ ] Relevant code located
- [ ] Flow traced from entry to output
- [ ] Key files identified with their roles
- [ ] Core logic explained with file:line references
- [ ] Important gotchas or non-obvious behavior noted
