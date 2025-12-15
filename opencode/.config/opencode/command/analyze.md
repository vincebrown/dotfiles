---
description: Deep-dive analysis of a specific feature or module
agent: plan
---

You are analyzing $ARGUMENTS to understand how it works before making changes.

## Step 1: Identify the Target

Parse $ARGUMENTS to determine what to analyze:
- If a path is provided (e.g., `@src/modules/care-search`), analyze that directory/file
- If a feature name is provided (e.g., "authentication flow"), search for relevant code

**Target**: $ARGUMENTS

## Step 2: Map the Module Structure

Use Glob and Read tools to understand the module:

1. **List all files** in the target directory
2. **Identify entry points** - main exports, index files, public APIs
3. **Find the core files** - where the main logic lives

Build a file tree of the module showing what each file is responsible for.

## Step 3: Trace Dependencies

For the target module, identify:

**Internal dependencies** (within the module):
- How do files within this module import each other?
- What's the dependency hierarchy?

**External dependencies** (outside the module):
- What does this module import from elsewhere in the codebase?
- What external packages does it use?

**Consumers** (who uses this module):
- Use Grep to find imports of this module across the codebase
- Which other modules/features depend on this one?

## Step 4: Understand the Implementation

Read the key files and document:

### Public API
- What functions/components/classes are exported?
- What are the input/output contracts?
- Are there TypeScript types or schemas that define the interface?

### Core Logic
- What's the main flow or algorithm?
- What are the key data structures?
- Where does state live (if applicable)?

### Side Effects
- Database queries or mutations
- API calls to external services
- File system operations
- Event emissions or subscriptions

### Error Handling
- How are errors caught and propagated?
- What failure modes exist?

## Step 5: Identify Patterns & Gotchas

Note anything important for someone about to work on this:

- **Patterns used** - specific conventions or abstractions in this module
- **Non-obvious behavior** - things that might surprise you
- **Known limitations** - technical debt, TODOs, or workarounds
- **Testing approach** - how is this module tested?

## Step 6: Write Analysis Report

Create the `.ai-docs/` directory if it doesn't exist, then write the analysis to a file.

**Filename**: Derive from the target - e.g., `src/modules/care-search` becomes `care-search.md`

Write the report to `.ai-docs/{module-name}.md` using the Write tool:

```markdown
# Module Analysis: {name}

**Location**: {path}
**Purpose**: {1-2 sentence description of what this module does}
**Analyzed**: {current date}

## File Structure

{tree view with brief description of each file's role}

## Public API

{list of exports with brief descriptions}
- `functionName(params)` - what it does
- `ComponentName` - what it renders/handles

## Key Dependencies

**Uses**: {list of key imports from outside the module}
**Used by**: {list of modules that import this one}

## How It Works

{2-4 paragraphs explaining the core flow/logic}

## Important Notes

{bullet points of gotchas, patterns, or things to know before modifying}

## Suggested Reading Order

{numbered list of files to read to understand the module, in order}
```

After writing, confirm to the user:
```
Analysis written to .ai-docs/{module-name}.md

Tip: Add `.ai-docs/` to your .gitignore if you haven't already.
```

## Completion Checklist

- [ ] Target module identified and located
- [ ] File structure mapped
- [ ] Dependencies traced (internal, external, consumers)
- [ ] Public API documented
- [ ] Core logic explained
- [ ] Patterns and gotchas noted
- [ ] Report written to `.ai-docs/{module-name}.md`
