import 'package:daily_reset/models/daily_log.dart';
import 'package:daily_reset/services/storage_service.dart';
import 'package:flutter/foundation.dart';

class DailyLogService {
  static const String _storageKey = 'daily_logs';
  final StorageService _storage;

  DailyLogService(this._storage);

  Future<List<DailyLog>> getAllLogs() async {
    try {
      final jsonList = _storage.getJsonList(_storageKey);
      if (jsonList == null) return [];
      final logs = <DailyLog>[];
      for (final json in jsonList) {
        try {
          logs.add(DailyLog.fromJson(json));
        } catch (e) {
          debugPrint('Failed to parse daily log: $e');
        }
      }
      return logs;
    } catch (e) {
      debugPrint('Error loading daily logs: $e');
      return [];
    }
  }

  Future<DailyLog?> getLogByDate(DateTime date) async {
    final logs = await getAllLogs();
    final normalized = DateTime(date.year, date.month, date.day);
    try {
      return logs.firstWhere((log) =>
          log.date.year == normalized.year &&
          log.date.month == normalized.month &&
          log.date.day == normalized.day);
    } catch (e) {
      return null;
    }
  }

  Future<List<DailyLog>> getLogsByDateRange(DateTime start, DateTime end) async {
    final logs = await getAllLogs();
    final normalizedStart = DateTime(start.year, start.month, start.day);
    final normalizedEnd = DateTime(end.year, end.month, end.day);
    return logs.where((log) =>
      !log.date.isBefore(normalizedStart) && !log.date.isAfter(normalizedEnd)
    ).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  Future<void> saveLog(DailyLog log) async {
    final logs = await getAllLogs();
    final index = logs.indexWhere((l) =>
        l.date.year == log.date.year &&
        l.date.month == log.date.month &&
        l.date.day == log.date.day);
    if (index != -1) {
      logs[index] = log;
    } else {
      logs.add(log);
    }
    await _saveLogs(logs);
  }

  Future<void> deleteLog(String id) async {
    final logs = await getAllLogs();
    logs.removeWhere((l) => l.id == id);
    await _saveLogs(logs);
  }

  Future<int> getHabitStreak(String habitId) async {
    final logs = await getAllLogs();
    logs.sort((a, b) => b.date.compareTo(a.date));

    int streak = 0;
    DateTime checkDate = DateTime.now();
    checkDate = DateTime(checkDate.year, checkDate.month, checkDate.day);

    for (int i = 0; i < 365; i++) {
      final log = logs.firstWhere(
        (l) =>
            l.date.year == checkDate.year &&
            l.date.month == checkDate.month &&
            l.date.day == checkDate.day,
        orElse: () => DailyLog(date: checkDate),
      );

      if (log.completedHabitIds.contains(habitId)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  Future<double> getWeeklyCompletionRate(String habitId) async {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final logs = await getLogsByDateRange(sevenDaysAgo, now);

    int completedDays = 0;
    for (final log in logs) {
      if (log.completedHabitIds.contains(habitId)) {
        completedDays++;
      }
    }

    return completedDays / 7 * 100;
  }

  Future<void> _saveLogs(List<DailyLog> logs) async {
    final cleanedLogs = <DailyLog>[];
    for (final log in logs) {
      try {
        cleanedLogs.add(log);
      } catch (e) {
        debugPrint('Skipping invalid log: $e');
      }
    }
    final jsonList = cleanedLogs.map((l) => l.toJson()).toList();
    await _storage.saveJsonList(_storageKey, jsonList);
  }

  Future<void> clearAll() async {
    await _storage.remove(_storageKey);
  }

}
