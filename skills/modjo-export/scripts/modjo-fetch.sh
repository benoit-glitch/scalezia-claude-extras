#!/bin/bash
# modjo-fetch.sh — authenticated wrapper around the Modjo API.
# Resolves the API key from macOS Keychain (service=modjo-api, account=benoit).
# Usage: modjo-fetch.sh <METHOD> <PATH> [JSON_BODY]
# Examples:
#   modjo-fetch.sh GET /v1/calls
#   modjo-fetch.sh GET /v1/calls/abc123
#   modjo-fetch.sh POST /v1/calls/exports '{"startDate":"2026-04-01","endDate":"2026-04-13"}'

set -euo pipefail

usage() {
    printf 'usage: %s <METHOD> <PATH> [JSON_BODY]\n' "$(basename "$0")" >&2
    printf '  METHOD     HTTP method (GET, POST, PUT, DELETE)\n' >&2
    printf '  PATH       API path starting with /v1/...\n' >&2
    printf '  JSON_BODY  optional JSON body for POST/PUT\n' >&2
    exit 64
}

if [[ $# -lt 2 ]]; then
    usage
fi

METHOD=$(printf '%s' "$1" | tr '[:lower:]' '[:upper:]')
API_PATH="$2"
BODY="${3:-}"

API_BASE="https://api.modjo.ai"

# Retrieve key from Keychain
if ! API_KEY=$(security find-generic-password -s "modjo-api" -a "$USER" -w 2>/dev/null); then
    printf '[ERROR] Modjo API key not found in macOS Keychain.\n' >&2
    printf 'Expected entry: service=modjo-api, account=benoit\n' >&2
    printf 'To add: security add-generic-password -s "modjo-api" -a "$USER" -w "YOUR_KEY" -U\n' >&2
    exit 1
fi

# Validate method
case "$METHOD" in
    GET|POST|PUT|DELETE|PATCH) ;;
    *)
        printf '[ERROR] Invalid HTTP method: %s\n' "$METHOD" >&2
        usage
        ;;
esac

# Validate path
if [[ ! "$API_PATH" =~ ^/ ]]; then
    printf '[ERROR] Path must start with / (got: %s)\n' "$API_PATH" >&2
    exit 64
fi

URL="${API_BASE}${API_PATH}"

# Build curl args
CURL_ARGS=(
    --silent
    --show-error
    --fail-with-body
    --location
    --max-time 60
    --request "$METHOD"
    --header "X-API-KEY: ${API_KEY}"
    --header "Content-Type: application/json"
    --header "Accept: application/json"
)

if [[ -n "$BODY" ]]; then
    CURL_ARGS+=(--data "$BODY")
fi

# Execute
curl "${CURL_ARGS[@]}" "$URL"
EXIT=$?

# Explicitly unset the key so it's not hanging in env
unset API_KEY

exit $EXIT
