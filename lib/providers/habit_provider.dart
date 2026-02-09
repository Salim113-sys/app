import 'package:flutter/material.dart';
import 'package:daily_reset/models/habit.dart';
import 'package:daily_reset/services/habit_service.dart';
import 'package:daily_reset/services/notification_service.dart';

class HabitProvider extends ChangeNotifier {
  final HabitService _habitService;
  final NotificationService _notificationService;
  List<Habit> _habits = [];
  bool _isLoading = false;

  HabitProvider(this._habitService, this._notificationService) {
    loadHabits();
  }

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;
  HabitService get habitService => _habitService;

  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();
    try {
      _habits = await _habitService.getAllHabits();
      // Ensure any existing reminders are scheduled (idempotent scheduling)
      for (final h in _habits) {
        if (h.reminderTimeMinutes != null) {
          await _notificationService.scheduleHabitReminders(h);
        }
      }
    } catch (e) {
      debugPrint('Error loading habits: $e');
      _habits = [];
    }
    _isLoading = false;
    notifyListeners();
  }

   /// Reload habits from storage without additional side effects.
   Future<void> reloadHabits() async {
     await loadHabits();
   }

  Future<void> addHabit(Habit habit) async {
    try {
      await _habitService.addHabit(habit);
      await loadHabits();
      // Schedule notifications if needed
      await _notificationService.scheduleHabitReminders(habit);
    } catch (e) {
      debugPrint('Error adding habit: $e');
      rethrow;
    }
  }

  Future<void> updateHabit(Habit habit) async {
    try {
      await _habitService.updateHabit(habit);
      await loadHabits();
      await _notificationService.scheduleHabitReminders(habit);
    } catch (e) {
      debugPrint('Error updating habit: $e');
      rethrow;
    }
  }

  Future<void> deleteHabit(String id) async {
    try {
      await _habitService.deleteHabit(id);
      await loadHabits();
      await _notificationService.cancelHabitReminders(id);
    } catch (e) {
      debugPrint('Error deleting habit: $e');
      rethrow;
    }
  }

  Habit? getHabitById(String id) {
    try {
      return _habits.firstWhere((h) => h.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Returns all habits that belong to the given program/pack id.
  List<Habit> habitsForProgram(String programId) {
    return _habits.where((h) => h.programId == programId).toList();
  }

  /// Persist a batch of updated habits (e.g. toggling isEnabled in a Program).
  Future<void> updateHabitsBatch(List<Habit> updated) async {
    try {
      for (final habit in updated) {
        await _habitService.updateHabit(habit);
        // Re-schedule notifications if needed; harmless if unchanged.
        if (habit.reminderTimeMinutes != null) {
          await _notificationService.scheduleHabitReminders(habit);
        }
      }
      await loadHabits();
    } catch (e) {
      debugPrint('Error updating habits batch: $e');
      rethrow;
    }
  }

  Future<void> clearAllData() async {
    try {
      await _habitService.clearAll();
      _habits = [];
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing habit data: $e');
    }
  }
}
