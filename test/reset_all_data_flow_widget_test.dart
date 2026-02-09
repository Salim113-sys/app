import 'package:daily_reset/providers/daily_log_provider.dart';
import 'package:daily_reset/providers/habit_provider.dart';
import 'package:daily_reset/providers/hydration_provider.dart';
import 'package:daily_reset/providers/theme_provider.dart';
import 'package:daily_reset/providers/workout_provider.dart';
import 'package:daily_reset/screens/settings_screen.dart';
import 'package:daily_reset/services/daily_log_service.dart';
import 'package:daily_reset/services/habit_service.dart';
import 'package:daily_reset/services/hydration_repository.dart';
import 'package:daily_reset/services/notification_service.dart';
import 'package:daily_reset/services/storage_service.dart';
import 'package:daily_reset/services/workout_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Reset All Data flow works in widget test fallback', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    final storage = await StorageService.getInstance();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    final notificationService = NotificationService();
    final habitService = HabitService(storage);
    final dailyLogService = DailyLogService(storage);
    final hydrationRepository = HydrationRepository(storage);
    final workoutRepository = await WorkoutRepository.create();

    final router = GoRouter(
      initialLocation: '/settings',
      routes: [
        GoRoute(path: '/', redirect: (_, __) => '/home'),
        GoRoute(
          path: '/home',
          builder: (_, __) => const Scaffold(
            body: Center(
              child: Text('Home Stub', key: Key('test_home_stub')),
            ),
          ),
        ),
        GoRoute(
          path: '/settings',
          builder: (_, __) => const SettingsScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider(storage)),
          Provider<NotificationService>.value(value: notificationService),
          ChangeNotifierProvider(
            create: (_) => HabitProvider(habitService, notificationService),
          ),
          ChangeNotifierProvider(
            create: (_) => DailyLogProvider(dailyLogService),
          ),
          ChangeNotifierProvider(
            create: (_) =>
                HydrationProvider(hydrationRepository, notificationService),
          ),
          ChangeNotifierProvider(
            create: (_) => WorkoutProvider(workoutRepository),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    await prefs.setString(
      'habits',
      '[{"id":"h1","name":"Habit 1","description":null,"category":"life","programId":"general","targetDaysPerWeek":3,"reminderTimeMinutes":null,"reminderDays":null,"createdAt":"2026-02-09T00:00:00.000","updatedAt":"2026-02-09T00:00:00.000","isEnabled":true}]',
    );
    await prefs.setString(
      'daily_logs',
      '[{"id":"l1","date":"2026-02-09T00:00:00.000","mood":null,"completedHabitIds":[],"createdAt":"2026-02-09T00:00:00.000","updatedAt":"2026-02-09T00:00:00.000"}]',
    );
    await prefs.setString('hydration_settings_v1', '{"dailyGoalMl":2200}');
    await prefs.setString('movement_settings_v1', '{"enabled":true}');
    await prefs.setString('movement_session_logs_v1', '[{"date":"2026-01-01"}]');
    await prefs.setString('deep_work_settings_v1', '{"enabled":true}');
    await prefs.setString(
      'workout_session_logs_v1',
      '[{"id":"w1","routineId":"quick_full_body","startTime":"2026-02-09T08:00:00.000","endTime":"2026-02-09T08:15:00.000","completedStepsCount":5,"skippedStepsCount":0,"totalMinutes":15,"intensity":"medium"}]',
    );
    await prefs.setString('app_theme_mode', 'dark');
    await prefs.setBool('daily_reminders_enabled', false);
    await prefs.setStringList('managed_notification_ids', <String>['123', '456']);
    await prefs.setString('hydration_entries_2026-02-09', '[]');
    await prefs.setString('deep_work_entries_2026-02-09', '[]');

    final resetTileFinder = find.byKey(const Key('settings_reset_all_data_tile'));
    expect(resetTileFinder, findsOneWidget);
    await tester.tap(resetTileFinder);
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byKey(const Key('settings_reset_dialog')), findsOneWidget);

    final confirmResetFinder =
        find.byKey(const Key('settings_confirm_reset_button'));
    expect(confirmResetFinder, findsOneWidget);
    await tester.tap(confirmResetFinder);
    await tester.pump(const Duration(seconds: 1));
    for (var i = 0; i < 50; i++) {
      if (router.routeInformationProvider.value.uri.path == '/home' &&
          find.byKey(const Key('test_home_stub')).evaluate().isNotEmpty) {
        break;
      }
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(tester.takeException(), isNull);
    expect(find.byKey(const Key('settings_reset_dialog')), findsNothing);
    expect(router.routeInformationProvider.value.uri.path, '/home');
    expect(find.byKey(const Key('test_home_stub')), findsOneWidget);
    expect(find.text('All data has been reset.'), findsOneWidget);

    final keys = prefs.getKeys();
    expect(keys.contains('habits'), isFalse);
    expect(keys.contains('daily_logs'), isFalse);
    expect(keys.contains('hydration_settings_v1'), isFalse);
    expect(keys.contains('movement_settings_v1'), isFalse);
    expect(keys.contains('movement_session_logs_v1'), isFalse);
    expect(keys.contains('deep_work_settings_v1'), isFalse);
    expect(keys.contains('workout_session_logs_v1'), isFalse);
    expect(keys.contains('managed_notification_ids'), isFalse);
    expect(keys.any((k) => k.startsWith('hydration_entries_')), isFalse);
    expect(keys.any((k) => k.startsWith('deep_work_entries_')), isFalse);
    expect(prefs.getBool('daily_reminders_enabled'), isTrue);
    expect(prefs.getString('app_theme_mode'), 'system');
  });
}
