import 'package:daily_reset/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Finder _settingsNavFinder() {
  return find.byKey(const Key('main_nav_settings')).hitTestable();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Reset All Data flow works end-to-end', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.setBool('onboarding_completed', true);
    await prefs.setString('habits', '[]');
    await prefs.setString('daily_logs', '[]');
    await prefs.setString('hydration_settings_v1', '{"dailyGoalMl":2000}');
    await prefs.setString('movement_settings_v1', '{"enabled":true}');
    await prefs.setString('movement_session_logs_v1', '[{"date":"2026-02-01"}]');
    await prefs.setString('deep_work_settings_v1', '{"enabled":true}');
    await prefs.setString(
      'workout_session_logs_v1',
      '[{"id":"w1","routineId":"quick_full_body","startTime":"2026-02-09T08:00:00.000","endTime":"2026-02-09T08:15:00.000","completedStepsCount":5,"skippedStepsCount":0,"totalMinutes":15,"intensity":"medium"}]',
    );
    await prefs.setString('app_theme_mode', 'dark');
    await prefs.setBool('daily_reminders_enabled', false);
    await prefs.setStringList('managed_notification_ids', <String>['101', '202']);
    await prefs.setString('hydration_entries_2026-02-09', '[]');
    await prefs.setString('deep_work_entries_2026-02-09', '[]');

    app.main();
    await tester.pump();
    for (var i = 0; i < 50; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (find.byKey(const Key('main_nav_settings')).evaluate().isNotEmpty ||
          find.text('Skip').evaluate().isNotEmpty) {
        break;
      }
    }

    // If onboarding still appears (web storage variation), dismiss it safely.
    final skipFinder = find.text('Skip');
    if (skipFinder.evaluate().isNotEmpty) {
      await tester.tap(skipFinder);
      await tester.pumpAndSettle();
    }

    var settingsNavFinder = _settingsNavFinder();
    final navBarFinder = find.byKey(const Key('main_navigation_bar'));
    if (settingsNavFinder.evaluate().isEmpty) {
      settingsNavFinder = find
          .descendant(
            of: navBarFinder,
            matching: find.byIcon(Icons.settings_outlined),
          )
          .hitTestable();
    }
    if (settingsNavFinder.evaluate().isEmpty) {
      settingsNavFinder = find
          .descendant(
            of: navBarFinder,
            matching: find.byKey(const Key('main_nav_settings_selected')),
          )
          .hitTestable();
    }
    expect(settingsNavFinder, findsOneWidget);
    await tester.tap(settingsNavFinder);
    await tester.pumpAndSettle();

    final resetTileFinder = find.byKey(const Key('settings_reset_all_data_tile'));
    expect(resetTileFinder, findsOneWidget);
    await tester.tap(resetTileFinder);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('settings_reset_dialog')), findsOneWidget);

    final confirmResetFinder =
        find.byKey(const Key('settings_confirm_reset_button'));
    expect(confirmResetFinder, findsOneWidget);
    await tester.tap(confirmResetFinder);
    await tester.pump();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byKey(const Key('settings_reset_dialog')), findsNothing);

    final context = tester.element(find.byKey(const Key('main_navigation_bar')));
    final currentPath = GoRouter.of(context).routeInformationProvider.value.uri.path;
    expect(currentPath, anyOf('/', '/home'));
    final keys = prefs.getKeys();
    expect(keys.contains('habits'), isFalse);
    expect(keys.contains('daily_logs'), isFalse);
    expect(keys.contains('hydration_settings_v1'), isFalse);
    expect(keys.contains('movement_settings_v1'), isFalse);
    expect(keys.contains('movement_session_logs_v1'), isFalse);
    expect(keys.contains('deep_work_settings_v1'), isFalse);
    expect(keys.contains('workout_session_logs_v1'), isFalse);
    expect(keys.any((key) => key.startsWith('hydration_entries_')), isFalse);
    expect(keys.any((key) => key.startsWith('deep_work_entries_')), isFalse);
    expect(prefs.getBool('daily_reminders_enabled'), isTrue);
    expect(prefs.getStringList('managed_notification_ids'), isNull);
    expect(prefs.getString('app_theme_mode'), 'system');
    expect(prefs.getBool('onboarding_completed'), isTrue);
  });
}
