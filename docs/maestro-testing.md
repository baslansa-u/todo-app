# Maestro Testing Architecture

This project keeps Maestro flows under `.maestro/` and separates scenario intent from reusable UI operations.

## Directory Layout

- `.maestro/smoke/`: fastest critical-path checks. These should prove the app launches and the main todo creation path works.
- `.maestro/features/todo/`: focused feature-level checks for one todo behavior at a time.
- `.maestro/regression/`: broader checks for combinations that have historically higher risk, such as filtering and search.
- `.maestro/e2e/`: full user journeys across create, edit, complete, filter, and delete.
- `.maestro/helpers/`: reusable flows only. Helpers should not be executed directly as suite entry points.

## Execution Policy

All local single-device execution must be sequential. Do not pass multiple flow files or a folder to one `maestro test` command when targeting one simulator/emulator. This Maestro version may run multiple flows concurrently, which can race against the same app install, launch state, and persisted data.

Use the category scripts for local and CI single-device runs. They run one flow at a time and fail fast on the first failure:

```sh
DEVICE=<simulator-or-emulator-id> PLATFORM=ios ./tool/maestro_smoke.sh
DEVICE=<simulator-or-emulator-id> PLATFORM=ios ./tool/maestro_regression.sh
DEVICE=<simulator-or-emulator-id> PLATFORM=ios ./tool/maestro_e2e.sh
```

For Android, use `PLATFORM=android`. `APP_ID` is set automatically from `PLATFORM`, but can be overridden if needed.

- Local development: run smoke tests before pushing UI or state-management changes.
  - `DEVICE=<device-id> PLATFORM=ios ./tool/maestro_smoke.sh`
  - `DEVICE=<device-id> PLATFORM=android ./tool/maestro_smoke.sh`
- Pull request validation: run smoke and feature tests.
  - Run `tool/maestro_smoke.sh`.
  - Run feature flows one at a time, not as a folder batch, until a feature runner is added.
- Nightly regression: run smoke, feature, regression, and E2E tests.
  - Run `tool/maestro_smoke.sh`, then `tool/maestro_regression.sh`, then `tool/maestro_e2e.sh` per simulator/emulator.
- Release testing: run the full Maestro suite on every supported release device/profile, plus Flutter unit/widget/integration tests.
  - Run the same nightly set sequentially on every supported release device/profile.
  - Also run Flutter unit/widget/integration tests.

## Authoring Rules

- Every top-level flow should test one user-visible behavior.
- Repeated actions belong in `.maestro/helpers/`.
- Prefer stable accessibility labels over coordinates. Add Flutter `tooltip` or `semanticLabel` values when a control has no visible text.
- Keep helper data deterministic. This suite uses fixture-specific helpers because this Maestro CLI did not interpolate helper `env` values reliably in nested flows.
- Add comments only when they clarify setup, platform handling, or why a helper exists.

## Current Platform Coverage

The suite has Android and iOS entry flows:

- Android app ID: `com.example.todo_app`
- iOS app ID: `com.example.todoApp`
- Shared helper flows: `.maestro/helpers/`
