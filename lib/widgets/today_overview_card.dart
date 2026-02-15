import 'package:flutter/material.dart';

import 'package:daily_reset/models/daily_log.dart';
import 'package:daily_reset/services/streak_service.dart';
import 'package:daily_reset/components/core/components.dart';
import 'package:daily_reset/widgets/hydration_glass.dart';

class TodayOverviewCard extends StatelessWidget {
  final int completedHabits;
  final int totalHabits;
  final MoodLevel? currentMood;
  final int waterCurrentMl;
  final int waterGoalMl;
  final int streakDays;
  final StreakBadge badge;

  const TodayOverviewCard({
    super.key,
    required this.completedHabits,
    required this.totalHabits,
    this.currentMood,
    required this.waterCurrentMl,
    required this.waterGoalMl,
    this.streakDays = 0,
    this.badge = StreakBadge.none,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final habitProgress = totalHabits == 0 ? 0.0 : (completedHabits / totalHabits).clamp(0.0, 1.0);

    return DRCard(
      padding: EdgeInsets.zero,
      elevation: 0,
      backgroundColor:
          theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(24),
      borderColor: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Row 1: Habits & Mood
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Habits Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Habits',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$completedHabits',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                          Text(
                            '/$totalHabits',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: habitProgress,
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                        minHeight: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // Mood Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.mood,
                            size: 20,
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Mood',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (currentMood != null)
                        Row(
                          children: [
                            Text(
                              currentMood!.emoji,
                              style: const TextStyle(fontSize: 28),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                _moodLabel(currentMood!),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          'How are you?',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Row 2: Hydration & Streak (New Layout)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Row(
                        children: [
                          Icon(
                            Icons.water_drop_outlined,
                            size: 20,
                            color: const Color(0xFF4FC3F7),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Hydration',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF4FC3F7),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$waterCurrentMl / $waterGoalMl ml',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Keep it up!',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // Mini 3D Glass
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: HydrationGlass(
                    currentMl: waterCurrentMl.toDouble(),
                    goalMl: waterGoalMl.toDouble(),
                    height: 80,
                    width: 40,
                  ),
                ),
              ],
            ),
             const SizedBox(height: 24),
             // Row 3: Streak - Only show if > 0
             if (streakDays > 0)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                     Icon(Icons.local_fire_department, color: const Color(0xFFFF9800), size: 24),
                     const SizedBox(width: 12),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           '$streakDays-day streak',
                           style: theme.textTheme.titleMedium?.copyWith(
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                         Text(
                           'You\'re on fire!',
                           style: theme.textTheme.bodySmall?.copyWith(
                             color: theme.colorScheme.onSurfaceVariant,
                           ),
                         ),
                       ],
                     ),
                     const Spacer(),
                       if (badge != StreakBadge.none)
                       Image.asset(
                         badge.assetPath,
                         width: 40,
                         height: 40,
                         fit: BoxFit.contain,
                         errorBuilder: (_,__,___) => const SizedBox.shrink(),
                       ),
                  ],
                )
              ),
          ],
        ),
      ),
    );
  }

  String _moodLabel(MoodLevel mood) {
    switch (mood) {
      case MoodLevel.veryLow:
        return 'Not great';
      case MoodLevel.low:
        return 'A bit low';
      case MoodLevel.neutral:
        return 'Okay';
      case MoodLevel.good:
        return 'Good';
      case MoodLevel.veryGood:
        return 'Awesome';
    }
  }
}
