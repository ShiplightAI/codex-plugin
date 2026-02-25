#!/usr/bin/env bash
set -euo pipefail

# Shiplight Codex Plugin Installer
# Installs skills and MCP config for Codex

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL=false
FREE=false

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Install Shiplight skills and MCP config for Codex.

Options:
  --free      Install free version only (MCP browser tools + verify skill)
  --global    Install to user-level (~/.agents/skills/ and ~/.codex/config.toml)
              Default: project-level (.agents/skills/ and .codex/config.toml)
  --help      Show this help message

Examples:
  bash install.sh            # Install all skills
  bash install.sh --free     # Install free version (verify only)
  bash install.sh --global   # Install for all projects
EOF
  exit 0
}

for arg in "$@"; do
  case "$arg" in
    --free) FREE=true ;;
    --global) GLOBAL=true ;;
    --help|-h) usage ;;
    *) echo "Unknown option: $arg"; usage ;;
  esac
done

if [ "$GLOBAL" = true ]; then
  SKILLS_DIR="$HOME/.agents/skills"
  CODEX_DIR="$HOME/.codex"
  SCOPE="user-level"
else
  SKILLS_DIR=".agents/skills"
  CODEX_DIR=".codex"
  SCOPE="project-level"
fi

if [ "$FREE" = true ]; then
  SKILLS="verify"
  EDITION="free"
else
  SKILLS="verify shiplight"
  EDITION="full"
fi

echo "Installing Shiplight Codex plugin ($EDITION, $SCOPE)..."
echo ""

# --- Install skills ---
for skill in $SKILLS; do
  src="$SCRIPT_DIR/.agents/skills/$skill"
  dest="$SKILLS_DIR/$skill"

  if [ -d "$dest" ]; then
    echo "  Updating skill: $skill"
  else
    echo "  Installing skill: $skill"
  fi

  mkdir -p "$dest/agents"
  cp "$src/SKILL.md" "$dest/SKILL.md"
  if [ -f "$src/agents/openai.yaml" ]; then
    cp "$src/agents/openai.yaml" "$dest/agents/openai.yaml"
  fi
done

# --- Install MCP config ---
mkdir -p "$CODEX_DIR"
CONFIG_FILE="$CODEX_DIR/config.toml"

if [ -f "$CONFIG_FILE" ]; then
  # Check if browser server is already configured
  if grep -q '\[mcp_servers\.browser\]' "$CONFIG_FILE" 2>/dev/null; then
    echo "  MCP config: browser server already configured in $CONFIG_FILE"
  else
    echo "  MCP config: appending browser server to $CONFIG_FILE"
    cat >> "$CONFIG_FILE" <<'TOML'

[mcp_servers.browser]
command = "npx"
args = ["-y", "@shiplightai/mcp@latest"]

[mcp_servers.browser.env]
PWDEBUG = "console"
TOML
  fi
else
  echo "  MCP config: creating $CONFIG_FILE"
  cp "$SCRIPT_DIR/.codex/config.toml" "$CONFIG_FILE"
fi

echo ""
echo "Done! Installed:"
echo "  - $SKILLS_DIR/verify/SKILL.md        (browser verification skill)"
if [ "$FREE" = false ]; then
  echo "  - $SKILLS_DIR/shiplight/SKILL.md     (cloud test management skill)"
fi
echo "  - $CONFIG_FILE                        (MCP server config)"
echo ""
echo "Next steps:"
echo "  1. Open Codex in your project"
echo "  2. Use \$verify to test UI changes in a browser"
if [ "$FREE" = false ]; then
  echo "  3. Use \$shiplight to manage cloud test cases"
fi
