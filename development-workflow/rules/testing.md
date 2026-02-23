# Testing Conventions

## Philosophy
- Test behavior, not implementation
- Integration tests over unit tests for most code
- Unit tests for pure logic and edge cases
- E2E tests for critical user flows only

## Approach
- New features: write tests alongside implementation
- Bug fixes: write a failing test first, then fix
- Refactors: ensure tests pass before and after

## Tools (defaults)
- Vitest for unit/integration
- Playwright for E2E
- Testing Library for component tests
- pytest for Python projects
