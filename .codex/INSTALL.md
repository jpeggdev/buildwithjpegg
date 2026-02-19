# Installing buildwithjpegg for Codex

Enable buildwithjpegg skills in Codex via native skill discovery. Just clone and symlink.

## Prerequisites

- Git

## Installation

1. **Clone the buildwithjpegg repository:**
   ```bash
   git clone https://github.com/buildwithjpegg/buildwithjpegg.git ~/.codex/buildwithjpegg
   ```

2. **Create the skills symlink:**
   ```bash
   mkdir -p ~/.agents/skills
   ln -s ~/.codex/buildwithjpegg/skills ~/.agents/skills/buildwithjpegg
   ```

   **Windows (PowerShell):**
   ```powershell
   New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.agents\skills"
   cmd /c mklink /J "$env:USERPROFILE\.agents\skills\buildwithjpegg" "$env:USERPROFILE\.codex\buildwithjpegg\skills"
   ```

3. **Restart Codex** (quit and relaunch the CLI) to discover the skills.

## Migrating from old bootstrap

If you installed buildwithjpegg before native skill discovery, you need to:

1. **Update the repo:**
   ```bash
   cd ~/.codex/buildwithjpegg && git pull
   ```

2. **Create the skills symlink** (step 2 above) -- this is the new discovery mechanism.

3. **Remove the old bootstrap block** from `~/.codex/AGENTS.md` -- any block referencing `buildwithjpegg bootstrap` is no longer needed.

4. **Restart Codex.**

## Verify

```bash
ls -la ~/.agents/skills/buildwithjpegg
```

You should see a symlink (or junction on Windows) pointing to your buildwithjpegg skills directory.

## Updating

```bash
cd ~/.codex/buildwithjpegg && git pull
```

Skills update instantly through the symlink.

## Uninstalling

```bash
rm ~/.agents/skills/buildwithjpegg
```

Optionally delete the clone: `rm -rf ~/.codex/buildwithjpegg`.
