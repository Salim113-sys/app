import 'package:flutter/material.dart';
import 'package:daily_reset/models/daily_log.dart';


class MoodSelector extends StatelessWidget {
  final MoodLevel? selectedMood;
  final Function(MoodLevel) onMoodSelected;

  const MoodSelector({
    super.key,
    this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: MoodLevel.values.map((mood) {
        final isSelected = selectedMood == mood;
        return GestureDetector(
          onTap: () => onMoodSelected(mood),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    )
                  : null,
            ),
            child: Center(
              child: Text(
                mood.emoji,
                style: TextStyle(
                  fontSize: isSelected ? 32 : 28,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
