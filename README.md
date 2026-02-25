# Shiplight Codex Plugin

AI-powered test automation for [OpenAI Codex](https://openai.com/codex) — browser testing via MCP and cloud test management.

## Quick Install

```bash
bash install.sh
```

This copies skills and MCP config into your current project. For user-level install (available across all projects):

```bash
bash install.sh --global
```

## Manual Install

1. Copy `.agents/skills/verify/` and `.agents/skills/shiplight/` to your project's `.agents/skills/` directory (or `~/.agents/skills/` for global).

2. Add the browser MCP server to `.codex/config.toml` (or `~/.codex/config.toml`):

```toml
[mcp_servers.browser]
command = "npx"
args = ["-y", "@shiplightai/mcp@latest"]

[mcp_servers.browser.env]
PWDEBUG = "console"
```

## Skills

### `$verify` — Browser Verification

Visually verify UI changes in a real browser using Shiplight MCP tools. Use after making frontend changes to confirm layout, styling, and interactive behavior.

### `$shiplight` — Cloud Test Management

Create, run, and manage test cases via the Shiplight REST API. Supports test generation from natural language goals, test execution with result polling, and artifact downloads.

## Links

- [Shiplight](https://www.shiplight.ai)
- [Codex Skills Docs](https://developers.openai.com/codex/skills/)
- [Codex MCP Docs](https://developers.openai.com/codex/mcp)
