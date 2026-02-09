import 'package:daily_reset/models/habit.dart';
import 'package:daily_reset/models/program_pack.dart';
import 'package:daily_reset/services/storage_service.dart';
import 'package:flutter/foundation.dart';

class HabitService {
  static const String _storageKey = 'habits';
  final StorageService _storage;

  HabitService(this._storage);

  Future<List<Habit>> getAllHabits() async {
    try {
      final jsonList = _storage.getJsonList(_storageKey);
      if (jsonList == null || jsonList.isEmpty) {
        final sampleHabits = _getSampleHabits();
        await _saveHabits(sampleHabits);
        return sampleHabits;
      }
      final habits = <Habit>[];
      for (final json in jsonList) {
        try {
          habits.add(Habit.fromJson(json));
        } catch (e) {
          debugPrint('Failed to parse habit: $e');
        }
      }
      if (habits.isEmpty) {
        final sampleHabits = _getSampleHabits();
        await _saveHabits(sampleHabits);
        return sampleHabits;
      }
      return habits;
    } catch (e) {
      debugPrint('Error loading habits: $e');
      final sampleHabits = _getSampleHabits();
      await _saveHabits(sampleHabits);
      return sampleHabits;
    }
  }

  Future<Habit> getHabitById(String id) async {
    final habits = await getAllHabits();
    return habits.firstWhere((h) => h.id == id);
  }

  Future<void> addHabit(Habit habit) async {
    final habits = await getAllHabits();
    habits.add(habit);
    await _saveHabits(habits);
  }

  Future<void> updateHabit(Habit habit) async {
    final habits = await getAllHabits();
    final index = habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      habits[index] = habit;
      await _saveHabits(habits);
    }
  }

  Future<void> deleteHabit(String id) async {
    final habits = await getAllHabits();
    habits.removeWhere((h) => h.id == id);
    await _saveHabits(habits);
  }

  /// Ensure that the Workout program always has its default habits available.
  ///
  /// If *no* habits currently exist with `programId == workoutId`, the five
  /// default Workout habits from [_getSampleHabits] are appended and saved.
  Future<void> ensureWorkoutDefaultsSeeded() async {
    try {
      final habits = await getAllHabits();
      final hasWorkout =
          habits.any((h) => h.programId == ProgramPacksRepository.workoutId);
      if (hasWorkout) return;

      final sample = _getSampleHabits();
      final workoutDefaults = sample
          .where((h) => h.programId == ProgramPacksRepository.workoutId)
          .toList();

      if (workoutDefaults.isEmpty) {
        debugPrint('ensureWorkoutDefaultsSeeded: no workout defaults found in _getSampleHabits');
        return;
      }

      final updated = [...habits, ...workoutDefaults];
      await _saveHabits(updated);
    } catch (e) {
      debugPrint('Error in ensureWorkoutDefaultsSeeded: $e');
    }
  }

  Future<void> _saveHabits(List<Habit> habits) async {
    final jsonList = habits.map((h) => h.toJson()).toList();
    await _storage.saveJsonList(_storageKey, jsonList);
  }

  Future<void> clearAll() async {
    await _storage.remove(_storageKey);
  }



  List<Habit> _getSampleHabits() => [
        Habit(
          name: 'Morning Stretch',
          description: 'Wake up your body with 5 minutes of gentle movement to start fresh.',
          category: HabitCategory.body,
          programId: ProgramPacksRepository.movementId,
          targetDaysPerWeek: 7,
        ),
        Habit(
          name: 'Hydration Kickstart',
          description: 'Drink a large glass of water immediately after waking up.',
          category: HabitCategory.body,
          programId: ProgramPacksRepository.hydrationId,
          targetDaysPerWeek: 7,
        ),
        Habit(
          name: 'Gratitude Journal',
          description: 'Write down 3 specific things that brought you joy today.',
          category: HabitCategory.mind,
          programId: ProgramPacksRepository.generalId,
          targetDaysPerWeek: 5,
        ),
        Habit(
          name: 'Deep Work Session',
          description: '30 minutes of laser-focused work with zero distractions.',
          category: HabitCategory.focus,
          programId: ProgramPacksRepository.deepWorkId,
          targetDaysPerWeek: 5,
        ),
        Habit(
          name: 'Evening Unwind',
          description: 'Disconnect and take a 15-minute walk to clear your mind before bed.',
          category: HabitCategory.life,
          programId: ProgramPacksRepository.movementId,
          targetDaysPerWeek: 4,
        ),
        // --- Workout default habits ---
        Habit(
          name: 'Full body strength (3x/week)',
          description:
              '15–25 minutes of full-body exercises (squats, incline push-ups, lunges, rows with bands, etc.).',
          category: HabitCategory.body,
          programId: ProgramPacksRepository.workoutId,
          targetDaysPerWeek: 3,
          reminderDays: const [1, 3, 5], // Mon, Wed, Fri
          // 18:00 -> 18 * 60
          reminderTimeMinutes: 18 * 60,
          isEnabled: true,
        ),
        Habit(
          name: 'Morning mobility (daily 5 min)',
          description:
              'Short mobility routine for neck, shoulders, hips and ankles to start the day.',
          category: HabitCategory.body,
          programId: ProgramPacksRepository.workoutId,
          targetDaysPerWeek: 7,
          reminderDays: const [1, 2, 3, 4, 5, 6, 7],
          // 07:30 -> 7 * 60 + 30
          reminderTimeMinutes: 7 * 60 + 30,
          isEnabled: true,
        ),
        Habit(
          name: 'Core & posture (2x/week)',
          description:
              'Core exercises (planks, bird-dog, dead bug) to protect your back and improve posture.',
          category: HabitCategory.body,
          programId: ProgramPacksRepository.workoutId,
          targetDaysPerWeek: 2,
          reminderDays: const [2, 4], // Tue, Thu
          // 19:00 -> 19 * 60
          reminderTimeMinutes: 19 * 60,
          isEnabled: true,
        ),
        Habit(
          name: 'Light cardio / walk (20 min)',
          description:
              '20 minutes of brisk walking or light cardio (bike, elliptical, etc.).',
          category: HabitCategory.body,
          programId: ProgramPacksRepository.workoutId,
          targetDaysPerWeek: 3,
          reminderDays: const [2, 6, 7], // Tue, Sat, Sun
          // 17:30 -> 17 * 60 + 30
          reminderTimeMinutes: 17 * 60 + 30,
          isEnabled: false,
        ),
        Habit(
          name: 'Recovery stretch (2x/week)',
          description:
              'Short stretching session (5–10 min) to unwind after a busy day or workout.',
          category: HabitCategory.body,
          programId: ProgramPacksRepository.workoutId,
          targetDaysPerWeek: 2,
          reminderDays: const [3, 6], // Wed, Sat
          // 21:30 -> 21 * 60 + 30
          reminderTimeMinutes: 21 * 60 + 30,
          isEnabled: false,
        ),
      ];
}
