# RESET SAFETY AUDIT

Date: 2026-02-08
Scope: reset/clear flows and UI busy-state safety (`factoryReset`, `clearAllData`, `clearAll`, loading/reset flags).

## Commands Run

```powershell
rg -n "factoryReset|resetAll|reset.*Data|clearAllData|deleteAll|wipeAll|purge" lib
rg -n "_isResetting|isResetting|isLoading|busy" lib
rg -n "ProviderNotFoundException|use_build_context_synchronously" lib
```

## Results Table

| File | Function | Risk Type | Proof (line refs) | Fix Needed (Y/N) | Minimal Fix Summary |
|---|---|---|---|---|---|
| `lib/providers/habit_provider.dart` | `loadHabits` | Busy flag invariant (`_isLoading`) | `lib/providers/habit_provider.dart:21`-`lib/providers/habit_provider.dart:23`, `lib/providers/habit_provider.dart:31`-`lib/providers/habit_provider.dart:36` | N | Sets `_isLoading = true` before work and always resets to `false` after `try/catch`; no early return after setting true. |
| `lib/providers/daily_log_provider.dart` | `loadTodayLog` | Busy flag invariant (`_isLoading`) | `lib/providers/daily_log_provider.dart:21`-`lib/providers/daily_log_provider.dart:24`, `lib/providers/daily_log_provider.dart:28`-`lib/providers/daily_log_provider.dart:33` | N | Sets `_isLoading = true` and always resets to `false` after `try/catch`; no early return after setting true. |
| `lib/screens/habit_form_screen.dart` | `_saveHabit` | Busy flag invariant (`_isLoading`) + context-after-await guard | `lib/screens/habit_form_screen.dart:308`-`lib/screens/habit_form_screen.dart:312`, `lib/screens/habit_form_screen.dart:352`-`lib/screens/habit_form_screen.dart:354`, `lib/screens/habit_form_screen.dart:369`-`lib/screens/habit_form_screen.dart:374` | N | Uses `try/catch/finally`; `_isLoading` is reset in `finally` when mounted; post-await context usage is mounted-guarded. |
| `lib/screens/settings_screen.dart` | `_DataSectionState.factoryResetApp` | Provider registration + busy-flag release safety | `lib/screens/settings_screen.dart:336`-`lib/screens/settings_screen.dart:342`, `lib/screens/settings_screen.dart:345`-`lib/screens/settings_screen.dart:362`, `lib/screens/settings_screen.dart:422`-`lib/screens/settings_screen.dart:433` | N | Reads are inside `try`; optional providers are guarded via `ProviderNotFoundException`; `_isResetting` is released in `finally`. |
| `lib/screens/settings_screen.dart` | `_NotificationSectionState._loadSettings` | Busy flag stuck on exception path | `lib/screens/settings_screen.dart:214`-`lib/screens/settings_screen.dart:226` | Y | Added `try/catch/finally` so `_isLoading` is always set to `false` (with `mounted` guard), even if `SharedPreferences.getInstance()` throws. |
| `lib/screens/settings_screen.dart` | `_NotificationSectionState._toggleReminders` | Context-after-await check | `lib/screens/settings_screen.dart:228`-`lib/screens/settings_screen.dart:232`, `lib/screens/settings_screen.dart:250`-`lib/screens/settings_screen.dart:256` | N | `context.read` happens before first `await`; post-await UI usage is guarded by `if (mounted)`. |
| `lib/screens/settings_screen.dart` | Reset dialog action (`onPressed`) | Re-entrancy / double-trigger check | `lib/screens/settings_screen.dart:487`-`lib/screens/settings_screen.dart:492`, `lib/screens/settings_screen.dart:337` | N | Dialog button is disabled while `_isResetting`; function early-returns if already resetting. |
| `lib/providers/habit_provider.dart` | `clearAllData` | Reset flow integrity | `lib/providers/habit_provider.dart:108`-`lib/providers/habit_provider.dart:116` | N | Clears storage and in-memory list; no UI context usage. |
| `lib/providers/daily_log_provider.dart` | `clearAllData` | Reset flow integrity | `lib/providers/daily_log_provider.dart:213`-`lib/providers/daily_log_provider.dart:221` | N | Clears storage and in-memory state; no UI context usage. |
| `lib/providers/hydration_provider.dart` | `clearAllData` | Notification cancel ordering / duplication check | `lib/providers/hydration_provider.dart:76`-`lib/providers/hydration_provider.dart:83`, `lib/screens/settings_screen.dart:368`-`lib/screens/settings_screen.dart:373` | N | Hydration cancel remains provider-owned; factory reset does not call hydration cancel directly. No incorrect-state duplication proven. |
| `lib/providers/movement_provider.dart` | `clearAllData` | Optional provider availability in reset | `lib/providers/movement_provider.dart:82`-`lib/providers/movement_provider.dart:90`, `lib/screens/settings_screen.dart:345`-`lib/screens/settings_screen.dart:351` | N | Reset calls this only if provider exists (`movementProvider != null`). |
| `lib/providers/deep_work_provider.dart` | `clearAllData` | Optional provider availability in reset | `lib/providers/deep_work_provider.dart:101`-`lib/providers/deep_work_provider.dart:110`, `lib/screens/settings_screen.dart:352`-`lib/screens/settings_screen.dart:377` | N | Reset calls this only if provider exists (`deepWorkProvider != null`). |
| `lib/providers/workout_provider.dart` | `clearAllData` | Reset flow integrity | `lib/providers/workout_provider.dart:30`-`lib/providers/workout_provider.dart:33` | N | Delegates clear to repository and notifies listeners; no UI context usage. |
| `lib/services/habit_service.dart` | `clearAll` | Persistence wipe safety | `lib/services/habit_service.dart:101`-`lib/services/habit_service.dart:103` | N | Explicit key removal only (`habits`). |
| `lib/services/daily_log_service.dart` | `clearAll` | Persistence wipe safety | `lib/services/daily_log_service.dart:129`-`lib/services/daily_log_service.dart:131` | N | Explicit key removal only (`daily_logs`). |
| `lib/services/hydration_repository.dart` | `clearAllData` | Prefix removal safety | `lib/services/hydration_repository.dart:126`-`lib/services/hydration_repository.dart:145` | N | Removes `hydration_settings_v1` + `hydration_entries_*`, then resets streams. |
| `lib/services/movement_repository.dart` | `clearAll` | Persistence wipe safety | `lib/services/movement_repository.dart:121`-`lib/services/movement_repository.dart:131` | N | Removes `movement_settings_v1` and `movement_session_logs_v1`, resets in-memory streams. |
| `lib/services/deep_work_repository.dart` | `clearAll` | Prefix removal safety | `lib/services/deep_work_repository.dart:116`-`lib/services/deep_work_repository.dart:131` | N | Removes `deep_work_settings_v1` + `deep_work_entries_*`, resets settings stream. |
| `lib/services/workout_repository.dart` | `clearAllData` | Persistence wipe safety | `lib/services/workout_repository.dart:88`-`lib/services/workout_repository.dart:96` | N | Removes `workout_session_logs_v1`, resets in-memory logs stream. |
| `lib/services/notification_service.dart` | `cancelAllManagedReminders` | Notification ownership safety (no foreign cancels) | `lib/services/notification_service.dart:194`-`lib/services/notification_service.dart:203` | N | Cancels only tracked managed IDs and clears managed set; no global cancel call. |

## Additional Notes

- Pattern search found no `deleteAll`, `wipeAll`, or `purge` implementation in `lib/`.
- `ProviderNotFoundException` is only used for optional reset providers and is handled (`lib/screens/settings_screen.dart:357`, `lib/screens/settings_screen.dart:362`).
- No `use_build_context_synchronously` marker was found in source by ripgrep.

## DeepSeek Critic Review (local)

Model: `deepseek-r1:7b`  
Endpoint: `http://127.0.0.1:11434/api/chat`  
Note: `git diff` was unavailable in this workspace (no git repository), so the critic reviewed the current relevant code excerpt plus this audit file content.

Verbatim critic response:

```text
Reviewing the code, I will focus solely on **busy-flag stuck paths**, **context-after-await**, and **ProviderNotFoundException** risks.

1. **Context after awaits issues**: 
   - In `_NotificationSectionState._toggleReminders()`, there's a potential issue with `context.read` before an await:
     ```dart
     final notif = context.read<NotificationService>();
     ...
     await notif.cancelAllManagedReminders();
     // [No problem here]
     
     await notif.scheduleHabitReminders(habit);
     // Here, we should check if we're still in the same context
     ```

   - In `_DataSection.factoryResetApp()`, all provider resets are guarded by `ProviderNotFoundException`, which is good.

2. **Busy flag stuck paths**:
   - In `_NotificationSectionState._loadSettings()`, there's a try-catch-finally block that ensures `_isLoading` is released even if an error occurs.
     ```dart
     Future<void> _loadSettings() async {
         try {
             final prefs = await SharedPreferences.getInstance();
             ...
             setState(() {
               _isLoading = false;
             });
         } catch (e) {
             // Error handling maintains clean UI state
         } finally {
             if (mounted) {
                 setState(() {
                   _isLoading = false;
                 });
             }
         }
     }
     ```

3. **ProviderNotFoundException risks**:
   - All optional provider resets in `_DataSection.factoryResetApp()` are properly guarded with `ProviderNotFoundException`.
   - In `_NotificationSectionState._toggleReminders()`, the use of `context.read` before await might need to ensure proper error handling.

4. **Busy flag invariant in _NotificationSectionState._loadSettings**:
   - The code uses a try-catch-finally block to safely release `_isLoading` even if an error occurs, preventing any stuck busy flags.
     ```dart
     Future<void> _loadSettings() async {
         try {
             final prefs = await SharedPreferences.getInstance();
             ...
             setState(() {
               _isLoading = false;
             });
         } catch (e) {
             // Handle errors gracefully
         } finally {
             if (mounted) {
                 setState(() {
                   _isLoading = false;
                 });
             }
         }
     }
     ```

5. **Context after await in _NotificationSectionState._toggleReminders**:
   - The context is properly checked before and after await, preventing potential reentrancy issues.

Overall, the code has good safety measures for busy flags and ProviderNotFoundException risks.
```
