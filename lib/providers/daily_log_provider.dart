import 'package:flutter/material.dart';
import 'package:daily_reset/models/daily_log.dart';
import 'package:daily_reset/services/daily_log_service.dart';

class DailyLogProvider extends ChangeNotifier {
  final DailyLogService _logService;
  DailyLog? _todayLog;
  List<DailyLog> _recentLogs = [];
  bool _isLoading = false;

  DailyLogProvider(this._logService) {
    loadTodayLog();
  }

  DailyLog? get todayLog => _todayLog;
  List<DailyLog> get recentLogs => _recentLogs;
  bool get isLoading => _isLoading;
  bool get hasAnyLogs => _recentLogs.isNotEmpty || _todayLog != null;

  Future<void> loadTodayLog() async {
    _isLoading = true;
    notifyListeners();
    try {
      final today = DateTime.now();
      _todayLog = await _logService.getLogByDate(today);
      _todayLog ??= DailyLog(date: today);
      await loadRecentLogs();
    } catch (e) {
      debugPrint('Error loading today log: $e');
      _todayLog = DailyLog(date: DateTime.now());
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadRecentLogs() async {
    try {
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));
      _recentLogs = await _logService.getLogsByDateRange(sevenDaysAgo, now);
    } catch (e) {
      debugPrint('Error loading recent logs: $e');
      _recentLogs = [];
    }
  }

  Future<void> setMood(MoodLevel mood) async {
    if (_todayLog == null) return;
    try {
      _todayLog = _todayLog!.copyWith(mood: mood);
      await _logService.saveLog(_todayLog!);
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting mood: $e');
    }
  }

  Future<void> toggleHabitCompletion(String habitId) async {
    if (_todayLog == null) return;
    try {
      final completedIds = List<String>.from(_todayLog!.completedHabitIds);
      if (completedIds.contains(habitId)) {
        completedIds.remove(habitId);
      } else {
        completedIds.add(habitId);
      }
      _todayLog = _todayLog!.copyWith(completedHabitIds: completedIds);
      await _logService.saveLog(_todayLog!);
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling habit completion: $e');
    }
  }

  bool isHabitCompleted(String habitId) {
    return _todayLog?.completedHabitIds.contains(habitId) ?? false;
  }

  Future<int> getHabitStreak(String habitId) async {
    try {
      return await _logService.getHabitStreak(habitId);
    } catch (e) {
      debugPrint('Error getting habit streak: $e');
      return 0;
    }
  }

  Future<double> getWeeklyCompletionRate(String habitId) async {
    try {
      return await _logService.getWeeklyCompletionRate(habitId);
    } catch (e) {
      debugPrint('Error getting weekly completion rate: $e');
      return 0.0;
    }
  }

  List<MoodLevel?> getLast7DaysMoods() {
    final moods = <MoodLevel?>[];
    final now = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final log = _recentLogs.firstWhere(
        (l) =>
            l.date.year == date.year &&
            l.date.month == date.month &&
            l.date.day == date.day,
        orElse: () => DailyLog(date: date),
      );
      moods.add(log.mood);
    }
    return moods;
  }

  /// Returns a map keyed by normalized date (yyyy-MM-dd) for quick lookup.
  Map<String, DailyLog> _logsByDate(List<DailyLog> logs) {
    final map = <String, DailyLog>{};
    for (final log in logs) {
      final key = _formatDateKey(log.date);
      map[key] = log;
    }
    return map;
  }

  String _formatDateKey(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Compute, in-memory, how many days in the last [days]
  /// had at least one completed habit from [programHabitIds].
  ///
  /// Returns a tuple (activeDays, totalDays) where totalDays == [days].
  /// This is synchronous and operates only on already-loaded logs.
  (int activeDays, int totalDays) getProgramActivityForLastDays(
    List<String> programHabitIds, {
    int days = 7,
  }) {
    if (programHabitIds.isEmpty || days <= 0) {
      return (0, 0);
    }

    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day);
    final start = end.subtract(Duration(days: days - 1));

    final logs = List<DailyLog>.from(_recentLogs);
    if (_todayLog != null &&
        _todayLog!.date.isAtSameMomentAs(end) &&
        !logs.any((l) =>
            l.date.year == end.year &&
            l.date.month == end.month &&
            l.date.day == end.day)) {
      logs.add(_todayLog!);
    }

    final byDate = _logsByDate(logs);

    int active = 0;
    int total = 0;

    for (int i = 0; i < days; i++) {
      final date = start.add(Duration(days: i));
      final key = _formatDateKey(date);
      final log = byDate[key];
      final hasAnyCompleted = log != null &&
          log.completedHabitIds.any(programHabitIds.contains);
      if (hasAnyCompleted) {
        active++;
      }
      total++;
    }

    return (active, total);
  }

  /// Compute a simple streak (in days) for a ProgramPack: consecutive
  /// days up to today where at least one habit from [programHabitIds]
  /// was completed.
  int getProgramStreak(List<String> programHabitIds) {
    if (programHabitIds.isEmpty) return 0;

    final logs = List<DailyLog>.from(_recentLogs);
    if (_todayLog != null &&
        !logs.any((l) =>
            l.date.year == _todayLog!.date.year &&
            l.date.month == _todayLog!.date.month &&
            l.date.day == _todayLog!.date.day)) {
      logs.add(_todayLog!);
    }

    logs.sort((a, b) => b.date.compareTo(a.date));

    int streak = 0;
    DateTime checkDate = DateTime.now();
    checkDate = DateTime(checkDate.year, checkDate.month, checkDate.day);

    for (int i = 0; i < 365; i++) {
      final dateKey = _formatDateKey(checkDate);
      final log = _logsByDate(logs)[dateKey];
      final hasAnyCompleted = log != null &&
          log.completedHabitIds.any(programHabitIds.contains);

      if (hasAnyCompleted) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  Future<void> clearAllData() async {
    try {
      await _logService.clearAll();
      _todayLog = null;
      _recentLogs = [];
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing log data: $e');
    }
  }
}
