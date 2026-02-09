import 'dart:async';

import 'package:daily_reset/models/deep_work_settings.dart';
import 'package:daily_reset/models/focus_session_entry.dart';
import 'package:daily_reset/services/storage_service.dart';
import 'package:flutter/foundation.dart';

class DeepWorkRepository {
  DeepWorkRepository(this._storage);

  static const String _settingsKey = 'deep_work_settings_v1';
  static const String _entriesKeyPrefix = 'deep_work_entries_'; // + yyyy-MM-dd

  final StorageService _storage;

  final StreamController<DeepWorkSettings> _settingsController =
      StreamController.broadcast();
  DeepWorkSettings _currentSettings = const DeepWorkSettings();

  DeepWorkSettings get currentSettings => _currentSettings;
  Stream<DeepWorkSettings> get settingsStream => _settingsController.stream;

  Future<DeepWorkSettings> loadSettings() async {
    try {
      final json = _storage.getJson(_settingsKey);
      if (json != null) {
        _currentSettings = DeepWorkSettings.fromJson(json);
      } else {
        _currentSettings = const DeepWorkSettings();
        await saveSettings(_currentSettings);
      }
    } catch (e) {
      debugPrint('Error loading DeepWorkSettings: $e');
      _currentSettings = const DeepWorkSettings();
    }
    _settingsController.add(_currentSettings);
    return _currentSettings;
  }

  Future<void> saveSettings(DeepWorkSettings settings) async {
    _currentSettings = settings;
    try {
      await _storage.saveJson(_settingsKey, settings.toJson());
    } catch (e) {
      debugPrint('Error saving DeepWorkSettings: $e');
    }
    _settingsController.add(_currentSettings);
  }

  String _dateKey(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<List<FocusSessionEntry>> _loadEntriesForDate(DateTime date) async {
    final key = '$_entriesKeyPrefix${_dateKey(date)}';
    final listJson = _storage.getJsonList(key);
    if (listJson == null) return [];
    final entries = <FocusSessionEntry>[];
    for (final item in listJson) {
      try {
        entries.add(FocusSessionEntry.fromJson(item));
      } catch (e) {
        debugPrint('Skipping invalid FocusSessionEntry: $e');
      }
    }
    return entries;
  }

  Future<void> _saveEntriesForDate(
    DateTime date,
    List<FocusSessionEntry> entries,
  ) async {
    final key = '$_entriesKeyPrefix${_dateKey(date)}';
    try {
      await _storage.saveJsonList(
        key,
        entries.map((e) => e.toJson()).toList(),
      );
    } catch (e) {
      debugPrint('Error saving FocusSessionEntry list: $e');
    }
  }

  Future<void> logSession(FocusSessionEntry entry) async {
    final start = entry.startTime;
    final day = DateTime(start.year, start.month, start.day);
    final current = await _loadEntriesForDate(day);
    current.add(entry);
    await _saveEntriesForDate(day, current);
  }

  Future<List<FocusSessionEntry>> getSessionsForDay(DateTime day) async {
    final d = DateTime(day.year, day.month, day.day);
    return _loadEntriesForDate(d);
  }

  Future<int> getTotalMinutesForDay(DateTime day) async {
    final entries = await getSessionsForDay(day);
    return entries.fold<int>(0, (sum, e) => sum + e.durationMinutes);
  }

  /// Returns map keyed by date (date-only) with total focus minutes, oldest first.
  Future<Map<DateTime, int>> getLast7DaysTotals() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final Map<DateTime, int> result = {};
    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final entries = await _loadEntriesForDate(date);
      final total = entries.fold<int>(0, (sum, e) => sum + e.durationMinutes);
      result[date] = total;
    }
    return result;
  }

  Future<void> clearAll() async {
    try {
      _currentSettings = const DeepWorkSettings();
      _settingsController.add(_currentSettings);
      final keysToRemove = _storage
          .getKeys()
          .where(
            (key) => key == _settingsKey || key.startsWith(_entriesKeyPrefix),
          )
          .toList(growable: false);
      for (final key in keysToRemove) {
        await _storage.remove(key);
      }
    } catch (e) {
      debugPrint('DeepWorkRepository.clearAll error: $e');
    }
  }

  void dispose() {
    _settingsController.close();
  }
}
