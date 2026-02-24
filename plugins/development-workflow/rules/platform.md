# Platform specific

On Windows (MINGW64/Git Bash):

- Use forward slashes in paths for cross-platform compatibility.
- Shell commands run in bash (MINGW64), not cmd.exe or PowerShell.
- Avoid `NUL` -- use `/dev/null` instead.
- Quote paths containing spaces with double quotes.
- The `/c` flag for cmd.exe must not be converted to `C:/`.
- Always test MCP server registrations and hook commands for Windows compatibility.
