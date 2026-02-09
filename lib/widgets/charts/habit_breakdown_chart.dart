import 'package:flutter/material.dart';
import 'package:daily_reset/models/habit.dart';
import 'package:daily_reset/models/daily_log.dart';
import 'package:daily_reset/theme.dart';

class HabitBreakdownChart extends StatelessWidget {
  final List<Habit> habits;
  final List<DailyLog> recentLogs; // Last 7 days

  const HabitBreakdownChart({
    super.key,
    required this.habits,
    required this.recentLogs,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Calculate stats per habit
    // Map<HabitId, completionCount>
    final stats = <String, int>{};
    for (final log in recentLogs) {
      for (final id in log.completedHabitIds) {
        stats[id] = (stats[id] ?? 0) + 1;
      }
    }

    // Sort habits: Top performers first, then name
    final sortedHabits = List<Habit>.from(habits);
    sortedHabits.sort((a, b) {
      final countA = stats[a.id] ?? 0;
      final countB = stats[b.id] ?? 0;
      if (countA != countB) return countB.compareTo(countA);
      return a.name.compareTo(b.name);
    });

    final topHabits = sortedHabits.take(5).toList(); // Show max 5 for cleanliness

    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                'Top Habits (Last 7 Days)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.bar_chart, color: Theme.of(context).colorScheme.primary, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          if (topHabits.isEmpty)
             const Text("No active habits yet."),
          for (final habit in topHabits) ...[
            _HabitBarRow(
              habit: habit, 
              count: stats[habit.id] ?? 0, 
              total: 7,
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _HabitBarRow extends StatelessWidget {
  final Habit habit;
  final int count;
  final int total;

  const _HabitBarRow({
    required this.habit, 
    required this.count, 
    required this.total
  });

  @override
  Widget build(BuildContext context) {
    final progress = (count / total).clamp(0.0, 1.0);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              habit.name,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,  
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            color: _getProgressColor(progress),
          ),
        ),
      ],
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 0.8) return const Color(0xFF4ECDC4); // Greenish
    if (progress >= 0.5) return const Color(0xFFFFB74D); // Orange
    return const Color(0xFFFF8A80); // Red
  }
}
