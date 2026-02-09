import 'package:flutter/material.dart';
import 'package:daily_reset/theme.dart';

/// Compact day-of-week multi-select (Mon..Sun as 1..7 per DateTime.weekday)
class WeekdaySelector extends StatelessWidget {
  final List<int> selectedDays; // values 1..7
  final ValueChanged<List<int>> onChanged;
  final EdgeInsetsGeometry? padding;

  const WeekdaySelector({
    super.key,
    required this.selectedDays,
    required this.onChanged,
    this.padding,
  });

  static const List<String> _labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const List<String> _semantics = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  @override
  Widget build(BuildContext context) {
    final daysSet = selectedDays.toSet();
    final chips = List<Widget>.generate(7, (index) {
      final dayValue = index + 1; // 1..7
      final selected = daysSet.contains(dayValue);
      return Semantics(
        label: _semantics[index],
        selected: selected,
        button: true,
        child: FilterChip(
          label: Text(
            _labels[index],
            style: context.textStyles.labelMedium?.semiBold,
          ),
          selected: selected,
          onSelected: (value) {
            final next = List<int>.from(selectedDays);
            if (value) {
              if (!next.contains(dayValue)) next.add(dayValue);
            } else {
              next.remove(dayValue);
            }
            next.sort();
            onChanged(next);
          },
          showCheckmark: false,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          selectedColor: Theme.of(context).colorScheme.primaryContainer,
          checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
          side: BorderSide(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
          ),
          avatar: selected
              ? Icon(Icons.check, size: 14, color: Theme.of(context).colorScheme.primary)
              : null,
        ),
      );
    });

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: chips,
      ),
    );
  }
}
