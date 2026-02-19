# buildwithjpegg

A complete software development workflow for your coding agents, built on composable skills and automatic invocation.

## How it works

When you fire up your coding agent, it doesn't just jump into writing code. Instead, it steps back and asks what you're really trying to do.

Once it's teased a spec out of the conversation, it shows it to you in chunks short enough to actually read and digest.

After you've signed off on the design, your agent puts together an implementation plan that's clear enough for an enthusiastic junior engineer with no project context to follow. It emphasizes true red/green TDD, YAGNI, and DRY.

Next, it launches a task delegation process, having agents work through each engineering task, inspecting and reviewing their work, and continuing forward.

Because the skills trigger automatically, you don't need to do anything special.

## Installation

**Note:** Installation differs by platform. Claude Code has a built-in plugin system. Codex and OpenCode require manual setup.

### Claude Code (via Plugin Marketplace)

In Claude Code, register the marketplace first:

```bash
/plugin marketplace add buildwithjpegg/buildwithjpegg-marketplace
```

Then install the plugin:

```bash
/plugin install buildwithjpegg@buildwithjpegg-marketplace
```

### Verify Installation

Start a new session and ask Claude to help with something that would trigger a skill (e.g., "help me plan this feature" or "let's debug this issue"). Claude should automatically invoke the relevant skill.

### Codex

Tell Codex:

```
Fetch and follow instructions from https://raw.githubusercontent.com/buildwithjpegg/buildwithjpegg/refs/heads/main/.codex/INSTALL.md
```

**Detailed docs:** [.codex/INSTALL.md](.codex/INSTALL.md)

### OpenCode

Tell OpenCode:

```
Fetch and follow instructions from https://raw.githubusercontent.com/buildwithjpegg/buildwithjpegg/refs/heads/main/.opencode/INSTALL.md
```

**Detailed docs:** [.opencode/INSTALL.md](.opencode/INSTALL.md)

## The Basic Workflow

1. **evaluate** - Activates before writing code. Refines rough ideas through questions, explores alternatives, presents design in sections for validation. Saves design document.

2. **worktree** - Activates after design approval. Creates isolated workspace on new branch, runs project setup, verifies clean test baseline.

3. **blueprint** - Activates with approved design. Breaks work into bite-sized tasks (2-5 minutes each). Every task has exact file paths, complete code, verification steps.

4. **delegate** or **build** - Activates with plan. Dispatches fresh subagent per task with two-stage review (spec compliance, then code quality), or executes in batches with human checkpoints.

5. **test-first** - Activates during implementation. Enforces RED-GREEN-REFACTOR: write failing test, watch it fail, write minimal code, watch it pass, commit.

6. **seek-review** - Activates between tasks. Reviews against plan, reports issues by severity. Critical issues block progress.

7. **wrap-up** - Activates when tasks complete. Verifies tests, presents options (merge/PR/keep/discard), cleans up worktree.

**The agent checks for relevant skills before any task.** Mandatory workflows, not suggestions.

## What's Inside

### Skills Library

**Testing**
- **test-first** - RED-GREEN-REFACTOR cycle (includes testing anti-patterns reference)

**Debugging**
- **root-cause** - 4-phase root cause process (includes root-cause-tracing, defense-in-depth, condition-based-waiting techniques)
- **pre-ship** - Ensure it's actually fixed

**Collaboration**
- **evaluate** - Socratic design refinement
- **blueprint** - Detailed implementation plans
- **build** - Batch execution with checkpoints
- **fan-out** - Concurrent subagent workflows
- **seek-review** - Pre-review checklist
- **handle-review** - Responding to feedback
- **worktree** - Parallel development branches
- **wrap-up** - Merge/PR decision workflow
- **delegate** - Fast iteration with two-stage review (spec compliance, then code quality)

**CI/CD**
- **ci-loop** - Monitor CI and automatically fix failures after PR creation
- **draft-prs** - Manage draft status for stacked PRs
- **pr-stack** - Track stacked PR state across sessions
- **auto-release** - Set up semantic versioning and automated releases

**Meta**
- **craft-skill** - Create new skills following best practices (includes testing methodology)
- **onboard** - Introduction to the skills system

## Philosophy

- **Test-Driven Development** - Write tests first, always
- **Systematic over ad-hoc** - Process over guessing
- **Complexity reduction** - Simplicity as primary goal
- **Evidence over claims** - Verify before declaring success

## Updating

Skills update automatically when you update the plugin:

```bash
/plugin update buildwithjpegg
```

## Acknowledgment

buildwithjpegg is based on [superpowers](https://github.com/obra/superpowers) by Jesse Vincent, licensed under the MIT License. See [LICENSE](LICENSE) for details.

## License

MIT License - see [LICENSE](LICENSE) for details.

## Support

- **Issues**: https://github.com/buildwithjpegg/buildwithjpegg/issues
