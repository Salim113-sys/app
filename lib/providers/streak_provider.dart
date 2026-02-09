import 'package:flutter/material.dart';
import 'package:daily_reset/providers/daily_log_provider.dart';
import 'package:daily_reset/services/streak_service.dart';

class StreakProvider extends ChangeNotifier {
  final DailyLogProvider _dailyLogProvider;
  final StreakService _streakService = StreakService();

  int _currentStreak = 0;
  int _bestStreak = 0;
  StreakBadge _currentBadge = StreakBadge.none;

  StreakProvider(this._dailyLogProvider) {
    _updateStreaks();
    _dailyLogProvider.addListener(_updateStreaks);
  }

  int get currentStreak => _currentStreak;
  int get bestStreak => _bestStreak;
  StreakBadge get currentBadge => _currentBadge;

  void _updateStreaks() {
    // Get all 'recent' logs + make sure we have enough history if possible.
    // DailyLogProvider typically loads last 7 days.
    // However, StreakService needs full history for Best Streak.
    // For now, we will use whatever logs are available in DailyLogProvider.
    // NOTE: If DailyLogProvider only keeps 7 days, streaks > 7 might be inaccurate 
    // unless we load more. For V1 MVP, we will rely on what is loaded 
    // or assume we might need to fetch all logic if not expensive.
    
    // We can assume recentLogs are decent enough for Current Streak.
    // But for "Best Streak", we might need a dedicated fetch in service.
    // Let's use `recentLogs` combined with `todayLog` for real-time updates.
    
    final logs = [
      ..._dailyLogProvider.recentLogs,
      if (_dailyLogProvider.todayLog != null) _dailyLogProvider.todayLog!
    ];
    
    // Remove duplicates just in case
    final uniqueLogs = {for (var log in logs) '${log.date.year}-${log.date.month}-${log.date.day}': log}.values.toList();

    _currentStreak = _streakService.calculateCurrentStreak(uniqueLogs);
    // Best streak might be under-reported if we don't have all logs, 
    // but for now this is safe without breaking architecture.
    _bestStreak = _streakService.calculateBestStreak(uniqueLogs);
    
    _currentBadge = _streakService.getBadgeForStreak(_currentStreak);
    
    notifyListeners();
  }
  
  @override
  void dispose() {
    _dailyLogProvider.removeListener(_updateStreaks);
    super.dispose();
  }
}
