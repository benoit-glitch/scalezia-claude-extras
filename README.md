# scalezia-claude-extras

10 custom agents + 3 slash commands + 10 skills for Claude Code, genericized from the Scalezia setup.

Companion to:
- [`benoit-glitch/claude-code-hooks-scalezia`](https://github.com/benoit-glitch/claude-code-hooks-scalezia) (9 Python hooks)
- [`benoit-glitch/scalezia-kb-starter`](https://github.com/benoit-glitch/scalezia-kb-starter) (Obsidian vault starter)

## Contents

### Agents (10, in `agents/`)

Invoked via the `Task` tool with `subagent_type: <name>`.

| Agent | Purpose |
|---|---|
| `vault-searcher` | Fast grep/glob search across the Obsidian vault. Returns wikilinks and context. |
| `kb-writer` | Given a conversation snippet or idea, draft a vault-ready note with YAML frontmatter. |
| `content-critic` | Review LinkedIn posts, newsletters, scripts against your voice profile + KB insights. |
| `gtm-critic` | Review GTM deliverables in Notion against the GTM framework. |
| `inbox-sweeper` | Daily triage of `03-Intelligence/Idées/Inbox/`: promote or archive. |
| `modjo-tagger` | Daily tagging of Modjo call recordings with theme + frustration + action. |
| `notion-fetcher` | Fetch Notion pages by ID, URL, or search query (read-only). |
| `office-hours-extractor` | Daily PSP-filtered idea extraction from office-hours recordings. |
| `quick-lookup` | Fast file finder for the home directory (outside vault). |
| `transcript-indexer` | One-line triage per transcript file: theme, speaker, date, topic. |

### Commands (3, in `commands/`)

| Command | Purpose |
|---|---|
| `/kb` | Load the vault Context Brief into the current session. |
| `/kb-add` | Add a new note to the vault via the `kb-writer` agent. |
| `/cmd` | Show a menu of available Scalezia slash commands. |

### Skills (10, in `skills/`)

Content pipeline (9 skills) + Modjo export wrapper.

| Skill | Purpose |
|---|---|
| `content-foundation` | Build the 3 foundation assets: Voice Profile (25Q), ICP, Content Pillars. |
| `content-research` | Research a content angle using vault + external sources. |
| `content-hook` | Generate LinkedIn hooks applying Hook Families + Ban List. |
| `content-draft` | Draft a full LinkedIn post from a hook and pillar. |
| `content-grade` | Score a post against the 100-point Scoring Grid. |
| `content-refresh` | Detect voice drift and suggest Voice Profile refresh. |
| `content-repurpose` | Adapt a post across Thread X, Newsletter, Instagram. |
| `content-delivery` | Publish-ready formatting and metadata per platform. |
| `content` | Orchestrator meta-skill that sequences the others. |
| `modjo-export` | Authenticated wrapper around the Modjo API (Keychain-based). |

## Prerequisites

- macOS, Linux, or WSL
- Python 3.9+ (for `_audit.py` logging, if you also installed hooks)
- Claude Code installed
- For `modjo-export`: a Modjo account with API access (Admin or Manager permission)
- Recommended: the companion hooks and starter kit (see links above)

## Install

```bash
git clone https://github.com/benoit-glitch/scalezia-claude-extras.git
cd scalezia-claude-extras
./install-extras.sh
```

The installer copies:
- `agents/*.md` → `~/.claude/agents/`
- `commands/*.md` → `~/.claude/commands/`
- `skills/*/` → `~/.claude/skills/`

## Post-install

1. Restart Claude Code (`/exit` then relaunch) for new agents and commands to be discovered.
2. If you also installed `claude-code-hooks-scalezia`, the hooks will reference these skills automatically (kb-first-reminder, skill-feedback-reminder).
3. For `modjo-export`, store your API key in the macOS Keychain:
   ```bash
   security add-generic-password -a "$USER" -s "modjo-api" -w "YOUR_MODJO_API_KEY"
   ```
4. Test an agent: in Claude Code, say `Use the vault-searcher agent to find references to "PSP" in my vault`.

## Uninstall

```bash
./uninstall-extras.sh
```

Removes all 10 agents, 3 commands, and 10 skills from `~/.claude/`.

## What is NOT included

- **`/gtm-v2-*` commands** (8 commands): they depend on a private `gtm-agent-v2` plugin with a vault-canonical snapshot, not shipped. Use the public GTM methodology documented in the `scalezia-kb-starter` repo instead.
- **`/office-hours` command** and **`/level-up` command**: hardcoded to specific Modjo calls and Benoit-specific content. Use `office-hours-extractor` agent (generic) instead.

## License

MIT. See `LICENSE`.
