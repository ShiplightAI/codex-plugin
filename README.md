# Shiplight Codex Plugin

AI-powered test automation for [OpenAI Codex](https://openai.com/codex) — ship with confidence by letting the agent verify, test, and iterate autonomously.

## Quick Install
```bash
git clone https://github.com/ShiplightAI/codex-plugin
```

```bash
bash ./codex-plugin/install.sh                     # Install to project-level
bash ./codex-plugin/install.sh --scope user        # Install to user-level
```


## Skills

### `$verify` — Browser Verification

Visually confirm UI changes in the browser after a code change.

### `$create_e2e_tests` — E2E Test Authoring

Spec-driven E2E test creation: plan what to test through structured discovery phases, then scaffold a local Shiplight test project and write YAML tests by walking through the app in a browser.

### `$cloud` — Cloud Sync

Sync and share regression tests on the cloud platform for scheduled runs, team collaboration, and CI integration.

### Review Toolkit

Nine specialized review skills for comprehensive code and product review:

| Skill | Description |
|-------|-------------|
| `$review` | General code review with actionable feedback |
| `$design-review` | UX/UI design review for usability, consistency, and accessibility |
| `$security-review` | Security-focused review for vulnerabilities and attack surfaces |
| `$privacy-review` | Privacy review for data handling, consent, and regulatory compliance |
| `$compliance-review` | Regulatory and standards compliance review |
| `$resilience-review` | Resilience review for fault tolerance, recovery, and graceful degradation |
| `$performance-review` | Performance review for bottlenecks, efficiency, and scalability |
| `$seo-review` | SEO review for discoverability, metadata, and search ranking factors |
| `$geo-review` | Internationalization and localization review for multi-region readiness |

## Links

- [Shiplight](https://www.shiplight.ai)
- [Codex Skills Docs](https://developers.openai.com/codex/skills/)
- [Codex MCP Docs](https://developers.openai.com/codex/mcp)
