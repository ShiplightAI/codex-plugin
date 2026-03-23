#!/usr/bin/env bash
set -euo pipefail

# Shiplight Codex Plugin Installer
# Installs skills and MCP config for Codex

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCOPE="project"

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Install Shiplight skills and MCP config for Codex.

Options:
  --scope <value>   Install scope: "project" (default) or "user"
                    project: .agents/skills/ and .codex/config.toml
                    user:    ~/.agents/skills/ and ~/.codex/config.toml
  --help            Show this help message

Examples:
  bash install.sh                     # Install to current project
  bash install.sh --scope user        # Install to user-level
EOF
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
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

SKILLS="verify create_e2e_tests cloud review design-review security-review privacy-review compliance-review resilience-review performance-review seo-review geo-review"

echo "Installing Shiplight Codex plugin (scope=$SCOPE)..."
if [ "$SCOPE" = "user" ]; then
  echo "  Destination: $HOME/.agents/skills/ and $HOME/.codex/"
else
  echo "  Destination: $(pwd)/.agents/skills/ and $(pwd)/.codex/"
fi
echo ""
read -r -p "Proceed with installation? [Y/n] " CONFIRM
CONFIRM="${CONFIRM:-Y}"
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
  echo "Installation cancelled."
  exit 0
fi
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

  mkdir -p "$dest"
  cp "$src/SKILL.md" "$dest/SKILL.md"
  echo "    $src/SKILL.md -> $dest/SKILL.md"
done

# --- Install MCP config ---
mkdir -p "$CODEX_DIR"
CONFIG_FILE="$CODEX_DIR/config.toml"

if [ -f "$CONFIG_FILE" ]; then
  if grep -q '\[mcp_servers\.shiplight\]' "$CONFIG_FILE" 2>/dev/null; then
    echo "  Shiplight MCP server already configured in $CONFIG_FILE"
  else
    echo "  Appending Shiplight MCP server to $CONFIG_FILE"
    cat >> "$CONFIG_FILE" <<'TOML'

[mcp_servers.shiplight]
command = "npx"
args = ["--yes", "@shiplightai/mcp@latest"]

[mcp_servers.shiplight.env]
PWDEBUG = "console"
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
echo "  3. Use \$create_e2e_tests to scaffold a local Shiplight test project"
echo "  4. Use \$cloud to sync test cases with Shiplight cloud"
