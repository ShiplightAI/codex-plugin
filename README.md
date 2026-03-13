# Shiplight Codex Plugin

AI-powered test automation for [OpenAI Codex](https://openai.com/codex) — browser testing, YAML test authoring, and cloud test management.

## Quick Install
```bash
git clone https://github.com/ShiplightAI/codex-plugin
```

```bash
bash ./codex-plugin/install.sh                     # Install to project-level
bash ./codex-plugin/install.sh --scope user        # Install to user-level
```

## Manual Install

1. Copy `agents/skills/verify/`, `agents/skills/create_tests/`, and `agents/skills/cloud/` to your project's `.agents/skills/` directory (or `~/.agents/skills/` for user-level).

2. Add the Shiplight MCP server to `.codex/config.toml` (or `~/.codex/config.toml`):

```toml
[mcp_servers.shiplight]
command = "npx"
args = ["--yes", "@shiplightai/mcp@latest"]

[mcp_servers.shiplight.env]
PWDEBUG = "console"
```

Cloud tools (`save_test_case`, `get_test_case`, etc.) are automatically available when `SHIPLIGHT_API_TOKEN` is set in the project's `.env` file.

## Skills

### `$verify` — Browser Verification

Visually verify UI changes in a real browser using Shiplight MCP tools. Use after making frontend changes to confirm layout, styling, and interactive behavior.

### `$create_tests` — YAML Test Authoring

Scaffold a local Shiplight test project, configure credentials, and write YAML tests by walking through the app in a browser.

### `$cloud` — Cloud Sync & Management

Sync local test cases, templates, and functions with Shiplight cloud. Manage test runs, environments, folders, and accounts via the REST API.

## Links

- [Shiplight](https://www.shiplight.ai)
- [Codex Skills Docs](https://developers.openai.com/codex/skills/)
- [Codex MCP Docs](https://developers.openai.com/codex/mcp)
