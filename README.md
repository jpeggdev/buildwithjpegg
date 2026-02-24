# buildwithjpegg Marketplace

A plugin marketplace for Claude Code. Browse, install, and manage plugins for development workflows and AI video creation.

## Getting Started

Register the marketplace in Claude Code:

```bash
/plugin marketplace add jpeggdev/buildwithjpegg
```

Then install any plugin:

```bash
/plugin install development-workflow
/plugin install video-creation
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

**Also includes:** root-cause debugging, CI monitoring (ci-loop), stacked PR management (draft-prs, pr-stack), automated releases (auto-release), worktree isolation, skill creation (craft-skill), and onboarding.

**Components:** 18 skills, 3 slash commands, 1 agent (code-reviewer), 8 rules, session-start hook

Also supports Codex and OpenCode -- see [plugin README](plugins/development-workflow) for setup.

### [video-creation](plugins/video-creation)

AI video generation pipeline powered by [xskills.ai](https://xskills.ai). Go from concept to finished video with storyboard planning, keyframe image generation, video synthesis, and an HTML gallery of all assets.

**Skills:**

| Skill | Purpose |
|-|-|
| `create-storyboard` | Plan a video as timed shots with camera, scene, action, and image prompts |
| `create-image` | Generate keyframe images (Flux 2 Flash, Seedream, Nano Banana Pro, Gemini 3 Pro) |
| `create-video` | Generate video from images/prompts (Seedance 2.0, Sora 2, WAN 2.6, Hailuo 2.3) |
| `video-pipeline` | Orchestrate the full workflow: storyboard -> images -> video -> gallery |

**Requires:** `XSKILL_API_KEY` environment variable, Python 3, curl

## License

MIT -- see [LICENSE](LICENSE) for details.

## Source

[github.com/jpeggdev/buildwithjpegg](https://github.com/jpeggdev/buildwithjpegg)
