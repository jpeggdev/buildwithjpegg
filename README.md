# buildwithjpegg Marketplace

A plugin marketplace for Claude Code. Browse, install, and manage plugins for development workflows and AI code planning and reviews.

## Getting Started

Register the marketplace in Claude Code:

```bash
/plugin marketplace add jpeggdev/buildwithjpegg
```

Then install any plugin:

```bash
/plugin install development-workflow
```

## Available Plugins

### [development-workflow](plugins/development-workflow)

A complete software development workflow built on composable skills and automatic invocation. Your coding agent steps back to understand what you're building before writing code, produces a reviewable design, then works through implementation with TDD, code review, and CI/CD built in.

Because skills trigger automatically, you don't need to do anything special -- describe what you want to build and the workflow activates.

**The basic flow:**

1. **evaluate** -- Refines ideas through questions, explores alternatives, presents design for validation
2. **blueprint** -- Breaks work into bite-sized tasks with exact file paths and verification steps
3. **delegate/build** -- Dispatches subagents per task with two-stage review, or executes in batches with human checkpoints
4. **test-first** -- Enforces RED-GREEN-REFACTOR for every implementation task
5. **seek-review** -- Reviews against plan, reports issues by severity
6. **wrap-up** -- Verifies tests, presents merge/PR/keep/discard options

**Also includes:** root-cause debugging, CI monitoring (ci-loop), stacked PR management (draft-prs, pr-stack), automated releases (auto-release), skill creation (craft-skill), and onboarding.

**Components:** 17 skills, 3 slash commands, 1 agent (code-reviewer), 8 rules, session-start hook

Also supports Codex and OpenCode -- see [plugin README](plugins/development-workflow) for setup.

### [tribunal](https://github.com/jpeggdev/tribunal)

Multi-agent orchestration framework for Claude Code, Codex CLI, and Gemini CLI. Provides 18 specialized agents, a 9-phase development workflow, and quality gates that enforce TDD, coverage thresholds, and spec-driven development.

**The pipeline:**

1. **Research** -- Gather context and requirements
2. **Brainstorm** -- Multi-agent debate to explore design alternatives
3. **Design Review Gate** -- 5-agent parallel review (PM, Architect, Designer, Security, CTO)
4. **Plan** -- Break work into implementation units
5. **Plan Review Gate** -- 3 adversarial reviewers (Feasibility, Completeness, Scope)
6. **Execute** -- 4-phase loop per work unit (Implement, Validate, Adversarial Review, Commit)
7. **Final Review** -- Cross-check against requirements
8. **Self-Reflect** -- Extract learnings into knowledge base
9. **Ship** -- PR creation with coverage enforcement

**Also includes:** intelligent agent selection with decay scoring, layered config (tribunal.yaml), cross-CLI support, migration tools, and diagnostic checks.

**Components:** 16 skills, 19 commands, 18 agents, 8 rubrics, session-start hook

See [tribunal repo](https://github.com/jpeggdev/tribunal) for setup and usage.

## License

MIT -- see [LICENSE](LICENSE) for details.

## Source

[github.com/jpeggdev/buildwithjpegg](https://github.com/jpeggdev/buildwithjpegg)
