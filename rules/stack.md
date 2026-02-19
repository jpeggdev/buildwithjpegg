# Default Tech Stack

When starting a new project or the user hasn't specified preferences:

## Desktop Applications (default for this workspace)
- **Language**: Python for everything — UI and backend in one language
- **UI framework**: Flet (Python + Flutter renderer) — `flet build` produces native binaries
- **Embedded server**: aiohttp or FastAPI for the local HTTP server
- **Database**: SQLite via `aiosqlite` for async access, raw `sqlite3` for sync
- **Validation**: Pydantic
- **Templates**: Jinja2
- **Testing**: pytest + pytest-asyncio
- **MCP integration**: Official Anthropic MCP Python SDK
- **Packaging**: `flet build windows/macos/linux` for native binaries

## Web Applications
- **Language**: TypeScript for everything
- **Frontend**: React + Next.js (App Router), Tailwind CSS, Zustand or TanStack Query
- **Backend**: Hono (lightweight) or Next.js API routes, PostgreSQL + Drizzle ORM, Zod
- **Testing**: Vitest + Testing Library + Playwright

## Infra (both)
- GitHub Actions for CI/CD
- Docker + Docker Compose for services that need it

## AI/ML
- Anthropic SDK (Claude) as primary LLM — Python or TypeScript depending on project type

Always ask before deviating from these defaults on new projects.
