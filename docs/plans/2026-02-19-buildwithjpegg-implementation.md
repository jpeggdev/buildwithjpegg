# buildwithjpegg Repackage Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use jpegg:build to implement this plan task-by-task.

**Goal:** Fresh-scaffold the buildwithjpegg plugin from the superpowers v4.3.0 source, renaming all skills and updating all cross-references.

**Architecture:** Delete all old content (preserving .git and docs/plans), then create the new plugin structure from scratch. Each file is written with updated names, references, and metadata. The rename mapping is applied consistently across all files.

**Tech Stack:** Bash (file operations), Markdown (skills/rules/docs), JSON (plugin config), JavaScript (lib + OpenCode plugin)

---

## Reference: Rename Mapping

This mapping must be applied in every file that references skill names:

| Old Name | New Name | Old Prefix | New Prefix |
|-|-|-|-|
| using-superpowers | onboard | superpowers: | jpegg: |
| brainstorming | evaluate | superpowers: | jpegg: |
| writing-plans | blueprint | superpowers: | jpegg: |
| executing-plans | build | superpowers: | jpegg: |
| test-driven-development | test-first | superpowers: | jpegg: |
| systematic-debugging | root-cause | superpowers: | jpegg: |
| verification-before-completion | pre-ship | superpowers: | jpegg: |
| requesting-code-review | seek-review | superpowers: | jpegg: |
| receiving-code-review | handle-review | superpowers: | jpegg: |
| dispatching-parallel-agents | fan-out | superpowers: | jpegg: |
| subagent-driven-development | delegate | superpowers: | jpegg: |
| finishing-a-development-branch | wrap-up | superpowers: | jpegg: |
| using-git-worktrees | worktree | superpowers: | jpegg: |
| writing-skills | craft-skill | superpowers: | jpegg: |
| ci-watch-and-fix | ci-loop | superpowers: | jpegg: |
| draft-pr-management | draft-prs | superpowers: | jpegg: |
| stack-state | pr-stack | superpowers: | jpegg: |
| semantic-release-setup | auto-release | superpowers: | jpegg: |

Plugin name: `superpowers` -> `buildwithjpegg`

---

### Task 1: Clean slate -- remove old content

Remove all old superpowers content while preserving git history and the design docs.

**Step 1: Remove old directories and files**

```bash
cd C:/code/buildwithjpegg
# Remove old skill directories (will be recreated with new names)
rm -rf skills/
# Remove old platform dirs (will be recreated)
rm -rf .codex/ .opencode/
# Remove old hooks, lib, agents, commands, tests
rm -rf hooks/ lib/ agents/ commands/ tests/
# Remove old root files (not .git, not docs/, not rules/)
rm -f LICENSE README.md RELEASE-NOTES.md .claude-plugin/plugin.json .claude-plugin/marketplace.json
rm -rf .claude-plugin/
# Keep: .git/, docs/plans/, rules/ (already customized)
```

**Step 2: Verify clean state**

```bash
ls C:/code/buildwithjpegg/
```

Expected: only `.git/`, `docs/`, `rules/`, `.gitignore`, `.gitattributes`

**Step 3: Commit the clean slate**

```bash
git add -A && git commit -m "chore: remove old superpowers content for fresh scaffold"
```

---

### Task 2: Create plugin metadata and license

**Files:**
- Create: `.claude-plugin/plugin.json`
- Create: `.claude-plugin/marketplace.json`
- Create: `LICENSE`

**Step 1: Create .claude-plugin directory**

```bash
mkdir -p .claude-plugin
```

**Step 2: Write plugin.json**

```json
{
  "name": "buildwithjpegg",
  "description": "Development workflow skills for Claude Code: TDD, debugging, collaboration patterns, and proven techniques",
  "version": "1.0.0",
  "author": {
    "name": "jpegg"
  },
  "homepage": "https://github.com/jpeggdev/buildwithjpegg",
  "repository": "https://github.com/jpeggdev/buildwithjpegg",
  "license": "MIT",
  "keywords": ["skills", "tdd", "debugging", "collaboration", "best-practices", "workflows"]
}
```

**Step 3: Write marketplace.json**

```json
{
  "name": "buildwithjpegg",
  "description": "Development workflow skills for Claude Code",
  "owner": {
    "name": "jpegg"
  },
  "plugins": [
    {
      "name": "buildwithjpegg",
      "description": "Development workflow skills for Claude Code: TDD, debugging, collaboration patterns, and proven techniques",
      "version": "1.0.0",
      "source": "./",
      "author": {
        "name": "jpegg"
      }
    }
  ]
}
```

**Step 4: Write LICENSE**

```
MIT License

Copyright (c) 2026 jpegg

Based on superpowers (https://github.com/obra/superpowers)
by Jesse Vincent, licensed under the MIT License.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

**Step 5: Commit**

```bash
git add .claude-plugin/ LICENSE && git commit -m "chore: add buildwithjpegg plugin metadata and license"
```

---

### Task 3: Create hooks and lib

Port the session startup hook and core library with updated references.

**Files:**
- Create: `hooks/hooks.json`
- Create: `hooks/session-start.sh`
- Create: `hooks/run-hook.cmd`
- Create: `lib/skills-core.js`

**Step 1: Write hooks/hooks.json**

Identical to original -- uses `${CLAUDE_PLUGIN_ROOT}` which is path-agnostic.

**Step 2: Write hooks/session-start.sh**

Port from original with these changes:
- Comment: `# SessionStart hook for buildwithjpegg plugin`
- Legacy dir check: `~/.config/buildwithjpegg/skills` instead of `~/.config/superpowers/skills`
- Warning message: reference "buildwithjpegg" and `~/.config/buildwithjpegg/skills`
- Skill path: `skills/onboard/SKILL.md` instead of `skills/using-superpowers/SKILL.md`
- Context injection: `"You have buildwithjpegg."` and `'buildwithjpegg:onboard'` instead of `'superpowers:using-superpowers'`

**Step 3: Write hooks/run-hook.cmd**

Port from original with updated comment header referencing buildwithjpegg.

**Step 4: Write lib/skills-core.js**

Port from original with these changes:
- `sourceType` parameter: `'buildwithjpegg'` instead of `'superpowers'`
- `resolveSkillPath`: prefix check for `'buildwithjpegg:'` instead of `'superpowers:'`
- Comments updated to reference buildwithjpegg

**Step 5: Commit**

```bash
git add hooks/ lib/ && git commit -m "feat: add hooks and core library"
```

---

### Task 4: Update rules with new skill names

The rules/ directory already has custom content. Only `workflow.md` needs skill name updates.

**Files:**
- Modify: `rules/workflow.md`

**Step 1: Update workflow.md**

Replace all skill references with new names:
- `superpowers:brainstorming` -> `jpegg:evaluate`
- `superpowers:writing-plans` -> `jpegg:blueprint`
- `superpowers:executing-plans` -> `jpegg:build`
- `superpowers:using-git-worktrees` -> `jpegg:worktree`
- `superpowers:test-driven-development` -> `jpegg:test-first`
- `superpowers:verification-before-completion` -> `jpegg:pre-ship`
- `superpowers:requesting-code-review` -> `jpegg:seek-review`
- `superpowers:receiving-code-review` -> `jpegg:handle-review`
- `draft-pr-management` -> `draft-prs`
- `ci-watch-and-fix` -> `ci-loop`
- `stack-state` -> `pr-stack`

**Step 2: Verify no old names remain**

```bash
grep -rn "superpowers" rules/
```

Expected: no matches

**Step 3: Commit**

```bash
git add rules/ && git commit -m "feat: update workflow rules with new skill names"
```

---

### Task 5: Port foundational skills (no cross-references to other skills)

These skills don't reference other skills internally.

**Files:**
- Create: `skills/test-first/SKILL.md` + `testing-anti-patterns.md`
- Create: `skills/pre-ship/SKILL.md`
- Create: `skills/handle-review/SKILL.md`
- Create: `skills/fan-out/SKILL.md`
- Create: `skills/ci-loop/SKILL.md`
- Create: `skills/draft-prs/SKILL.md`
- Create: `skills/pr-stack/SKILL.md`
- Create: `skills/auto-release/SKILL.md`

**For each skill:**

1. Read the source SKILL.md from the old repo (use git show or the cached plugin)
2. Create the new directory: `mkdir -p skills/<new-name>`
3. Write the new SKILL.md with:
   - Updated frontmatter `name:` field
   - Updated frontmatter `description:` field (replace old skill names)
   - Updated body text (replace all old skill name references)
   - Replace `superpowers:` prefix with `jpegg:` everywhere
4. Copy support files (e.g., `testing-anti-patterns.md`) with updated references

**Step N: Commit after each batch**

```bash
git add skills/test-first/ skills/pre-ship/ skills/handle-review/ skills/fan-out/ skills/ci-loop/ skills/draft-prs/ skills/pr-stack/ skills/auto-release/
git commit -m "feat: port foundational skills with new names"
```

---

### Task 6: Port root-cause skill (systematic-debugging)

This skill has many support files and references test-first and pre-ship.

**Files:**
- Create: `skills/root-cause/SKILL.md`
- Create: `skills/root-cause/CREATION-LOG.md`
- Create: `skills/root-cause/root-cause-tracing.md`
- Create: `skills/root-cause/defense-in-depth.md`
- Create: `skills/root-cause/condition-based-waiting.md`
- Create: `skills/root-cause/condition-based-waiting-example.ts`
- Create: `skills/root-cause/find-polluter.sh`
- Create: `skills/root-cause/test-academic.md`
- Create: `skills/root-cause/test-pressure-1.md`
- Create: `skills/root-cause/test-pressure-2.md`
- Create: `skills/root-cause/test-pressure-3.md`

**Step 1: Read all source files from old `skills/systematic-debugging/`**

**Step 2: Write each file with updates:**
- SKILL.md: `name: root-cause`, replace `test-driven-development` -> `test-first`, `verification-before-completion` -> `pre-ship`, `systematic-debugging` -> `root-cause`
- Support files: update any skill name references

**Step 3: Commit**

```bash
git add skills/root-cause/ && git commit -m "feat: port root-cause skill (was systematic-debugging)"
```

---

### Task 7: Port craft-skill (writing-skills)

Has support files including testing methodology.

**Files:**
- Create: `skills/craft-skill/SKILL.md`
- Create: `skills/craft-skill/anthropic-best-practices.md`
- Create: `skills/craft-skill/persuasion-principles.md`
- Create: `skills/craft-skill/testing-skills-with-subagents.md`
- Create: `skills/craft-skill/graphviz-conventions.dot`
- Create: `skills/craft-skill/render-graphs.js`
- Create: `skills/craft-skill/examples/CLAUDE_MD_TESTING.md`

**Step 1: Read all source files from old `skills/writing-skills/`**

**Step 2: Write each file with updates:**
- SKILL.md: `name: craft-skill`, replace `test-driven-development` -> `test-first`, `writing-skills` -> `craft-skill`
- Support files: update any skill name references, replace `superpowers` -> `buildwithjpegg`

**Step 3: Commit**

```bash
git add skills/craft-skill/ && git commit -m "feat: port craft-skill (was writing-skills)"
```

---

### Task 8: Port workflow skills with cross-references

These skills reference each other and need careful cross-reference updates.

**Files:**
- Create: `skills/evaluate/SKILL.md` (was brainstorming)
- Create: `skills/blueprint/SKILL.md` (was writing-plans)
- Create: `skills/build/SKILL.md` (was executing-plans)
- Create: `skills/worktree/SKILL.md` (was using-git-worktrees)
- Create: `skills/wrap-up/SKILL.md` (was finishing-a-development-branch)
- Create: `skills/seek-review/SKILL.md` + `code-reviewer.md` (was requesting-code-review)

**For each skill, apply the full rename mapping:**

evaluate (was brainstorming):
- `name: evaluate`
- `writing-plans` -> `blueprint`
- `superpowers:writing-plans` -> `jpegg:blueprint`
- `brainstorming` -> `evaluate` in all context

blueprint (was writing-plans):
- `name: blueprint`
- `executing-plans` -> `build`
- `subagent-driven-development` -> `delegate`
- `superpowers:executing-plans` -> `jpegg:build`
- `superpowers:subagent-driven-development` -> `jpegg:delegate`

build (was executing-plans):
- `name: build`
- `using-git-worktrees` -> `worktree`
- `finishing-a-development-branch` -> `wrap-up`
- `writing-plans` -> `blueprint`
- All `superpowers:` -> `jpegg:` prefixes

worktree (was using-git-worktrees):
- `name: worktree`
- `brainstorming` -> `evaluate`
- `subagent-driven-development` -> `delegate`
- `executing-plans` -> `build`
- `finishing-a-development-branch` -> `wrap-up`

wrap-up (was finishing-a-development-branch):
- `name: wrap-up`
- `using-git-worktrees` -> `worktree`
- `subagent-driven-development` -> `delegate`
- `executing-plans` -> `build`

seek-review (was requesting-code-review):
- `name: seek-review`
- `subagent-driven-development` -> `delegate`
- `executing-plans` -> `build`
- Also port `code-reviewer.md` support file

**Step N: Commit**

```bash
git add skills/evaluate/ skills/blueprint/ skills/build/ skills/worktree/ skills/wrap-up/ skills/seek-review/
git commit -m "feat: port workflow skills with cross-references"
```

---

### Task 9: Port delegate skill (subagent-driven-development)

Heavy cross-references and prompt files.

**Files:**
- Create: `skills/delegate/SKILL.md`
- Create: `skills/delegate/code-quality-reviewer-prompt.md`
- Create: `skills/delegate/implementer-prompt.md`
- Create: `skills/delegate/spec-reviewer-prompt.md`

**Step 1: Read all source files from old `skills/subagent-driven-development/`**

**Step 2: Write each file with full rename mapping applied:**
- `using-git-worktrees` -> `worktree`
- `writing-plans` -> `blueprint`
- `requesting-code-review` -> `seek-review`
- `finishing-a-development-branch` -> `wrap-up`
- `test-driven-development` -> `test-first`
- `subagent-driven-development` -> `delegate`
- All `superpowers:` -> `jpegg:`

**Step 3: Commit**

```bash
git add skills/delegate/ && git commit -m "feat: port delegate skill (was subagent-driven-development)"
```

---

### Task 10: Port onboard skill (using-superpowers)

The entry point skill -- heaviest rewrite since it describes the entire system.

**Files:**
- Create: `skills/onboard/SKILL.md`

**Step 1: Read source `skills/using-superpowers/SKILL.md`**

**Step 2: Write new SKILL.md with:**
- `name: onboard`
- `description:` updated to reference buildwithjpegg
- Replace all `brainstorming` -> `evaluate`, `debugging` -> `root-cause` in the priority section
- Replace `superpowers` -> `buildwithjpegg` in body text where it refers to the plugin name
- Replace `brainstorming skill` -> `evaluate skill` in the flow diagram

**Step 3: Commit**

```bash
git add skills/onboard/ && git commit -m "feat: port onboard skill (was using-superpowers)"
```

---

### Task 11: Create commands and agents

**Files:**
- Create: `commands/evaluate.md`
- Create: `commands/write-blueprint.md`
- Create: `commands/run-build.md`
- Create: `agents/code-reviewer.md`

**Step 1: Write commands/evaluate.md**

```markdown
---
description: "You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Explores requirements and design before implementation."
disable-model-invocation: true
---

Invoke the jpegg:evaluate skill and follow it exactly as presented to you
```

**Step 2: Write commands/write-blueprint.md**

```markdown
---
description: Create detailed implementation plan with bite-sized tasks
disable-model-invocation: true
---

Invoke the jpegg:blueprint skill and follow it exactly as presented to you
```

**Step 3: Write commands/run-build.md**

```markdown
---
description: Execute plan in batches with review checkpoints
disable-model-invocation: true
---

Invoke the jpegg:build skill and follow it exactly as presented to you
```

**Step 4: Write agents/code-reviewer.md**

Port from original -- this file has no skill name references in the body, only generic code review instructions. Keep as-is except update the frontmatter name if needed.

**Step 5: Commit**

```bash
git add commands/ agents/ && git commit -m "feat: add commands and code-reviewer agent"
```

---

### Task 12: Create platform support files

**Files:**
- Create: `.codex/INSTALL.md`
- Create: `.opencode/INSTALL.md`
- Create: `.opencode/plugins/buildwithjpegg.js`

**Step 1: Write .codex/INSTALL.md**

Port from original with:
- `superpowers` -> `buildwithjpegg` everywhere
- Repository URL updated
- Symlink paths updated: `~/.codex/buildwithjpegg`, `~/.agents/skills/buildwithjpegg`

**Step 2: Write .opencode/INSTALL.md**

Port from original with:
- `superpowers` -> `buildwithjpegg` everywhere
- Repository URL updated
- Symlink paths updated: `~/.config/opencode/buildwithjpegg`, `~/.config/opencode/skills/buildwithjpegg`
- Skill load example: `buildwithjpegg/evaluate` instead of `superpowers/brainstorming`

**Step 3: Write .opencode/plugins/buildwithjpegg.js**

Port from `superpowers.js` with:
- Comment header: `buildwithjpegg plugin for OpenCode.ai`
- Function name: `BuildwithjpeggPlugin` instead of `SuperpowersPlugin`
- Skill path: `'onboard', 'SKILL.md'` instead of `'using-superpowers', 'SKILL.md'`
- Context text: `"You have buildwithjpegg."` and `'buildwithjpegg:onboard'`
- Tool mapping text: reference `buildwithjpegg` not `superpowers`
- Legacy dir: `~/.config/buildwithjpegg/skills`

**Step 4: Commit**

```bash
git add .codex/ .opencode/ && git commit -m "feat: add Codex and OpenCode platform support"
```

---

### Task 13: Write README

**Files:**
- Create: `README.md`
- Create: `RELEASE-NOTES.md`

**Step 1: Write README.md**

New README for buildwithjpegg covering:
- Description (development workflow skills plugin)
- Installation for all 3 platforms (Claude Code, Codex, OpenCode)
- Skill list with new names organized by category
- Basic workflow description
- Acknowledgment section crediting superpowers
- License reference

Use the new skill names throughout. Do not copy the sponsorship section.

**Step 2: Write RELEASE-NOTES.md**

```markdown
# Release Notes

## v1.0.0

Initial release of buildwithjpegg, a development workflow skills plugin for Claude Code.

Based on superpowers v4.3.0 by Jesse Vincent.
```

**Step 3: Commit**

```bash
git add README.md RELEASE-NOTES.md && git commit -m "docs: add README and release notes"
```

---

### Task 14: Port tests

**Files:**
- Create: `tests/` directory tree mirroring original with updated references

**Step 1: Port test files**

For each test file:
- Update skill name references (old -> new)
- Update `superpowers` -> `buildwithjpegg` in plugin references
- Update prompt files that reference old skill names
- Update shell scripts that reference old paths

Key files to update:
- `tests/skill-triggering/prompts/*.txt` -- update skill names in prompts
- `tests/skill-triggering/run-test.sh` -- update expected skill names
- `tests/explicit-skill-requests/prompts/*.txt` -- update skill references
- `tests/claude-code/*.sh` -- update plugin/skill references
- `tests/opencode/*.sh` -- update plugin references

**Step 2: Commit**

```bash
git add tests/ && git commit -m "test: port test suites with updated skill names"
```

---

### Task 15: Cross-reference audit

**Step 1: Search for any remaining old references**

```bash
grep -rn "superpowers" --include="*.md" --include="*.js" --include="*.json" --include="*.sh" --include="*.txt" .
```

Expected: zero matches (excluding .git/ and docs/plans/ design doc)

**Step 2: Search for old skill directory names**

```bash
grep -rn "using-superpowers\|brainstorming\|writing-plans\|executing-plans\|test-driven-development\|systematic-debugging\|verification-before-completion\|requesting-code-review\|receiving-code-review\|dispatching-parallel-agents\|subagent-driven-development\|finishing-a-development-branch\|using-git-worktrees\|writing-skills\|ci-watch-and-fix\|draft-pr-management\|stack-state\|semantic-release-setup" --include="*.md" --include="*.js" --include="*.json" --include="*.sh" .
```

Expected: zero matches outside docs/plans/ design doc

**Step 3: Fix any straggling references found**

**Step 4: Commit if changes were needed**

```bash
git add -A && git commit -m "fix: clean up remaining old references"
```

---

### Task 16: Final verification

**Step 1: Verify directory structure matches design**

```bash
find . -not -path './.git/*' -not -path './.git' | sort
```

Compare against the design doc structure.

**Step 2: Verify all 21 skills exist**

```bash
ls skills/*/SKILL.md | wc -l
```

Expected: 18 (21 skills total, but all have SKILL.md)

**Step 3: Verify plugin.json is valid JSON**

```bash
python -c "import json; json.load(open('.claude-plugin/plugin.json'))"
```

**Step 4: Verify hooks.json is valid JSON**

```bash
python -c "import json; json.load(open('hooks/hooks.json'))"
```

**Step 5: Run a final grep to confirm clean state**

```bash
grep -rn "superpowers" --include="*.md" --include="*.js" --include="*.json" --include="*.sh" . | grep -v ".git/" | grep -v "docs/plans/"
```

Expected: zero matches
