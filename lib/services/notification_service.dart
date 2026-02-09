import 'dart:math';

import 'package:daily_reset/models/habit.dart';
import 'package:daily_reset/models/deep_work_settings.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// NotificationService centralizes all local notification logic.
///
/// Where it lives:
///  - File: lib/services/notification_service.dart
///
/// How it uses reminder fields:
///  - Habit.reminderTimeMinutes stores the time of day (minutes after midnight). If null => no reminders.
///  - Habit.reminderDays stores DateTime.weekday values (1=Mon..7=Sun). If null => days auto-derived from targetDaysPerWeek.
///  - When a habit is saved or updated, we cancel existing schedules for that habit and schedule new ones per day/time.
class NotificationScheduleHelper {
  static DateTime nextOccurrence({
    required DateTime now,
    required int minutesFromMidnight,
    Set<int>? weekdays,
  }) {
    final today = DateTime(now.year, now.month, now.day);
    final normalizedWeekdays = weekdays?.where((d) => d >= 1 && d <= 7).toSet();

    DateTime candidateForDay(DateTime day) {
      return DateTime(day.year, day.month, day.day).add(
        Duration(minutes: minutesFromMidnight),
      );
    }

    if (normalizedWeekdays == null || normalizedWeekdays.isEmpty) {
      final todayCandidate = candidateForDay(today);
      return todayCandidate.isAfter(now)
          ? todayCandidate
          : todayCandidate.add(const Duration(days: 1));
    }

    for (int offset = 0; offset < 14; offset++) {
      final day = today.add(Duration(days: offset));
      if (!normalizedWeekdays.contains(day.weekday)) continue;
      final candidate = candidateForDay(day);
      if (candidate.isAfter(now)) return candidate;
    }

    throw StateError('Could not compute next occurrence');
  }

  static List<int> intradaySlots({
    required int startMinutes,
    required int endMinutes,
    required int intervalMinutes,
  }) {
    if (intervalMinutes <= 0) return const [];
    if (endMinutes < startMinutes) return const [];

    final slots = <int>[];
    for (var minute = startMinutes; minute <= endMinutes; minute += intervalMinutes) {
      slots.add(minute);
    }
    return slots;
  }
}

class NotificationService {
  NotificationService();

  static const String _androidChannelId = 'daily_reset_reminders';
  static const String _androidChannelName = 'Habit Reminders';
  static const String _androidChannelDesc = 'Daily/weekly habit reminder notifications';

  static const String _androidHydrationChannelId = 'daily_reset_hydration';
  static const String _androidHydrationChannelName = 'Hydration Reminders';
  static const String _androidHydrationChannelDesc =
      'Gentle reminders to keep you hydrated throughout the day';
  static const String _masterRemindersKey = 'daily_reminders_enabled';
  static const String _managedNotificationIdsKey = 'managed_notification_ids';

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      // Timezone setup
      tz.initializeTimeZones();
      final dynamic localTimezone = await FlutterTimezone.getLocalTimezone();
      final String timeZoneName;
      if (localTimezone is String && localTimezone.isNotEmpty) {
        timeZoneName = localTimezone;
      } else {
        final dynamic identifier = localTimezone.identifier;
        if (identifier is String && identifier.isNotEmpty) {
          timeZoneName = identifier;
        } else {
          throw StateError('Unsupported timezone response: $localTimezone');
        }
      }
      tz.setLocalLocation(tz.getLocation(timeZoneName));

      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidInit);
      await _plugin.initialize(initSettings);

       // Create Android channels
      const androidChannel = AndroidNotificationChannel(
        _androidChannelId,
        _androidChannelName,
        description: _androidChannelDesc,
        importance: Importance.high,
      );
      const hydrationChannel = AndroidNotificationChannel(
        _androidHydrationChannelId,
        _androidHydrationChannelName,
        description: _androidHydrationChannelDesc,
        importance: Importance.defaultImportance,
      );
      final androidImpl = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidImpl != null) {
        await androidImpl.createNotificationChannel(androidChannel);
        await androidImpl.createNotificationChannel(hydrationChannel);
      }
      _initialized = true;
      debugPrint('NotificationService initialized for timezone: $timeZoneName');
    } catch (e) {
      debugPrint('NotificationService init error: $e');
    }
  }

  Future<bool> requestPermissions() async {
    try {
      final androidImpl = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidImpl != null) {
        final bool? granted = await androidImpl.requestNotificationsPermission();
        return granted ?? true; // Older Androids return null, treat as granted
      }
    } catch (e) {
      debugPrint('requestPermissions error: $e');
    }
    return true;
  }

  Future<bool> isMasterRemindersEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_masterRemindersKey) ?? true;
    } catch (e) {
      debugPrint('isMasterRemindersEnabled error: $e');
      // Fail-open to avoid silently disabling all scheduling.
      return true;
    }
  }

  Future<Set<int>> _loadManagedNotificationIds() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_managedNotificationIdsKey) ?? const <String>[];
    final ids = <int>{};
    for (final value in raw) {
      final parsed = int.tryParse(value);
      if (parsed != null) ids.add(parsed);
    }
    return ids;
  }

  Future<void> _saveManagedNotificationIds(Set<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    final ordered = ids.toList()..sort();
    final serialized = ordered.map((id) => id.toString()).toList();
    await prefs.setStringList(_managedNotificationIdsKey, serialized);
  }

  Future<void> _trackManagedNotificationIds(Iterable<int> ids) async {
    final toAdd = ids.toSet();
    if (toAdd.isEmpty) return;
    try {
      final current = await _loadManagedNotificationIds();
      current.addAll(toAdd);
      await _saveManagedNotificationIds(current);
    } catch (e) {
      debugPrint('trackManagedNotificationIds error: $e');
    }
  }

  Future<void> _untrackManagedNotificationIds(Iterable<int> ids) async {
    final toRemove = ids.toSet();
    if (toRemove.isEmpty) return;
    try {
      final current = await _loadManagedNotificationIds();
      for (final id in toRemove) {
        current.remove(id);
      }
      await _saveManagedNotificationIds(current);
    } catch (e) {
      debugPrint('untrackManagedNotificationIds error: $e');
    }
  }

  Future<void> cancelAllManagedReminders() async {
    try {
      if (!_initialized) {
        await _saveManagedNotificationIds(<int>{});
        return;
      }
      final managedIds = await _loadManagedNotificationIds();
      for (final id in managedIds) {
        await _plugin.cancel(id);
      }
      await _saveManagedNotificationIds(<int>{});
    } catch (e) {
      debugPrint('cancelAllManagedReminders error: $e');
    }
  }

  // Compute reminder days if not specified: spread across the week based on targetDaysPerWeek.
  List<int> _deriveReminderDays(int targetDaysPerWeek) {
    switch (targetDaysPerWeek.clamp(1, 7)) {
      case 1:
        return const [3]; // Wed
      case 2:
        return const [2, 5]; // Tue, Fri
      case 3:
        return const [1, 3, 5]; // Mon, Wed, Fri
      case 4:
        return const [1, 2, 4, 6]; // Mon, Tue, Thu, Sat
      case 5:
        return const [1, 2, 3, 4, 5]; // Weekdays
      case 6:
        return const [1, 2, 3, 4, 5, 6]; // Mon-Sat
      case 7:
      default:
        return const [1, 2, 3, 4, 5, 6, 7];
    }
  }

  int _baseIdForHabit(String habitId) => habitId.hashCode & 0x7fffffff;

  Future<void> cancelHabitReminders(String habitId) async {
    final base = _baseIdForHabit(habitId);
    final idsToCancel = <int>{};
    // Cancel all 8 ids (0..7) to be safe
    for (int i = 0; i <= 7; i++) {
      final id = base + i;
      idsToCancel.add(id);
    }
    if (!_initialized) {
      await _untrackManagedNotificationIds(idsToCancel);
      return;
    }
    for (final id in idsToCancel) {
      try {
        await _plugin.cancel(id);
      } catch (e) {
        debugPrint('cancel error for id $id: $e');
      }
    }
    await _untrackManagedNotificationIds(idsToCancel);
  }

  Future<void> scheduleHabitReminders(Habit habit) async {
    await init();
    final time = habit.reminderTimeMinutes;
    if (time == null || !habit.isEnabled) {
      await cancelHabitReminders(habit.id);
      return;
    }
    if (!await isMasterRemindersEnabled()) {
      await cancelHabitReminders(habit.id);
      return;
    }
    await cancelHabitReminders(habit.id);
    await requestPermissions();

    final days = (habit.reminderDays == null || habit.reminderDays!.isEmpty)
        ? _deriveReminderDays(habit.targetDaysPerWeek)
        : habit.reminderDays!;
    if (days.isEmpty) {
      await cancelHabitReminders(habit.id);
      return;
    }

    final base = _baseIdForHabit(habit.id);
    final now = DateTime.now();

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _androidChannelId,
        _androidChannelName,
        channelDescription: _androidChannelDesc,
        importance: Importance.high,
        priority: Priority.high,
        category: AndroidNotificationCategory.reminder,
        icon: '@mipmap/ic_launcher',
      ),
    );

    int scheduledCount = 0;
    final scheduledIds = <int>{};
    for (final weekday in days.toSet()) {
      try {
        final notificationId = base + weekday;
        final scheduleDateTime = NotificationScheduleHelper.nextOccurrence(
          now: now,
          minutesFromMidnight: time,
          weekdays: {weekday},
        );
        final scheduleTime = tz.TZDateTime.from(scheduleDateTime, tz.local);
        await _plugin.zonedSchedule(
          notificationId, // unique ID per weekday
          habit.name,
          'Time for your habit: ${habit.name}',
          scheduleTime,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          payload: habit.id,
        );
        scheduledIds.add(notificationId);
        scheduledCount++;
      } catch (e) {
        debugPrint('Error scheduling for weekday $weekday: $e');
      }
    }
    await _trackManagedNotificationIds(scheduledIds);
    if (scheduledCount == 0) {
      debugPrint('No future habit reminders scheduled for habit ${habit.id}');
    }
  }

  // ===== Hydration-specific helpers =====

  int _hydrationBaseId() => 'hydration'.hashCode & 0x7fffffff;

  Future<void> cancelHydrationReminders() async {
    final base = _hydrationBaseId();
    final idsToCancel = <int>{};
    for (int i = 0; i < 50; i++) {
      final id = base + i;
      idsToCancel.add(id);
    }
    if (!_initialized) {
      await _untrackManagedNotificationIds(idsToCancel);
      return;
    }
    for (final id in idsToCancel) {
      try {
        await _plugin.cancel(id);
      } catch (e) {
        debugPrint('cancel hydration error for id $id: $e');
      }
    }
    await _untrackManagedNotificationIds(idsToCancel);
  }

  /// Schedule hydration reminders between [startMinutes] and [endMinutes]
  /// every [intervalMinutes].
  Future<void> scheduleHydrationReminders({
    required int startMinutes,
    required int endMinutes,
    required int intervalMinutes,
  }) async {
    await init();
    if (!await isMasterRemindersEnabled()) {
      await cancelHydrationReminders();
      return;
    }
    await cancelHydrationReminders();

    if (intervalMinutes <= 0) return;
    if (endMinutes < startMinutes) return;
    await requestPermissions();

    final androidDetails = AndroidNotificationDetails(
      _androidHydrationChannelId,
      _androidHydrationChannelName,
      channelDescription: _androidHydrationChannelDesc,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      category: AndroidNotificationCategory.reminder,
      icon: '@mipmap/ic_launcher',
    );

    final details = NotificationDetails(android: androidDetails);

    final base = _hydrationBaseId();
    final now = DateTime.now();
    final slots = NotificationScheduleHelper.intradaySlots(
      startMinutes: startMinutes,
      endMinutes: endMinutes,
      intervalMinutes: intervalMinutes,
    );
    if (slots.isEmpty) return;

    final messages = [
      'Take a small sip of water and reset your focus.',
      'Time to hydrate 💧 Your body and mind will thank you.',
      'Pause for a water break – a tiny ritual for a better day.',
    ];

    int scheduledCount = 0;
    final scheduledIds = <int>{};
    for (int index = 0; index < slots.length; index++) {
      final notificationId = base + index + 1;
      final scheduleDateTime = NotificationScheduleHelper.nextOccurrence(
        now: now,
        minutesFromMidnight: slots[index],
      );
      final scheduleTime = tz.TZDateTime.from(scheduleDateTime, tz.local);
      final message = messages[index % messages.length];
      try {
        await _plugin.zonedSchedule(
          notificationId,
          'Time to drink water',
          message,
          scheduleTime,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
          payload: 'hydration',
        );
        scheduledIds.add(notificationId);
        scheduledCount++;
      } catch (e) {
        debugPrint('Error scheduling hydration reminder: $e');
      }
    }
    await _trackManagedNotificationIds(scheduledIds);
    if (scheduledCount == 0) {
      debugPrint('No future hydration reminders were scheduled.');
    }
  }

  // ===== Movement-specific helpers =====

  int _movementBaseId() => 'movement'.hashCode & 0x7fffffff;

  Future<void> cancelMovementReminders() async {
    final base = _movementBaseId();
    final idsToCancel = <int>{};
    for (int i = 0; i < 50; i++) {
      final id = base + i;
      idsToCancel.add(id);
    }
    if (!_initialized) {
      await _untrackManagedNotificationIds(idsToCancel);
      return;
    }
    for (final id in idsToCancel) {
      try {
        await _plugin.cancel(id);
      } catch (e) {
        debugPrint('cancel movement error for id $id: $e');
      }
    }
    await _untrackManagedNotificationIds(idsToCancel);
  }

  Future<void> scheduleMovementReminders({
    required int startMinutes,
    required int endMinutes,
    required int intervalMinutes,
  }) async {
    await init();
    if (!await isMasterRemindersEnabled()) {
      await cancelMovementReminders();
      return;
    }
    await cancelMovementReminders();

    if (intervalMinutes <= 0) return;
    if (endMinutes < startMinutes) return;
    await requestPermissions();

    final androidDetails = AndroidNotificationDetails(
      _androidChannelId,
      _androidChannelName,
      channelDescription: _androidChannelDesc,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      category: AndroidNotificationCategory.reminder,
      icon: '@mipmap/ic_launcher',
    );

    final details = NotificationDetails(android: androidDetails);

    final base = _movementBaseId();
    final now = DateTime.now();
    final slots = NotificationScheduleHelper.intradaySlots(
      startMinutes: startMinutes,
      endMinutes: endMinutes,
      intervalMinutes: intervalMinutes,
    );
    if (slots.isEmpty) return;

    final messages = [
      'Time for a quick movement break.',
      'Stretch your legs and take a deep breath.',
      'Posture check! Move around for a bit.',
      'Gentle movement helps your mind and body.',
    ];

    int scheduledCount = 0;
    final scheduledIds = <int>{};
    for (int index = 0; index < slots.length; index++) {
      final notificationId = base + index + 1;
      final scheduleDateTime = NotificationScheduleHelper.nextOccurrence(
        now: now,
        minutesFromMidnight: slots[index],
      );
      final scheduleTime = tz.TZDateTime.from(scheduleDateTime, tz.local);
      final message = messages[index % messages.length];
      try {
        await _plugin.zonedSchedule(
          notificationId,
          'Movement Break',
          message,
          scheduleTime,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
          payload: 'movement',
        );
        scheduledIds.add(notificationId);
        scheduledCount++;
      } catch (e) {
        debugPrint('Error scheduling movement reminder: $e');
      }
    }
    await _trackManagedNotificationIds(scheduledIds);
    if (scheduledCount == 0) {
      debugPrint('No future movement reminders were scheduled.');
    }
  }

  // ===== Deep Work-specific helpers =====

  int _deepWorkBaseId() => 'deep_work'.hashCode & 0x7fffffff;

  Future<void> cancelDeepWorkReminders() async {
    final base = _deepWorkBaseId();
    final idsToCancel = <int>{};
    for (int i = 0; i < 50; i++) {
      final id = base + i;
      idsToCancel.add(id);
    }
    if (!_initialized) {
      await _untrackManagedNotificationIds(idsToCancel);
      return;
    }
    for (final id in idsToCancel) {
      try {
        await _plugin.cancel(id);
      } catch (e) {
        debugPrint('cancel deep work error for id $id: $e');
      }
    }
    await _untrackManagedNotificationIds(idsToCancel);
  }

  Future<void> scheduleDeepWorkReminders({
    required int startMinutes,
    required int endMinutes,
    required int intervalMinutes,
    required DeepWorkProfile profile,
  }) async {
    await init();
    if (!await isMasterRemindersEnabled()) {
      await cancelDeepWorkReminders();
      return;
    }
    await cancelDeepWorkReminders();

    if (intervalMinutes <= 0) return;
    if (endMinutes < startMinutes) return;
    await requestPermissions();

    const androidChannelId = _androidChannelId;
    const androidChannelName = _androidChannelName;
    const androidChannelDesc = _androidChannelDesc;

    final androidDetails = AndroidNotificationDetails(
      androidChannelId,
      androidChannelName,
      channelDescription: androidChannelDesc,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      category: AndroidNotificationCategory.reminder,
      icon: '@mipmap/ic_launcher',
    );

    final details = NotificationDetails(android: androidDetails);

    final base = _deepWorkBaseId();
    final now = DateTime.now();
    final slots = NotificationScheduleHelper.intradaySlots(
      startMinutes: startMinutes,
      endMinutes: endMinutes,
      intervalMinutes: intervalMinutes,
    );
    if (slots.isEmpty) return;

    String profileLabel(DeepWorkProfile p) {
      switch (p) {
        case DeepWorkProfile.deepWork:
          return 'Deep Work';
        case DeepWorkProfile.study:
          return 'Study';
        case DeepWorkProfile.creative:
          return 'Creative Focus';
        case DeepWorkProfile.lightAdmin:
          return 'Light Admin';
        case DeepWorkProfile.custom:
          return 'Focus Session';
      }
    }

    final title = '${profileLabel(profile)} session';

    final messages = [
      'Time to protect a focused block of work.',
      'Create a small island of deep focus right now.',
      'Silence distractions and commit to the next block.',
    ];

    int scheduledCount = 0;
    final scheduledIds = <int>{};
    for (int index = 0; index < slots.length; index++) {
      final notificationId = base + index + 1;
      final scheduleDateTime = NotificationScheduleHelper.nextOccurrence(
        now: now,
        minutesFromMidnight: slots[index],
      );
      final scheduleTime = tz.TZDateTime.from(scheduleDateTime, tz.local);
      final message = messages[index % messages.length];
      try {
        await _plugin.zonedSchedule(
          notificationId,
          title,
          message,
          scheduleTime,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
          payload: 'deep_work',
        );
        scheduledIds.add(notificationId);
        scheduledCount++;
      } catch (e) {
        debugPrint('Error scheduling deep work reminder: $e');
      }
    }
    await _trackManagedNotificationIds(scheduledIds);
    if (scheduledCount == 0) {
      debugPrint('No future deep work reminders were scheduled.');
    }
  }

  Future<void> scheduleOneTimeTestNotificationInOneMinute() async {
    await init();
    if (!await isMasterRemindersEnabled()) {
      await cancelAllManagedReminders();
      return;
    }
    await requestPermissions();
    final now = tz.TZDateTime.now(tz.local);
    final when = now.add(const Duration(minutes: 1));
    final id = Random().nextInt(0x7fffffff);
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _androidChannelId,
        _androidChannelName,
        channelDescription: _androidChannelDesc,
        importance: Importance.high,
        priority: Priority.high,
        category: AndroidNotificationCategory.reminder,
        icon: '@mipmap/ic_launcher',
      ),
    );
    await _plugin.zonedSchedule(
      id,
      'Test Notification',
      'This is your Daily Reset test reminder.',
      when,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'test',
    );
    await _trackManagedNotificationIds(<int>{id});
  }

  // Utility for UI formatting
  static String formatReminderTime(BuildContext context, int minutes) {
    final timeOfDay = TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
    return MaterialLocalizations.of(context).formatTimeOfDay(timeOfDay,
        alwaysUse24HourFormat: MediaQuery.maybeOf(context)?.alwaysUse24HourFormat ?? false);
  }
}
