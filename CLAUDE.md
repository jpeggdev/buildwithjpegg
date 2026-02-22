# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A marketplace registry for Claude Code plugins. This repo is the index -- it does not contain plugin source code directly. Plugins live in separate repos and are linked here via symlinks for local development.

## Structure

```
.claude-plugin/marketplace.json  -- Plugin registry manifest
plugins/                         -- Symlinks to local plugin repos
  development-workflow/          -> /c/code/buildwithjpegg/development-workflow/
  genai-xskills.ai/              -> /c/code/buildwithjpegg/genai-xskills.ai/
```

## Key File: marketplace.json

The manifest at `.claude-plugin/marketplace.json` defines all registered plugins. Each entry has:
- `name` -- plugin identifier
- `source.source` -- origin type (currently `"github"`)
- `source.repo` -- GitHub repo path (e.g., `jpeggdev/development-workflow-plugin`)

## Adding a Plugin

1. Add an entry to the `plugins` array in `.claude-plugin/marketplace.json`
2. Create a symlink in `plugins/` pointing to the local plugin repo
3. The plugin repo must have its own `.claude-plugin/plugin.json` manifest

## Development

No build system, package manager, or tests -- this is a static JSON registry with symlinks. Changes are limited to editing `marketplace.json` and managing symlinks.

## Gotchas

- The `plugins/` directory contains symlinks, not actual code. Git tracks symlinks but the targets must exist locally for development.
- On Windows, symlinks may require developer mode or elevated permissions.
- Plugin repos are separate Git repositories with their own branches and release cycles.
