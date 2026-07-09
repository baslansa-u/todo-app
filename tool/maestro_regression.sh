#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tool/maestro_common.sh
source "$SCRIPT_DIR/maestro_common.sh"

run_maestro_flow ".maestro/regression/${PLATFORM}_search.yaml"
run_maestro_flow ".maestro/regression/${PLATFORM}_filters_completion.yaml"
