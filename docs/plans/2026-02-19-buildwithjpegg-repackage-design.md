# buildwithjpegg Plugin - Repackage Design

## Summary

Repackage the superpowers v4.3.0 plugin as a new Claude Code plugin called **buildwithjpegg** with the `jpegg:` skill prefix. Fresh scaffolding approach -- build from scratch, port and rename content skill by skill.

## Decisions

| Decision | Choice |
|-|-|
| Plugin name | buildwithjpegg |
| Skill prefix | jpegg: |
| Approach | Fresh scaffolding with content ported |
| Skills | All 17 original + 4 custom, renamed |
| Naming tone | Shorter/punchier, different words |
| Platforms | Claude Code + Codex + OpenCode |
| License | MIT, fork-style attribution to Jesse Vincent |

## Skill Rename Mapping

| Original | New Name |
|-|-|
| using-superpowers | onboard |
| brainstorming | evaluate |
| writing-plans | blueprint |
| executing-plans | build |
| test-driven-development | test-first |
| systematic-debugging | root-cause |
| verification-before-completion | pre-ship |
| requesting-code-review | seek-review |
| receiving-code-review | handle-review |
| dispatching-parallel-agents | fan-out |
| subagent-driven-development | delegate |
| finishing-a-development-branch | wrap-up |
| using-git-worktrees | worktree |
| writing-skills | craft-skill |
| ci-watch-and-fix | ci-loop |
| draft-pr-management | draft-prs |
| stack-state | pr-stack |
| semantic-release-setup | auto-release |

## Structure

```
buildwithjpegg/
  .claude-plugin/
    plugin.json
    marketplace.json
  .codex/
    INSTALL.md
  .opencode/
    INSTALL.md
  agents/
    code-reviewer.md
  commands/
    evaluate.md
    write-blueprint.md
    run-build.md
  hooks/
    hooks.json
    run-hook.cmd
    session-start.sh
  lib/
    skills-core.js
  rules/
    conventions.md
    git.md
    stack.md
    workflow.md
  skills/
    onboard/SKILL.md
    evaluate/SKILL.md
    blueprint/SKILL.md
    build/SKILL.md
    test-first/SKILL.md
    root-cause/SKILL.md (+ support files)
    pre-ship/SKILL.md
    seek-review/SKILL.md (+ code-reviewer.md)
    handle-review/SKILL.md
    fan-out/SKILL.md
    delegate/SKILL.md (+ prompt files)
    wrap-up/SKILL.md
    worktree/SKILL.md
    craft-skill/SKILL.md (+ support files)
    ci-loop/SKILL.md
    draft-prs/SKILL.md
    pr-stack/SKILL.md
    auto-release/SKILL.md
  tests/
  docs/
  LICENSE
  README.md
  RELEASE-NOTES.md
```

## Cross-Reference Updates

Every file referencing skill names or the `superpowers:` prefix must be updated:

- All SKILL.md files: replace old skill names with new names in invocation instructions
- rules/workflow.md: update the skill invocation sequence
- commands/*.md: update skill invocation targets
- hooks/session-start.sh: update any skill name references
- agents/code-reviewer.md: update skill references
- lib/skills-core.js: update skill name strings
- .codex/ and .opencode/ docs: update plugin name references

Global replacements:
- `superpowers:` -> `jpegg:`
- `superpowers` (plugin name) -> `buildwithjpegg`
- Each old skill directory/name -> corresponding new name

## License

MIT License with fork-style attribution:

```
Copyright (c) 2026 jpegg

Based on superpowers (https://github.com/obra/superpowers)
by Jesse Vincent, licensed under the MIT License.
```

## Acknowledgment

README will include an acknowledgment section crediting superpowers as the foundation.
