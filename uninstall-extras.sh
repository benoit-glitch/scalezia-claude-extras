#!/usr/bin/env bash
# Removes the 10 agents + 3 commands + 10 skills installed by install-extras.sh.
set -euo pipefail

CLAUDE_DIR="${HOME}/.claude"

AGENTS=(content-critic gtm-critic inbox-sweeper kb-writer modjo-tagger notion-fetcher office-hours-extractor quick-lookup transcript-indexer vault-searcher)
COMMANDS=(kb kb-add cmd)
SKILLS=(content content-delivery content-draft content-foundation content-grade content-hook content-refresh content-repurpose content-research modjo-export)

for a in "${AGENTS[@]}"; do rm -f "$CLAUDE_DIR/agents/$a.md"; done
for c in "${COMMANDS[@]}"; do rm -f "$CLAUDE_DIR/commands/$c.md"; done
for s in "${SKILLS[@]}"; do rm -rf "$CLAUDE_DIR/skills/$s"; done

echo "Removed 10 agents, 3 commands, 10 skills."
