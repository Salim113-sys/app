import 'package:daily_reset/models/daily_log.dart';

enum StreakBadge {
  none(0, ''),
  bronze(3, 'assets/badges/bronze.png'),
  silver(7, 'assets/badges/silver.png'),
  gold(14, 'assets/badges/gold.png'),
  platinum(30, 'assets/badges/platinum.png');

  final int minDays;
  final String assetPath;

  const StreakBadge(this.minDays, this.assetPath);
}

class StreakService {
  /// Calculates the current global streak.
  /// A streak continues if there is at least one habit completed OR a mood logged per day.
  /// Skips today if it is incomplete but doesn't break the streak from yesterday.
  int calculateCurrentStreak(List<DailyLog> logs) {
    if (logs.isEmpty) return 0;
    
    // Sort logs descending (newest first)
    logs.sort((a, b) => b.date.compareTo(a.date));

    // Map logs by date string YYYY-MM-DD
    final Map<String, DailyLog> logsByDate = {};
    for (var log in logs) {
      logsByDate[_dateKey(log.date)] = log;
    }

    int streak = 0;
    DateTime checkDate = DateTime.now();

    // Check today first. If today has activity, streak +1. 
    // If not, we don't count it but check yesterday.
    
    // Normalize today
    DateTime normalizedCheck = DateTime(checkDate.year, checkDate.month, checkDate.day);
    
    // 1. Check if we have a log for "checkDate" (today) with activity
    String key = _dateKey(normalizedCheck);
    DailyLog? todayLog = logsByDate[key];
    
    bool todayActive = _isLogActive(todayLog);
    
    if (todayActive) {
      streak++;
    }

    // Move to yesterday
    normalizedCheck = normalizedCheck.subtract(const Duration(days: 1));
    
    // Loop backwards
    for (int i = 0; i < 365; i++) {
       key = _dateKey(normalizedCheck);
       DailyLog? log = logsByDate[key];
       
       if (_isLogActive(log)) {
         streak++;
         normalizedCheck = normalizedCheck.subtract(const Duration(days: 1));
       } else {
         // Streak broken
         break;
       }
    }
    
    return streak;
  }
  
  int calculateBestStreak(List<DailyLog> logs) {
     // Simplifying for V1: Just return current streak as best streak 
     // or implement a full scan if needed. Current streak is usually what matters most for V1.
     // Let's do a simple full scan if possible, otherwise just return current.
     if (logs.isEmpty) return 0;
     
    logs.sort((a, b) => a.date.compareTo(b.date)); // Oldest first
    
    int maxStreak = 0;
    int currentRun = 0;
    
    if (logs.isEmpty) return 0;
    
    // Get range
    DateTime start = logs.first.date;
    DateTime end = DateTime.now();
    end = DateTime(end.year, end.month, end.day);
    start = DateTime(start.year, start.month, start.day);
    
    final Map<String, DailyLog> logsByDate = {};
    for (var log in logs) {
      logsByDate[_dateKey(log.date)] = log;
    }

    // Iterate day by day from start to end (limit 365 days max for perf)
    int daysDiff = end.difference(start).inDays;
    if (daysDiff > 365 * 2) {
       // Too much history, just clamp to last year
       start = end.subtract(const Duration(days: 365));
       daysDiff = 365;
    }

    for (int i = 0; i <= daysDiff; i++) {
       DateTime d = start.add(Duration(days: i));
       DailyLog? log = logsByDate[_dateKey(d)];
       
       if (_isLogActive(log)) {
         currentRun++;
         if (currentRun > maxStreak) maxStreak = currentRun;
       } else {
         currentRun = 0;
       }
    }
    
    return maxStreak;
  }

  StreakBadge getBadgeForStreak(int streak) {
    if (streak >= StreakBadge.platinum.minDays) return StreakBadge.platinum;
    if (streak >= StreakBadge.gold.minDays) return StreakBadge.gold;
    if (streak >= StreakBadge.silver.minDays) return StreakBadge.silver;
    if (streak >= StreakBadge.bronze.minDays) return StreakBadge.bronze;
    return StreakBadge.none;
  }

  bool _isLogActive(DailyLog? log) {
    if (log == null) return false;
    // Considered active if mood is logged OR at least one habit completed
    return log.mood != null || log.completedHabitIds.isNotEmpty;
  }

  String _dateKey(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';
  }
}
