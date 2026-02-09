# Reset Factory Reset Verification

## Purpose
Manual verification checklist for the factory reset flow in `SettingsScreen`.
This validates that the previous crash path (missing `MovementProvider` / `DeepWorkProvider` lookup during reset) is no longer user-visible.

## Preconditions
- Build is up to date.
- App launches successfully.
- You can access **Settings**.
- Optional: create sample data first (habits/logs/hydration/workout) to validate data-clearing behavior.

## Manual Steps
1. Launch the app.
2. Navigate to **Settings**.
3. Open **Data & Privacy**.
4. Tap **Reset All Data**.
5. In the confirmation dialog, tap **Reset Data**.

## Expected Results
- No crash occurs after tapping **Reset Data**.
- Reset action is not stuck (UI returns to normal interactive state).
- Success feedback is shown (`All data has been reset.` snackbar).
- App navigates/refocuses to the home route (`/`) after completion.
- Previously stored user data is cleared:
  - habits
  - daily logs
  - hydration settings/entries
  - movement settings/logs
  - deep work settings/entries
  - workout session logs

## Regression Focus (previous failure mode)
- Trigger reset when `MovementProvider` and/or `DeepWorkProvider` are not available in the provider tree.
- Expected: reset still completes without `ProviderNotFoundException`.

## Manual Regression Test (Missing Optional Providers)
- Reset handles the case where `MovementProvider`/`DeepWorkProvider` are absent from the provider tree (`ProviderNotFoundException` is caught).
- No special debug flavor/config is needed.

Safe, reversible steps:
1. Run the app in debug (`flutter run -d chrome --no-resident`).
2. Navigate to **Settings** -> **Data & Privacy** -> **Reset All Data**.
3. Confirm **Reset Data**.
4. Verify reset completes (no crash, snackbar appears, returns to `/`).
5. Close the app.

Revert:
- No revert action is required because this procedure does not modify code or runtime configuration.

## Validation Commands
Run from project root:

```powershell
flutter analyze
flutter test
flutter run -d chrome --no-resident
```

## Pass Criteria
- `flutter analyze`: no issues found.
- `flutter test`: all tests pass.
- `flutter run -d chrome --no-resident`: app launches and exits without runtime reset-flow errors.

## Automated Coverage Notes
- Chrome does not currently support `integration_test` execution via `flutter test integration_test -d chrome`.
- Reset-flow automation for Chrome/dev CI is covered by widget fallback test:

```powershell
flutter test test/reset_all_data_flow_widget_test.dart
```

- `integration_test/reset_all_data_flow_test.dart` is kept for device lanes.
- Canonical Android emulator integration lane in this repo:

```powershell
flutter drive --driver integration_test/driver.dart --target integration_test/reset_all_data_flow_test.dart -d emulator-5554 --timeout 300
```

- Current environment result for the Android lane above: PASS (reset dialog, confirm flow, route/home proof, and post-reset key/default assertions).

## CI/PR Checklist
- Run required gates from project root:

```powershell
flutter analyze
flutter test
flutter run -d chrome --no-resident
```

- Manual regression (missing optional providers):
1. Run the app in debug (`flutter run -d chrome --no-resident`).
2. Navigate to **Settings** -> **Data & Privacy** -> **Reset All Data**.
3. Confirm **Reset Data**.
4. Verify reset completes (no crash, snackbar appears, returns to `/`).

- Update **Run Log** after each validation run:
  Fill `Date`, `Platform (Chrome/Android)`, `Result (PASS/FAIL)`, and `Notes`.

## Run Log

| Date | Platform (Chrome/Android) | Build/Branch | Result (PASS/FAIL) | Notes |
|---|---|---|---|---|
| 2026-02-08 | Chrome | local | PASS | Automated gates passed. Manual UI reset-flow regression not executed in this non-interactive session (PENDING). |
