import 'package:daily_reset/services/notification_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const managedKey = 'managed_notification_ids';

  test('feature cancel methods untrack only their managed ID ranges', () async {
    final habitId = 'habit-a';
    final habitBase = habitId.hashCode & 0x7fffffff;
    final hydrationBase = 'hydration'.hashCode & 0x7fffffff;
    final movementBase = 'movement'.hashCode & 0x7fffffff;
    final deepWorkBase = 'deep_work'.hashCode & 0x7fffffff;

    final ids = <int>{
      habitBase + 1,
      habitBase + 7,
      hydrationBase + 1,
      hydrationBase + 49,
      movementBase + 1,
      deepWorkBase + 1,
      -1,
    };

    SharedPreferences.setMockInitialValues({
      managedKey: ids.map((id) => id.toString()).toList(growable: false),
    });

    final service = NotificationService();
    await service.cancelHabitReminders(habitId);
    await service.cancelHydrationReminders();
    await service.cancelMovementReminders();
    await service.cancelDeepWorkReminders();

    final prefs = await SharedPreferences.getInstance();
    final remaining = prefs.getStringList(managedKey) ?? const <String>[];
    expect(remaining, <String>['-1']);
  });

  test('cancelAllManagedReminders clears tracked ID set safely', () async {
    SharedPreferences.setMockInitialValues({
      managedKey: <String>['101', '202', '303'],
    });

    final service = NotificationService();
    await service.cancelAllManagedReminders();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getStringList(managedKey), isEmpty);
  });
}
