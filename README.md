# Shiplight Codex Plugin

AI-powered test automation for [OpenAI Codex](https://openai.com/codex) — browser testing via MCP and cloud test management.

## Quick Install

```bash
bash install.sh            # Install all skills (verify + shiplight cloud)
bash install.sh --free     # Install free version only (MCP + verify)
bash install.sh --global   # Install to user-level (available across all projects)
```

Options can be combined, e.g. `bash install.sh --free --global`.

## Manual Install

### Free version (MCP + verify)

1. Copy `.agents/skills/verify/` to your project's `.agents/skills/` directory (or `~/.agents/skills/` for global).

2. Add the browser MCP server to `.codex/config.toml` (or `~/.codex/config.toml`):

```toml
[mcp_servers.browser]
command = "npx"
args = ["-y", "@shiplightai/mcp@latest"]

[mcp_servers.browser.env]
PWDEBUG = "console"
```

### Full version (adds shiplight cloud)

Follow the free version steps above, then also copy `.agents/skills/shiplight/` to your `.agents/skills/` directory.

## Skills

### `$verify` — Browser Verification (free)

Visually verify UI changes in a real browser using Shiplight MCP tools. Use after making frontend changes to confirm layout, styling, and interactive behavior.

### `$shiplight` — Cloud Test Management

Create, run, and manage test cases via the Shiplight REST API. Supports test generation from natural language goals, test execution with result polling, and artifact downloads.

## Links

- [Shiplight](https://www.shiplight.ai)
- [Codex Skills Docs](https://developers.openai.com/codex/skills/)
- [Codex MCP Docs](https://developers.openai.com/codex/mcp)
