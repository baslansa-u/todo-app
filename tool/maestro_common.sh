#!/usr/bin/env bash
set -euo pipefail

PLATFORM="${PLATFORM:-ios}"
DEVICE="${DEVICE:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

case "$PLATFORM" in
  ios)
    APP_ID="${APP_ID:-com.example.todoApp}"
    ;;
  android)
    APP_ID="${APP_ID:-com.example.todo_app}"
    ;;
  *)
    echo "Unsupported PLATFORM '$PLATFORM'. Use 'ios' or 'android'." >&2
    exit 2
    ;;
esac

if [ -z "$DEVICE" ]; then
  echo "DEVICE is required. Example: DEVICE=<simulator-or-emulator-id> $0" >&2
  exit 2
fi

run_maestro_flow() {
  local flow="$1"

  echo
  echo "==> Running $flow"
  (cd "$REPO_ROOT" && APP_ID="$APP_ID" maestro --device "$DEVICE" test "$flow")
}
