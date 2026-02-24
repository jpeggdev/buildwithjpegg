---
name: draft-prs
description: Manages draft status for stacked PRs. Use when creating any PR in a stack (mark non-current PRs as draft), and when a base PR merges (promote the next PR to ready). Prevents reviewers from seeing PRs that depend on unmerged work.
---

# Draft PR Management

Controls draft status across a stacked PR chain so reviewers only see PRs that are ready.

## Rule

**Only the bottom-most unmerged PR in a stack should be `open` (ready for review).** All PRs above it must be `draft` until their base merges.

Example:
```
PR 12 feat/flow-creation       → OPEN (base is main, ready for review)
PR 13 feat/flow-node-editor    → DRAFT (base is PR 12, not yet merged)
PR 14 feat/flow-connections    → DRAFT (base is PR 13, not yet merged)
PR 15 feat/flow-variations     → DRAFT (base is PR 14, not yet merged)
```

After PR 12 merges:
```
PR 13 feat/flow-node-editor    → OPEN (rebased onto main, ready for review)
PR 14 feat/flow-connections    → DRAFT (still waiting)
PR 15 feat/flow-variations     → DRAFT (still waiting)
```

## When Creating a PR in a Stack

### The current base PR (ready for review)

```bash
gh pr create \
  --title "<title>" \
  --base <base-branch> \
  --body "$(cat <<'EOF'
## Summary
- <bullet>
- <bullet>

## Stack position
This is PR N of M in the `<feature-name>` stack.
Previous: #<prev-pr> | Next: #<next-pr> (draft)

## Test plan
- [ ] <verification step>
EOF
)"
```

Do NOT pass `--draft` for the current base PR.

### Downstream PRs (not yet ready for review)

```bash
gh pr create \
  --draft \
  --title "<title>" \
  --base <base-branch> \
  --body "$(cat <<'EOF'
## Summary
- <bullet>

## Stack position
This PR is **draft** -- waiting for #<base-pr> to merge first.
Stack: #<base-pr> → this PR → #<next-pr>

## Test plan
- [ ] <verification step>
EOF
)"
```

Always include the stack position context so reviewers understand the dependency.

## When a Base PR Merges

After the user reports a PR is merged:

1. **Identify the next PR** in the stack (first draft entry in `.claude/stack.json`)

2. **Rebase it onto main:**
   ```bash
   git fetch
   git checkout <next-branch>
   git rebase main
   git push --force-with-lease --force-if-includes
   ```

3. **Update its base on GitHub:**
   ```bash
   gh pr edit <next-pr-number> --base main
   ```

4. **Promote from draft to ready:**
   ```bash
   gh pr ready <next-pr-number>
   ```

5. **Update `.claude/stack.json`** via the `jpegg:pr-stack` skill

6. Report: "PR #<number> promoted to ready for review: <url>"

## Updating Stack Position Text in PR Bodies

When a PR moves from draft to ready, optionally update its description:

```bash
gh pr edit <number> --body "$(cat <<'EOF'
## Summary
<existing content>

## Stack position
Base: main (previously #<merged-pr>, now merged)

## Test plan
<existing content>
EOF
)"
```

This keeps the PR body accurate for reviewers who weren't watching from the start.

## Checking Current Draft Status

```bash
gh pr list --json number,title,isDraft,baseRefName,headRefName \
  --jq '.[] | "\(.number) \(if .isDraft then "[DRAFT]" else "[OPEN]" end) \(.headRefName) → \(.baseRefName) \(.title)"'
```

Use this to audit whether the stack matches the expected draft pattern.
