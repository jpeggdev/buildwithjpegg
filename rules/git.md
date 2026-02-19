# Git Conventions

## Commits
- Conventional commits: `type(scope): message`
- Types: feat, fix, refactor, test, docs, chore, ci
- Message in imperative mood, lowercase, no period
- Keep commits atomic -- one logical change per commit

## Branches
- `main` is production
- Feature branches: `feat/short-description`
- Fix branches: `fix/short-description`
- Never force-push to main

## PRs
- Title matches conventional commit format
- Body: summary bullets + test plan
- Squash merge to main
