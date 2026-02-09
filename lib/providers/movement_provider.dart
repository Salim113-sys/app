import 'package:daily_reset/models/movement_models.dart';
import 'package:daily_reset/models/movement_settings.dart';
import 'package:daily_reset/services/movement_repository.dart';
import 'package:daily_reset/services/notification_service.dart';
import 'package:flutter/foundation.dart';

class MovementProvider extends ChangeNotifier {
  final MovementRepository _repository;
  final NotificationService _notificationService;

  MovementSettings _settings = const MovementSettings();
  bool _initialized = false;
  int _todayTotalMinutes = 0;

  MovementProvider(this._repository, this._notificationService) {
    // Bootstrap the provider
    _bootstrap();
  }

  MovementSettings get settings => _settings;
  bool get isInitialized => _initialized;
  int get todayTotalMinutes => _todayTotalMinutes;

  List<MovementRoutine> get routines => _repository.routines;

  Future<void> _bootstrap() async {
    try {
      _settings = await _repository.loadSettings();
      _repository.settingsStream.listen((value) {
        _settings = value;
        notifyListeners();
      });
      await _refreshTodayTotal();
      _initialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error bootstrapping MovementProvider: $e');
    }
  }

  Future<void> _refreshTodayTotal() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _todayTotalMinutes = await _repository.getTotalMinutesForDay(today);
  }

  Future<void> saveSettings(MovementSettings settings) async {
    await _repository.saveSettings(settings);
    _settings = settings;
    if (settings.remindersEnabled) {
      await _notificationService.scheduleMovementReminders(
        startMinutes: settings.reminderStartMinutes,
        endMinutes: settings.reminderEndMinutes,
        intervalMinutes: settings.reminderIntervalMinutes,
      );
    } else {
      await _notificationService.cancelMovementReminders();
    }
    notifyListeners();
  }

  Future<void> logSession({
    required MovementRoutine routine,
    required int actualMinutes,
  }) async {
    final now = DateTime.now();
    final entry = MovementSessionLog(
      routineId: routine.id,
      startTime: now.subtract(Duration(minutes: actualMinutes)),
      endTime: now,
      durationMinutes: actualMinutes,
      type: routine.type,
    );
    await _repository.logMovementSession(entry);
    await _refreshTodayTotal();
    notifyListeners();
  }

  Future<Map<DateTime, int>> getLast7DaysTotals() =>
      _repository.getLast7DaysTotals();

  Future<void> clearAllData() async {
    try {
      await _repository.clearAll();
      _settings = const MovementSettings();
      _todayTotalMinutes = 0;
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing movement data: $e');
    }
  }
}
