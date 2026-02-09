import 'package:daily_reset/models/deep_work_settings.dart';
import 'package:daily_reset/models/focus_session_entry.dart';
import 'package:daily_reset/services/deep_work_repository.dart';
import 'package:daily_reset/services/notification_service.dart';
import 'package:flutter/foundation.dart';

enum DeepWorkMode { focus, shortBreak, longBreak }

class DeepWorkProvider extends ChangeNotifier {
  final DeepWorkRepository _repository;
  final NotificationService _notificationService;

  DeepWorkSettings _settings = const DeepWorkSettings();
  bool _initialized = false;

  DeepWorkMode _mode = DeepWorkMode.focus;
  Duration _remaining = const Duration();
  int _completedFocusSessionsInBlock = 0;

  DeepWorkProvider(this._repository, this._notificationService) {
    _bootstrap();
  }

  DeepWorkSettings get settings => _settings;
  bool get isInitialized => _initialized;
  DeepWorkMode get mode => _mode;
  Duration get remaining => _remaining;
  int get completedFocusSessionsInBlock => _completedFocusSessionsInBlock;

  int _todayCachedTotalMinutes = 0;
  int get todayTotalMinutes => _todayCachedTotalMinutes;

  Future<void> _bootstrap() async {
    try {
      _settings = await _repository.loadSettings();
      _repository.settingsStream.listen((value) {
        _settings = value;
        notifyListeners();
      });
      await _refreshTodayTotal();
      _resetTimerToFocus();
      _initialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error bootstrapping DeepWorkProvider: $e');
    }
  }

  Future<void> _refreshTodayTotal() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _todayCachedTotalMinutes = await _repository.getTotalMinutesForDay(today);
  }

  void _resetTimerToFocus() {
    _mode = DeepWorkMode.focus;
    _remaining = Duration(minutes: _settings.defaultSessionMinutes);
  }

  Future<void> saveSettings(DeepWorkSettings settings) async {
    await _repository.saveSettings(settings);
    _settings = settings;
    if (settings.remindersEnabled) {
      await _notificationService.scheduleDeepWorkReminders(
        startMinutes: settings.reminderStartMinutes,
        endMinutes: settings.reminderEndMinutes,
        intervalMinutes: settings.reminderIntervalMinutes,
        profile: settings.focusProfile,
      );
    } else {
      await _notificationService.cancelDeepWorkReminders();
    }
    notifyListeners();
  }

  Future<void> logCompletedSession({String? projectTag}) async {
    final now = DateTime.now();
    final durationMinutes = _settings.defaultSessionMinutes;
    final entry = FocusSessionEntry(
      startTime: now.subtract(Duration(minutes: durationMinutes)),
      endTime: now,
      durationMinutes: durationMinutes,
      profile: _settings.focusProfile,
      projectTag: projectTag,
    );
    await _repository.logSession(entry);
    await _refreshTodayTotal();
    _completedFocusSessionsInBlock++;
    notifyListeners();
  }

  Future<List<FocusSessionEntry>> getTodaySessions() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _repository.getSessionsForDay(today);
  }

  Future<Map<DateTime, int>> getLast7DaysTotals() =>
      _repository.getLast7DaysTotals();

  Future<void> clearAllData() async {
    try {
      await _repository.clearAll();
      _settings = const DeepWorkSettings();
      _todayCachedTotalMinutes = 0;
      _completedFocusSessionsInBlock = 0;
      _resetTimerToFocus();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing deep work data: $e');
    }
  }
}
