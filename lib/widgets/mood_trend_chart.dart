import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:daily_reset/models/daily_log.dart';
import 'package:daily_reset/theme.dart';

class MoodTrendChart extends StatelessWidget {
  final List<MoodLevel?> moods;

  const MoodTrendChart({super.key, required this.moods});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.paddingMd,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final mood = index < moods.length ? moods[index] : null;
                final date = DateTime.now().subtract(Duration(days: 6 - index));
                return _buildMoodBar(context, mood, date);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodBar(BuildContext context, MoodLevel? mood, DateTime date) {
    final hasData = mood != null;
    final height = hasData ? mood.value * 20.0 : 20.0;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasData)
          Text(
            mood.emoji,
            style: const TextStyle(fontSize: 20),
          )
        else
          const SizedBox(height: 20),
        const SizedBox(height: AppSpacing.xs),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 32,
          height: height,
          decoration: BoxDecoration(
            color: hasData
                ? _getMoodColor(mood)
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          DateFormat('E').format(date).substring(0, 1),
          style: context.textStyles.bodySmall?.withColor(
            Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Color _getMoodColor(MoodLevel mood) {
    switch (mood) {
      case MoodLevel.veryLow:
        return const Color(0xFFE74C3C);
      case MoodLevel.low:
        return const Color(0xFFFF8A80);
      case MoodLevel.neutral:
        return const Color(0xFFFFB74D);
      case MoodLevel.good:
        return const Color(0xFF95E1D3);
      case MoodLevel.veryGood:
        return const Color(0xFF4ECDC4);
    }
  }
}
