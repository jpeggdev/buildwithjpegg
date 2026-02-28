# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A marketplace registry for Claude Code plugins. This is a monorepo -- plugin source code lives directly in `plugins/`.

## Plugins

### development-workflow (v1.0.1)

Complete software development workflow with composable skills and automatic invocation. TDD, debugging, collaboration patterns, code review, CI/CD, stacked PRs.

- **Path:** `plugins/development-workflow/`
- **Components:** 18 skills, 3 slash commands (`/evaluate`, `/write-blueprint`, `/run-build`), 1 agent (code-reviewer), 8 rules, session-start hook
- **Core flow:** evaluate -> blueprint -> delegate/build -> test-first -> seek-review -> wrap-up
- **Also supports:** Codex and OpenCode (see plugin README)

## Structure

```
.claude-plugin/marketplace.json  -- Plugin registry manifest
plugins/
  development-workflow/          -- Development workflow plugin source
```

## Key File: marketplace.json

The manifest at `.claude-plugin/marketplace.json` defines all registered plugins. Each entry has:

- `name` -- plugin identifier
- `description` -- short description
- `source` -- local path to plugin directory
- `category` -- plugin category

## Adding a Plugin

1. Add an entry to the `plugins` array in `.claude-plugin/marketplace.json`
2. Create the plugin directory under `plugins/`
3. The plugin must have its own `.claude-plugin/plugin.json` manifest

## Development

No build system, package manager, or tests -- this is a static JSON registry. Changes are limited to editing `marketplace.json` and managing plugin directories.

## Gotchas

- Plugin source lives directly in `plugins/` (not symlinks). All code is in this monorepo.
- Each plugin has its own `.claude-plugin/plugin.json` with name, version, and metadata.
