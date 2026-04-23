---
name: modjo-export
description: Fetch Modjo call recordings, transcripts, and exports via the Modjo API. Authenticates automatically using the 'modjo-api' entry in the macOS Keychain — never hardcode the key. Use for retrieving recent calls, specific call IDs, exporting ranges, or feeding the modjo-tagger agent.
user-invocable: true
disable-model-invocation: false
---

# modjo-export

Authenticated wrapper around the Modjo API. Resolves the API key from the macOS Keychain at call time and makes the requested HTTP call.

## Authentication

The API key lives in the macOS Keychain under:
- service: `modjo-api`
- account: `benoit`

Retrieved with:
```
security find-generic-password -s "modjo-api" -a "$USER" -w
```

**Never hardcode the key in prompts, scripts, or settings files.** If the keychain lookup fails, the script exits with a clear error message.

## Usage

Run the wrapper script with a method + path + optional JSON body:

```
~/.claude/skills/modjo-export/scripts/modjo-fetch.sh <METHOD> <PATH> [JSON_BODY]
```

Examples:

```
# List recent calls
~/.claude/skills/modjo-export/scripts/modjo-fetch.sh GET /v1/calls

# Get a specific call by ID
~/.claude/skills/modjo-export/scripts/modjo-fetch.sh GET /v1/calls/abc123

# Export calls in a date range
~/.claude/skills/modjo-export/scripts/modjo-fetch.sh POST /v1/calls/exports '{"startDate":"2026-04-01","endDate":"2026-04-13"}'
```

Response is JSON on stdout. Errors go to stderr.

## When to use

- User asks to pull Modjo calls (recent, specific, by date range, by owner)
- `modjo-tagger` agent invokes this skill as part of its daily 10am sweep
- Any workflow that needs authenticated Modjo API access

## When NOT to use

- The user is asking about Modjo docs or UI (use `WebFetch(domain:help.modjo.ai)` instead)
- The request doesn't need API access (e.g. analyzing already-exported data in the vault)

## Reference

- Modjo API base: `https://api.modjo.ai`
- Modjo API docs: `https://help.modjo.ai` or `https://api.modjo.ai` (ask the user if unsure about an endpoint)
- Keychain entry was created on 2026-04-13 during the CLAUDE.md audit setup
- If the key needs rotation, update the keychain entry with:
  `security add-generic-password -s "modjo-api" -a "$USER" -w "NEW_KEY" -U`
