import 'package:flutter/material.dart';
import 'package:daily_reset/models/habit.dart';
import 'package:daily_reset/theme.dart';
import 'package:daily_reset/components/core/components.dart';

class StatCard extends StatelessWidget {
  final Habit habit;
  final int streak;
  final double weeklyCompletion;

  const StatCard({
    super.key,
    required this.habit,
    required this.streak,
    required this.weeklyCompletion,
  });

  @override
  Widget build(BuildContext context) {
    return DRCard(
      padding: EdgeInsets.zero,
      child: Padding(
        padding: AppSpacing.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  habit.category.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    habit.name,
                    style: context.textStyles.bodyLarge?.semiBold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    icon: Icons.local_fire_department,
                    label: 'Streak',
                    value: '$streak ${streak == 1 ? 'day' : 'days'}',
                    color: streak > 0
                        ? const Color(0xFFFF6B6B)
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    icon: Icons.percent,
                    label: 'Weekly',
                    value: '${weeklyCompletion.toStringAsFixed(0)}%',
                    color: weeklyCompletion >= 70
                        ? const Color(0xFF95E1D3)
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: context.textStyles.titleMedium?.bold.withColor(color),
        ),
        Text(
          label,
          style: context.textStyles.bodySmall?.withColor(
            Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
