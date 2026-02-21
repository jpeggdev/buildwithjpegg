---
name: auto-release
description: One-time setup that wires semantic-release into a repository for automated versioning, changelog generation, and GitHub releases from conventional commits. Use when setting up a new repo that will be publicly released.
---

# Semantic Release Setup

Automates version bumping, changelog generation, and GitHub release creation from conventional commit history.

**Announce at start:** "Setting up semantic-release for automated versioning."

## What This Does

After setup, every merge to `main` that contains at least one `feat:` or `fix:` commit will:
- Determine the next version automatically (`feat` → minor, `fix` → patch, `BREAKING CHANGE` → major)
- Generate/update `CHANGELOG.md`
- Bump the version in `package.json` (or equivalent config files)
- Create a GitHub release with generated release notes
- Tag the commit with the version

## Step 1: Identify the project type

Check what config files exist to determine version file locations:

```bash
ls package.json pyproject.toml Cargo.toml tauri.conf.json 2>/dev/null
```

Note which files contain version numbers -- they all need to be updated on release.

## Step 2: Install semantic-release

For Node.js projects (or projects using it as a dev tool):

```bash
pnpm add -D semantic-release \
  @semantic-release/changelog \
  @semantic-release/git \
  @semantic-release/github \
  @semantic-release/exec
```

For Python projects without a package.json, create a minimal one:

```json
{
  "name": "<project-name>",
  "private": true,
  "devDependencies": {}
}
```

Then run the pnpm install above.

## Step 3: Create `.releaserc.json`

Adapt to the project's version file locations:

```json
{
  "branches": ["main"],
  "plugins": [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    [
      "@semantic-release/changelog",
      {
        "changelogFile": "CHANGELOG.md"
      }
    ],
    [
      "@semantic-release/exec",
      {
        "prepareCmd": "node .semantic-release/bump-versions.js ${nextRelease.version}"
      }
    ],
    [
      "@semantic-release/git",
      {
        "assets": ["CHANGELOG.md", "package.json", "<other version files>"],
        "message": "chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}"
      }
    ],
    "@semantic-release/github"
  ]
}
```

## Step 4: Create version bump script

For projects with multiple version files, create `.semantic-release/bump-versions.js`:

```javascript
const fs = require('fs');
const version = process.argv[2];

// Example: bump version in tauri.conf.json
const tauriConf = JSON.parse(fs.readFileSync('src-tauri/tauri.conf.json', 'utf8'));
tauriConf.version = version;
fs.writeFileSync('src-tauri/tauri.conf.json', JSON.stringify(tauriConf, null, 2));

// Example: bump version in Cargo.toml (simple string replace)
let cargo = fs.readFileSync('src-tauri/Cargo.toml', 'utf8');
cargo = cargo.replace(/^version = ".*"/m, `version = "${version}"`);
fs.writeFileSync('src-tauri/Cargo.toml', cargo);

console.log(`Bumped to ${version}`);
```

Adapt this to the actual version files in the project.

## Step 5: Add GitHub Actions workflow

Create `.github/workflows/release.yml`:

```yaml
name: Release

on:
  push:
    branches:
      - main

permissions:
  contents: write
  issues: write
  pull-requests: write

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
          persist-credentials: false

      - uses: actions/setup-node@v4
        with:
          node-version: 20

      - name: Install dependencies
        run: pnpm install --frozen-lockfile

      - name: Release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: pnpm exec semantic-release
```

**Note:** If the existing release workflow already handles binary builds (Tauri, native apps), integrate semantic-release as the version-determination step that runs *before* the build, not as a replacement for the entire workflow. In that case, use `semantic-release` in `--dry-run` mode to get the next version, pass it to the build, then tag after a successful build.

## Step 6: Add `CHANGELOG.md` to `.gitignore` exceptions

If `CHANGELOG.md` is currently gitignored, remove it. semantic-release commits it.

## Step 7: Verify

```bash
# Dry run to confirm configuration is valid
pnpm exec semantic-release --dry-run
```

Check output for errors. Common issues:
- Missing `GITHUB_TOKEN` locally (expected -- it runs in CI only)
- Version files not found by bump script
- Branch name mismatch

## What NOT to change

Do not modify the existing deploy/release scripts unless the user explicitly asks. semantic-release adds automated versioning on top of the existing workflow -- it does not replace CI/CD pipelines or build processes.

## After Setup

The manual version bump step in `deploy-application.sh` (or equivalent) can be removed once you confirm semantic-release is working correctly. Do not remove it until at least one automated release has succeeded.
