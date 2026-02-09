import 'package:daily_reset/models/workout_models.dart';

class WorkoutMediaHelper {
  // Map of routine ID to header asset path
  static final Map<String, String> _routineHeaders = {
    'quick_full_body': 'assets/workouts/headers/quick_full_body_header.png',
    'mobility_reset': 'assets/workouts/headers/mobility_reset_header.png',
    'cardio_boost': 'assets/workouts/headers/cardio_boost_header.png',
    'evening_unwind': 'assets/workouts/headers/evening_unwind_header.png',
    'strength_focus': 'assets/workouts/headers/strength_focus_header.png',
  };

  /// Returns the asset path for the routine's hero image, or null if not defined.
  static String? getRoutineHeroAsset(String routineId) {
    return _routineHeaders[routineId];
  }

  /// Returns the GIF asset for an exercise.
  /// Prioritizes the `mediaAsset` field in the step model if available.
  /// Otherwise, allows looking up by name/ID if we were to maintain a separate map (optional).
  static String? getExerciseGifAsset(WorkoutStep step) {
    if (step.mediaAsset != null && step.mediaAsset!.isNotEmpty) {
      return step.mediaAsset;
    }
    // Fallback logic could go here if we wanted to map by name,
    // but we have populated the model directly.
    return null;
  }
}
