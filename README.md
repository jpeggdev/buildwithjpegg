# buildwithjpegg Marketplace

A plugin marketplace for Claude Code. Browse, install, and manage developer workflow plugins from a single registry.

## Available Plugins

| Plugin | Description | Source |
|-|-|-|
| [development-workflow](https://github.com/jpeggdev/development-workflow-plugin) | Complete development workflow with composable skills -- design, TDD, code review, CI/CD, stacked PRs | GitHub |
| [genai-xskills.ai](https://github.com/jpeggdev/genai-xskills.ai-plugin) | Generative AI skills | GitHub |

## Installation

Register the marketplace in Claude Code:

```bash
/plugin marketplace add jpeggdev/buildwithjpegg
```

Then install any plugin:

```bash
/plugin install development-workflow@buildwithjpegg
```

## License

MIT License -- see [LICENSE](LICENSE) for details.
