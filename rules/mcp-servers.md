# MCP Server Configuration

On Windows, MCP servers using npx must go through `cmd /c` since MINGW64 bash cannot run npx directly as a stdio command.

**Pattern:**
```json
"<server-name>": {
    "type": "stdio",
    "command": "cmd",
    "args": ["/c", "npx", "-y", "<package>@latest"],
    "env": {}
}
```

**Example (Context7):**
```json
"context7": {
    "type": "stdio",
    "command": "cmd",
    "args": ["/c", "npx", "-y", "@upstash/context7-mcp@latest"],
    "env": {}
}
```

Key points:
- Always use `"command": "cmd"` with `"/c"` as the first arg.
- Use `-y` with npx to auto-confirm install prompts.
- The `env` object can pass environment variables the server needs (API keys, etc.).
