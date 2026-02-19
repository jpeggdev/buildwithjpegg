---
name: pr-stack
description: Maintains .claude/stack.json tracking stacked PR state across sessions. Read at session start when working on a stacked feature. Update after every PR creation, merge, or rebase.
---

# Stack State

Manages `.claude/stack.json` -- the persistent record of stacked PR state across sessions.

## Current State
- Stack file: !`cat .claude/stack.json 2>/dev/null || echo "No stack file found"`
- Open PRs: !`gh pr list --json number,title,headRefName,baseRefName,isDraft,state 2>/dev/null`
- Current branch: !`git branch --show-current`

## Stack File Schema

```json
{
  "plan": "path/to/plan-document.md",
  "stack": [
    {
      "branch": "feat/flow-creation",
      "pr": 12,
      "base": "main",
      "status": "merged",
      "description": "Flow creation entry point and edit mode"
    },
    {
      "branch": "feat/flow-node-editor",
      "pr": 13,
      "base": "feat/flow-creation",
      "status": "open",
      "description": "Node canvas, 4 node types, drag/arrange/delete"
    },
    {
      "branch": "feat/flow-connections",
      "pr": 14,
      "base": "feat/flow-node-editor",
      "status": "draft",
      "description": "Output/input circles, bezier edge connections"
    }
  ]
}
```

**Status values:** `open` | `draft` | `merged` | `closed`

## Operations

### Read at session start

If `.claude/stack.json` exists:
1. Read the file
2. Show the current stack state as a summary table
3. Identify which PR is current (first non-merged entry)
4. Check that PR's actual status on GitHub matches the file

Report discrepancies and correct the file if needed.

### After creating a PR

Add an entry to the stack array:

```json
{
  "branch": "<branch name>",
  "pr": <PR number from gh pr create output>,
  "base": "<base branch>",
  "status": "open",  // or "draft" if created with --draft
  "description": "<one line summary>"
}
```

Write the updated file.

### After a PR is merged

1. Set that entry's `status` to `"merged"`
2. Find the next entry in the stack
3. Update its `base` to `"main"` (it will be rebased onto main)
4. Write the updated file
5. Trigger the post-merge rebase sequence (see `rules/workflow.md`)

### After rebasing a downstream branch

Update the entry's `base` field if it changed.

### Checking stack health

Compare each open/draft PR's base branch on GitHub against the stack file. Flag mismatches.

```bash
gh pr view <number> --json baseRefName -q '.baseRefName'
```

## Starting a fresh stack

When beginning a new stacked feature:

1. Create `.claude/stack.json` with `"stack": []`
2. Set `"plan"` to the path of the approved plan document
3. Add entries as PRs are created

If no `.claude` directory exists:

```bash
mkdir -p .claude
```

## Stack file location

Always `.claude/stack.json` relative to the repo root. Never in a subdirectory.
