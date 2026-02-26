# Shiplight Codex Plugin

AI-powered test automation for [OpenAI Codex](https://openai.com/codex) — browser testing via MCP and cloud test management.

## Quick Install

```bash
bash install.sh                     # Install verify skill (user-level)
bash install.sh --all               # Install all skills including Shiplight cloud
bash install.sh --scope project     # Install to current project only
```

Options can be combined, e.g. `bash install.sh --all --scope user`.

## Manual Install

### Default (MCP + verify)

1. Copy `agents/skills/verify/` to your project's `.agents/skills/` directory (or `~/.agents/skills/` for user-level).

2. Install the MCP server globally:

```bash
npm install -g @shiplightai/mcp
```

3. Add the browser MCP server to `.codex/config.toml` (or `~/.codex/config.toml`):

```toml
[mcp_servers.browser]
command = "shiplight-mcp"
```

### All skills (adds Shiplight cloud)

Follow the steps above, then also copy `agents/skills/cloud-tests/` to your `.agents/skills/` directory.

## Skills

### `$verify` — Browser Verification (free)

Visually verify UI changes in a real browser using Shiplight MCP tools. Use after making frontend changes to confirm layout, styling, and interactive behavior. Installed as `agents/skills/verify/`.

### `$cloud-tests` — Cloud Test Management

Create, run, and manage test cases via the Shiplight REST API. Supports test generation from natural language goals, test execution with result polling, and artifact downloads.

## Links

- [Shiplight](https://www.shiplight.ai)
- [Codex Skills Docs](https://developers.openai.com/codex/skills/)
- [Codex MCP Docs](https://developers.openai.com/codex/mcp)
