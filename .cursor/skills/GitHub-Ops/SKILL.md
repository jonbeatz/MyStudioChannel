# GitHub-Ops Skill Pack

Manage repository operations, external library discovery, and GitHub API interactions.

## Capabilities
- Access and clone external GitHub libraries for research or integration.
- Verify GitHub API connectivity and token health.
- Manage local repo branching, committing, and PR readiness.
- Discovery of relevant GitHub repositories using Tavily/WebSearch and then fetching details via `gh` or API.

## Workflow
1. **Connectivity Check**: `npm run msc:test:github-api` to verify `GITHUB_PERSONAL_ACCESS_TOKEN`.
2. **Library Discovery**: Use `WebSearch` to find libraries, then `gh repo view <owner>/<repo> --json description,url` to verify.
3. **Research**: Clone libraries into a temporary directory if deep investigation is needed.

## Rules
- NEVER commit personal access tokens.
- Always use `gh` CLI for repo-level operations when available.
- For library integration, prefer reading the library's `README.md` and `examples/` before writing code.
