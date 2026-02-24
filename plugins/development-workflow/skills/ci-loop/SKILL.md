---
name: ci-loop
description: Use after creating a PR to monitor CI and automatically fix failures before reporting back. Fires automatically after PR creation. Do not report the PR as ready until CI is green.
---

# CI Watch and Fix

**Announce at start:** "Monitoring CI for this PR -- will fix any failures before reporting back."

## Current PR Context
- Branch: !`git branch --show-current`
- Open PRs: !`gh pr list --head $(git branch --show-current) --json number,title,url,statusCheckRollup 2>/dev/null`

## Process

### Step 1: Wait for CI to start

```bash
gh run list --branch $(git branch --show-current) --limit 5
```

If no runs found yet, wait 15 seconds and retry. CI may not have triggered immediately after push.

### Step 2: Watch the run

```bash
# Get the most recent run ID
RUN_ID=$(gh run list --branch $(git branch --show-current) --limit 1 --json databaseId -q '.[0].databaseId')

# Watch it to completion
gh run watch $RUN_ID
```

### Step 3: Check the result

```bash
gh run view $RUN_ID --json conclusion -q '.conclusion'
```

**If `success`:** Report back. CI is green. PR is ready for review.

**If `failure`:** Proceed to Step 4.

**If `cancelled` or `skipped`:** Note it and report -- do not attempt to fix.

### Step 4: Diagnose the failure

```bash
# Get failed job details
gh run view $RUN_ID --log-failed
```

Read the full failure output. Identify:
- Which job failed
- The exact error message and file/line if available
- Whether it is a test failure, lint error, type error, or build error

### Step 5: Fix the failure

Apply the minimal fix. Do not refactor surrounding code.

For test failures: check if the test expectation is wrong (requirement changed) or the implementation is wrong. Fix the right one.

For lint/type errors: fix the specific violation only.

After fixing:

```bash
git add <changed files>
git commit -m "fix: address CI failure -- <brief description>"
git push
```

### Step 6: Repeat

Go back to Step 1. Watch the new run triggered by the push.

**Attempt limit:** After 3 fix attempts with continued failures, stop and report:

```
CI is still failing after 3 fix attempts.

Failing job: <name>
Error: <message>

Cannot resolve automatically -- needs your attention.
PR: <url>
```

## When CI is Green

Report back concisely:

```
CI passed. PR is ready for review: <url>
```

Do not summarize what was fixed unless asked.
