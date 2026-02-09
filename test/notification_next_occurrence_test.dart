import 'package:daily_reset/services/notification_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('nextOccurrence schedules today when now is before reminder time', () {
    final now = DateTime(2026, 2, 6, 8, 0);
    final next = NotificationScheduleHelper.nextOccurrence(
      now: now,
      minutesFromMidnight: 9 * 60,
    );

    expect(next, DateTime(2026, 2, 6, 9, 0));
  });

  test('nextOccurrence schedules tomorrow when today reminder already passed', () {
    final now = DateTime(2026, 2, 6, 10, 0);
    final next = NotificationScheduleHelper.nextOccurrence(
      now: now,
      minutesFromMidnight: 9 * 60,
    );

    expect(next, DateTime(2026, 2, 7, 9, 0));
  });

  test('nextOccurrence picks next valid weekday when weekdays are provided', () {
    final now = DateTime(2026, 2, 3, 10, 0); // Tuesday
    final next = NotificationScheduleHelper.nextOccurrence(
      now: now,
      minutesFromMidnight: 9 * 60,
      weekdays: {1, 3, 5}, // Mon, Wed, Fri
    );

    expect(next, DateTime(2026, 2, 4, 9, 0)); // Wednesday
  });

  test('hydration slots after last slot schedule next day first slot', () {
    final slots = NotificationScheduleHelper.intradaySlots(
      startMinutes: 9 * 60,
      endMinutes: 21 * 60,
      intervalMinutes: 60,
    );
    final now = DateTime(2026, 2, 6, 22, 30);
    final next = NotificationScheduleHelper.nextOccurrence(
      now: now,
      minutesFromMidnight: slots.first,
    );

    expect(next, DateTime(2026, 2, 7, 9, 0));
  });
}
