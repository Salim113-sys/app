import 'dart:async';

import 'package:daily_reset/models/hydration_entry.dart';
import 'package:daily_reset/models/hydration_settings.dart';
import 'package:daily_reset/services/storage_service.dart';
import 'package:flutter/foundation.dart';

class HydrationRepository {
  HydrationRepository(this._storage);

  static const String _settingsKey = 'hydration_settings_v1';
  static const String _entriesKeyPrefix = 'hydration_entries_'; // + yyyy-MM-dd

  final StorageService _storage;

  final StreamController<HydrationSettings> _settingsController =
      StreamController.broadcast();
  HydrationSettings _currentSettings = const HydrationSettings();

  final StreamController<List<HydrationEntry>> _todayEntriesController =
      StreamController.broadcast();

  Stream<HydrationSettings> get settingsStream => _settingsController.stream;
  HydrationSettings get currentSettings => _currentSettings;

  Stream<List<HydrationEntry>> get todayEntriesStream =>
      _todayEntriesController.stream;

  Future<HydrationSettings> loadSettings() async {
    try {
      final json = _storage.getJson(_settingsKey);
      if (json != null) {
        _currentSettings = HydrationSettings.fromJson(json);
      } else {
        _currentSettings = const HydrationSettings();
        await saveSettings(_currentSettings);
      }
    } catch (e) {
      debugPrint('Error loading HydrationSettings: $e');
      _currentSettings = const HydrationSettings();
    }
    _settingsController.add(_currentSettings);
    await _loadTodayEntries();
    return _currentSettings;
  }

  Future<void> saveSettings(HydrationSettings settings) async {
    _currentSettings = settings;
    try {
      await _storage.saveJson(_settingsKey, settings.toJson());
    } catch (e) {
      debugPrint('Error saving HydrationSettings: $e');
    }
    _settingsController.add(_currentSettings);
  }

  String _dateKey(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<List<HydrationEntry>> _loadEntriesForDate(DateTime date) async {
    final key = '$_entriesKeyPrefix${_dateKey(date)}';
    final listJson = _storage.getJsonList(key);
    if (listJson == null) return [];
    final entries = <HydrationEntry>[];
    for (final item in listJson) {
      try {
        entries.add(HydrationEntry.fromJson(item));
      } catch (e) {
        debugPrint('Skipping invalid HydrationEntry: $e');
      }
    }
    return entries;
  }

  Future<void> _saveEntriesForDate(
      DateTime date, List<HydrationEntry> entries) async {
    final key = '$_entriesKeyPrefix${_dateKey(date)}';
    try {
      await _storage.saveJsonList(
        key,
        entries.map((e) => e.toJson()).toList(),
      );
    } catch (e) {
      debugPrint('Error saving HydrationEntry list: $e');
    }
  }

  Future<void> _loadTodayEntries() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entries = await _loadEntriesForDate(today);
    _todayEntriesController.add(entries);
  }

  Future<void> logDrink(int amountMl, {String? source}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final current = await _loadEntriesForDate(today);
    current.add(HydrationEntry(amountMl: amountMl, source: source));
    await _saveEntriesForDate(today, current);
    _todayEntriesController.add(current);
  }

  Future<int> getTodayTotalMl() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entries = await _loadEntriesForDate(today);
    return entries.fold<int>(0, (sum, e) => sum + e.amountMl);
  }

  /// Returns totals for the last [days] (inclusive of today), oldest first.
  Future<List<HydrationDayTotal>> getLastDaysTotals({int days = 7}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final totals = <HydrationDayTotal>[];
    for (int i = days - 1; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final entries = await _loadEntriesForDate(date);
      final total = entries.fold<int>(0, (sum, e) => sum + e.amountMl);
      totals.add(HydrationDayTotal(date: date, totalMl: total));
    }
    return totals;
  }

  Future<void> clearAllData() async {
    try {
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
      debugPrint('Error clearing Hydration data: $e');
    }

    _currentSettings = const HydrationSettings();
    _settingsController.add(_currentSettings);
    _todayEntriesController.add(const []);
  }

  void dispose() {
    _settingsController.close();
    _todayEntriesController.close();
  }
}

class HydrationDayTotal {
  final DateTime date;
  final int totalMl;

  HydrationDayTotal({required this.date, required this.totalMl});
}
