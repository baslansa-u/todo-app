#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tool/maestro_common.sh
source "$SCRIPT_DIR/maestro_common.sh"

run_maestro_flow ".maestro/e2e/${PLATFORM}_todo_lifecycle.yaml"
