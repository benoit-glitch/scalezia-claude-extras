#!/usr/bin/env bash
# Installs custom Scalezia agents + commands + skills into ~/.claude/.
# Pairs with claude-code-hooks-scalezia and scalezia-kb-starter.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"

echo ""
echo "=========================================="
echo " Scalezia Claude Extras: installer"
echo "=========================================="
echo ""

# Ensure ~/.claude/ structure
mkdir -p "$CLAUDE_DIR/agents" "$CLAUDE_DIR/commands" "$CLAUDE_DIR/skills"

# Copy agents
echo "[1/3] Installing 10 agents..."
cp "$SCRIPT_DIR"/agents/*.md "$CLAUDE_DIR/agents/"
echo "      Done."

# Copy commands
echo "[2/3] Installing 3 slash commands..."
cp "$SCRIPT_DIR"/commands/*.md "$CLAUDE_DIR/commands/"
echo "      Done."

# Copy skills (directories)
echo "[3/3] Installing 10 skills..."
COUNT=0
for skill_dir in "$SCRIPT_DIR"/skills/*/; do
    name=$(basename "$skill_dir")
    rm -rf "$CLAUDE_DIR/skills/$name"
    cp -R "$skill_dir" "$CLAUDE_DIR/skills/$name"
    COUNT=$((COUNT + 1))
done
echo "      Installed $COUNT skills."

echo ""
echo "Installation complete."
echo ""
echo "Next steps:"
echo "  1. Ensure VAULT_PATH is set in ~/.claude/hooks.env (from claude-code-hooks-scalezia install)."
echo "  2. For modjo-export: store your Modjo API key with:"
echo "       security add-generic-password -a "\$USER" -s "modjo-api" -w "YOUR_KEY""
echo "  3. Restart Claude Code."
echo ""
