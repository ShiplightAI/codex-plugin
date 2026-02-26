#!/usr/bin/env bash
set -euo pipefail

# Shiplight Codex Plugin Installer
# Installs skills and MCP config for Codex

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCOPE="user"
ALL=false

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Install Shiplight skills and MCP config for Codex.

Options:
  --all             Install all skills including Shiplight cloud
  --scope <value>   Install scope: "user" (default) or "project"
                    project: .agents/skills/ and .codex/config.toml
                    user:    ~/.agents/skills/ and ~/.codex/config.toml
  --help            Show this help message

Examples:
  bash install.sh                     # Install verify skill (user-level)
  bash install.sh --all              # Install all skills including Shiplight cloud
  bash install.sh --scope project    # Install to current project only
EOF
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --all) ALL=true; shift ;;
    --scope)
      if [[ -z "${2:-}" ]]; then
        echo "Error: --scope requires a value (project or user)"
        exit 1
      fi
      if [[ "$2" != "project" && "$2" != "user" ]]; then
        echo "Error: --scope must be 'project' or 'user'"
        exit 1
      fi
      SCOPE="$2"; shift 2 ;;
    --help|-h) usage ;;
    *) echo "Unknown option: $1"; usage ;;
  esac
done

if [ "$SCOPE" = "user" ]; then
  SKILLS_DIR="$HOME/.agents/skills"
  CODEX_DIR="$HOME/.codex"
else
  SKILLS_DIR=".agents/skills"
  CODEX_DIR=".codex"
fi

if [ "$ALL" = true ]; then
  SKILLS="shiplight cloud-tests"
  EDITION="full"
else
  SKILLS="shiplight"
  EDITION="standard"
fi

echo "Installing Shiplight Codex plugin ($EDITION, scope=$SCOPE)..."
echo ""

# --- Install skills ---
# Resolve SKILLS_DIR to absolute path for comparison
ABS_SKILLS_DIR="$(cd "$SKILLS_DIR" 2>/dev/null && pwd || echo "$SKILLS_DIR")"

for skill in $SKILLS; do
  src="$SCRIPT_DIR/agents/skills/$skill"
  dest="$SKILLS_DIR/$skill"
  abs_dest="$ABS_SKILLS_DIR/$skill"

  # Skip if source and destination are the same directory
  if [ "$src" = "$abs_dest" ]; then
    echo "  Skill already in place: $skill"
    echo "    $dest/SKILL.md (no copy needed)"
    continue
  fi

  if [ -d "$dest" ]; then
    echo "  Updating skill: $skill"
  else
    echo "  Installing skill: $skill"
  fi

  mkdir -p "$dest/agents"
  cp "$src/SKILL.md" "$dest/SKILL.md"
  echo "    $src/SKILL.md -> $dest/SKILL.md"
  if [ -f "$src/agents/openai.yaml" ]; then
    cp "$src/agents/openai.yaml" "$dest/agents/openai.yaml"
    echo "    $src/agents/openai.yaml -> $dest/agents/openai.yaml"
  fi
done

# --- Install MCP server ---
echo "  Installing @shiplightai/mcp globally..."
npm install -g @shiplightai/mcp

# --- Install MCP config ---
mkdir -p "$CODEX_DIR"
CONFIG_FILE="$CODEX_DIR/config.toml"

if [ -f "$CONFIG_FILE" ]; then
  # Check if browser server is already configured
  if grep -q '\[mcp_servers\.browser\]' "$CONFIG_FILE" 2>/dev/null; then
    echo "  Browser MCP server already configured in $CONFIG_FILE"
  else
    echo "  Appending browser MCP server to $CONFIG_FILE"
    cat >> "$CONFIG_FILE" <<'TOML'

[mcp_servers.browser]
command = "shiplight-mcp"
TOML
  fi
else
  echo "  Creating $CONFIG_FILE"
  cp "$SCRIPT_DIR/codex/config.toml" "$CONFIG_FILE"
  echo "    $SCRIPT_DIR/codex/config.toml -> $CONFIG_FILE"
fi

echo ""
echo "Done!"
echo ""
echo "Next steps:"
echo "  1. Open Codex in your project"
echo "  2. Use \$verify to test UI changes in a browser"
if [ "$ALL" = true ]; then
  echo "  3. Use \$cloud-tests to manage cloud test cases"
fi
