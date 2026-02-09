import 'dart:async';

import 'package:daily_reset/models/movement_models.dart';
import 'package:daily_reset/models/movement_settings.dart';
import 'package:daily_reset/services/storage_service.dart';
import 'package:flutter/foundation.dart';

class MovementRepository {
  MovementRepository(this._storage);

  static const String _settingsKey = 'movement_settings_v1';
  static const String _logsKey = 'movement_session_logs_v1';

  final StorageService _storage;

  final StreamController<MovementSettings> _settingsController =
      StreamController.broadcast();
  MovementSettings _currentSettings = const MovementSettings();

  MovementSettings get currentSettings => _currentSettings;
  Stream<MovementSettings> get settingsStream => _settingsController.stream;

  final List<MovementRoutine> _routines = _seedRoutines;

  final StreamController<List<MovementSessionLog>> _logsController =
      StreamController<List<MovementSessionLog>>.broadcast();
  List<MovementSessionLog> _logs = [];

  List<MovementRoutine> get routines => List.unmodifiable(_routines);
  Stream<List<MovementSessionLog>> get logsStream => _logsController.stream;
  List<MovementSessionLog> get logs => List.unmodifiable(_logs);

  Future<MovementSettings> loadSettings() async {
    try {
      final json = _storage.getJson(_settingsKey);
      if (json != null) {
        _currentSettings = MovementSettings.fromJson(json);
      } else {
        _currentSettings = const MovementSettings();
        await saveSettings(_currentSettings);
      }
    } catch (e) {
      debugPrint('Error loading MovementSettings: $e');
      _currentSettings = const MovementSettings();
    }
    _settingsController.add(_currentSettings);
    await _loadLogs();
    return _currentSettings;
  }

  Future<void> saveSettings(MovementSettings settings) async {
    _currentSettings = settings;
    try {
      await _storage.saveJson(_settingsKey, settings.toJson());
    } catch (e) {
      debugPrint('Error saving MovementSettings: $e');
    }
    _settingsController.add(_currentSettings);
  }

  Future<void> _loadLogs() async {
    try {
      final rawList = _storage.getJsonList(_logsKey);
      if (rawList == null) {
        _logs = [];
      } else {
        _logs = rawList
            .map((e) => MovementSessionLog.fromJson(e))
            .toList(growable: false);
      }
    } catch (e, st) {
      debugPrint('MovementRepository._loadLogs error: $e\n$st');
      _logs = [];
    }
    _logsController.add(_logs);
  }

  Future<void> logMovementSession(MovementSessionLog entry) async {
    _logs = [..._logs, entry];
    await _persistLogs();
  }

  Future<void> _persistLogs() async {
    try {
      await _storage.saveJsonList(
        _logsKey,
        _logs.map((e) => e.toJson()).toList(growable: false),
      );
    } catch (e, st) {
      debugPrint('MovementRepository._persistLogs error: $e\n$st');
    }
    _logsController.add(_logs);
  }

  Future<List<MovementSessionLog>> getSessionsForDay(DateTime day) async {
    final d = DateTime(day.year, day.month, day.day);
    return _logs.where((log) {
      final date =
          DateTime(log.startTime.year, log.startTime.month, log.startTime.day);
      return date == d;
    }).toList();
  }

  Future<int> getTotalMinutesForDay(DateTime day) async {
    final sessions = await getSessionsForDay(day);
    return sessions.fold<int>(0, (sum, e) => sum + e.durationMinutes);
  }

  Future<Map<DateTime, int>> getLast7DaysTotals() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final Map<DateTime, int> result = {};
    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final total = await getTotalMinutesForDay(date);
      result[date] = total;
    }
    return result;
  }

  Future<void> clearAll() async {
    try {
      _currentSettings = const MovementSettings();
      _settingsController.add(_currentSettings);
      _logs = [];
      _logsController.add(_logs);
      await _storage.remove(_settingsKey);
      await _storage.remove(_logsKey);
    } catch (e, st) {
      debugPrint('MovementRepository.clearAll error: $e\n$st');
    }
  }

  void dispose() {
    _settingsController.close();
    _logsController.close();
  }

  static List<MovementRoutine> get _seedRoutines => const [
        MovementRoutine(
          id: 'desk_stretch_5',
          name: 'Desk stretch – 5 min',
          description:
              'Undo desk tension with simple neck, shoulder, and back moves.',
          type: MovementRoutineType.stretch,
          estimatedMinutes: 5,
          tags: ['office', 'neck', 'back'],
        ),
        MovementRoutine(
          id: 'quick_walk_10',
          name: 'Quick walk – 10 min',
          description:
              'Reset your energy with a short walk indoors or outside.',
          type: MovementRoutineType.walk,
          estimatedMinutes: 10,
          tags: ['cardio', 'fresh-air'],
        ),
        MovementRoutine(
          id: 'evening_unwind_8',
          name: 'Evening unwind – 8 min',
          description: 'Gentle floor-based stretches to relax before sleep.',
          type: MovementRoutineType.yoga,
          estimatedMinutes: 8,
          tags: ['evening', 'relax'],
        ),
        MovementRoutine(
          id: 'posture_reset_3',
          name: 'Posture reset – 3 min',
          description:
              'Quick alignment check-in to open the chest and stack the spine.',
          type: MovementRoutineType.posture,
          estimatedMinutes: 3,
          tags: ['posture', 'upper-back'],
        ),
        MovementRoutine(
          id: 'breath_neck_release_4',
          name: 'Breathing & neck release – 4 min',
          description:
              'Slow breaths plus simple neck releases to downshift stress.',
          type: MovementRoutineType.breathing,
          estimatedMinutes: 4,
          tags: ['breathing', 'neck'],
        ),
      ];
}
