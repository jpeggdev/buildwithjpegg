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
/plugin marketplace add jpeggdev/buildwithjpegg-marketplace
```

Then install any plugin:

```bash
/plugin install development-workflow@buildwithjpegg-marketplace
```

## How It Works

The marketplace is a JSON registry (`.claude-plugin/marketplace.json`) that maps plugin names to their GitHub source repos. Claude Code reads this manifest to discover and install plugins.

```
.claude-plugin/marketplace.json   # Plugin registry
plugins/                          # Symlinks to local plugin repos (development only)
```

## Contributing

To add a plugin to the marketplace:

1. Create your plugin repo with a `.claude-plugin/plugin.json` manifest
2. Open a PR adding an entry to `.claude-plugin/marketplace.json`:

```json
{
    "name": "your-plugin-name",
    "source": {
        "source": "github",
        "repo": "your-username/your-plugin-repo"
    }
}
```

## License

MIT License -- see [LICENSE](LICENSE) for details.
