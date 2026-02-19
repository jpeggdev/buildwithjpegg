# Development Workflow

## Skill Invocation Sequence

For any new feature or fix, skills fire in this order — do not skip steps:

1. **`jpegg:evaluate`** — always first. Explores intent, asks clarifying questions, surfaces unstated requirements. Fires when a feature or fix is described.
2. **`jpegg:blueprint`** — after evaluation. Produces the plan document. User reviews and approves before any code is written.
3. **`jpegg:build`** — after plan approval. Works through the plan with PR-level checkpoints. One PR per logical chunk.

Within each implementation chunk:

4. **`jpegg:worktree`** — before writing code. Creates an isolated workspace for the branch.
5. **`jpegg:test-first`** — before writing implementation code. Tests first, always.
6. **`jpegg:pre-ship`** — before claiming done. Runs verification commands, reads actual output.
7. **`jpegg:seek-review`** — before opening the PR. Internal review pass first.
8. **`jpegg:draft-prs`** — when creating a PR in a stack. Downstream PRs are draft; promote on base merge.
9. **`jpegg:ci-loop`** — after PR creation. Monitors CI and fixes failures before reporting back.
10. **`jpegg:pr-stack`** — after every PR creation or merge. Updates `.claude/stack.json`.

When receiving feedback on an open PR:

11. **`jpegg:handle-review`** — fires before implementing any review comment. Evaluates feedback before acting.

## Stacked PR Workflow

- Each branch is created from the tip of the previous branch, not from `main`
- Each PR targets the previous branch as its base, not `main`
- Downstream PRs are always created as drafts until their base merges
- When a base merges: rebase the next branch, update its PR base to `main`, promote from draft to ready
- Session state is tracked in `.claude/stack.json` — read this at session start if it exists

## Resuming After a Break

1. Read `.claude/stack.json` to understand current stack state
2. Read the plan document referenced in the stack file
3. Check open PRs with `gh pr list`
4. Continue from the current branch

## After a PR is Merged

When the user reports a PR is merged:
1. `git fetch`
2. Rebase the next branch in the stack onto `main`
3. `git push --force-with-lease --force-if-includes`
4. Update the PR base on GitHub: `gh pr edit <number> --base main`
5. Promote from draft: `gh pr ready <number>`
6. Update `.claude/stack.json`
