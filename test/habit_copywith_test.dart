import 'package:daily_reset/models/habit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Habit.copyWith can explicitly clear reminder fields', () {
    final habit = Habit(
      name: 'Test Habit',
      category: HabitCategory.body,
      targetDaysPerWeek: 3,
      reminderTimeMinutes: 8 * 60 + 30,
      reminderDays: const [1, 3, 5],
    );

    final updated = habit.copyWith(
      reminderTimeMinutes: null,
      reminderDays: null,
    );

    expect(updated.reminderTimeMinutes, isNull);
    expect(updated.reminderDays, isNull);
  });
}
