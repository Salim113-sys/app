import 'package:daily_reset/models/hydration_entry.dart';
import 'package:daily_reset/models/hydration_settings.dart';
import 'package:daily_reset/services/hydration_repository.dart';
import 'package:daily_reset/services/notification_service.dart';
import 'package:flutter/foundation.dart';

class HydrationProvider extends ChangeNotifier {
  final HydrationRepository _repository;
  final NotificationService _notificationService;

  HydrationSettings _settings = const HydrationSettings();
  List<HydrationEntry> _todayEntries = const [];
  bool _initialized = false;
  bool _isDisposed = false;

  HydrationProvider(this._repository, this._notificationService) {
    _bootstrap();
  }

  HydrationSettings get settings => _settings;
  List<HydrationEntry> get todayEntries => _todayEntries;
  bool get isInitialized => _initialized;

  int get todayTotalMl =>
      _todayEntries.fold<int>(0, (sum, e) => sum + e.amountMl);

  Future<void> _bootstrap() async {
    try {
      _settings = await _repository.loadSettings();
      _repository.settingsStream.listen((value) {
        if (_isDisposed) return;
        _settings = value;
        notifyListeners();
      });
      _repository.todayEntriesStream.listen((entries) {
        if (_isDisposed) return;
        _todayEntries = entries;
        notifyListeners();
      });
      if (_isDisposed) return;
      _initialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error bootstrapping HydrationProvider: $e');
    }
  }

  Future<void> logDrink(int amountMl, {String? source}) async {
    await _repository.logDrink(amountMl, source: source);
    _todayEntries = List.from(_todayEntries)
      ..add(HydrationEntry(amountMl: amountMl, source: source));
    if (_isDisposed) return;
    notifyListeners();
  }

  Future<void> saveSettings(HydrationSettings settings) async {
    await _repository.saveSettings(settings);
    _settings = settings;
    if (settings.remindersEnabled) {
      await _notificationService.scheduleHydrationReminders(
        startMinutes: settings.reminderStartMinutes,
        endMinutes: settings.reminderEndMinutes,
        intervalMinutes: settings.reminderIntervalMinutes,
      );
    } else {
      await _notificationService.cancelHydrationReminders();
    }
    if (_isDisposed) return;
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getLast7DayTotals() async {
    final totals = await _repository.getLastDaysTotals(days: 7);
    return totals
        .map((t) => {
              'date': t.date,
              'totalMl': t.totalMl,
            })
        .toList();
  }

  Future<void> clearAllData() async {
    try {
      await _notificationService.cancelHydrationReminders();
      await _repository.clearAllData();
      _settings = const HydrationSettings();
      _todayEntries = const [];
      _initialized = true;
      if (_isDisposed) return;
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing hydration data: $e');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
