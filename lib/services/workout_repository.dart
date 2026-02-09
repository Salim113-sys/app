import 'dart:async';

import 'package:daily_reset/models/workout_models.dart';
import 'package:daily_reset/services/storage_service.dart';
import 'package:flutter/foundation.dart';

class WorkoutRepository {
  static const String _logsKey = 'workout_session_logs_v1';

  // Asset Constants
  static const String assetWarmupMarch = 'assets/workout/warmup_march.png';
  static const String assetBodyweightSquats = 'assets/workout/bodyweight_squats.png';
  static const String assetInclinePushups = 'assets/workout/incline_pushups.png';
  static const String assetPlankHold = 'assets/workout/plank_hold.png';
  static const String assetNeckRolls = 'assets/workout/neck_rolls.png';
  static const String assetCatCow = 'assets/workout/cat_cow.png';
  static const String assetHipCircles = 'assets/workout/hip_circles.png';
  static const String assetHighKnees = 'assets/workout/high_knees.png';
  static const String assetFastFeet = 'assets/workout/fast_feet.png';
  static const String assetChildsPose = 'assets/workout/childs_pose.png';
  static const String assetFigure4 = 'assets/workout/figure_4.png';
  static const String assetReverseLunges = 'assets/workout/reverse_lunges.png';
  static const String assetPushups = 'assets/workout/pushups.png';
  static const String assetDeadBug = 'assets/workout/dead_bug.png';

  final StorageService _storage;
  final List<WorkoutRoutine> _routines;
  final List<WorkoutStep> _steps;

  final StreamController<List<WorkoutSessionLog>> _logsController =
      StreamController<List<WorkoutSessionLog>>.broadcast();

  List<WorkoutSessionLog> _logs = [];

  WorkoutRepository._(this._storage, this._routines, this._steps);

  static Future<WorkoutRepository> create() async {
    final storage = await StorageService.getInstance();
    final repo = WorkoutRepository._(storage, _seedRoutines, _seedSteps);
    await repo._loadLogs();
    return repo;
  }

  List<WorkoutRoutine> get routines => List.unmodifiable(_routines);

  List<WorkoutStep> stepsForRoutine(String routineId) {
    return _steps.where((s) => s.routineId == routineId).toList();
  }

  Stream<List<WorkoutSessionLog>> get logsStream => _logsController.stream;

  List<WorkoutSessionLog> get logs => List.unmodifiable(_logs);

  Future<void> _loadLogs() async {
    try {
      final rawList = _storage.getJsonList(_logsKey);
      if (rawList == null) {
        _logs = [];
      } else {
        _logs = rawList
            .map((e) => WorkoutSessionLog.fromJson(e))
            .toList(growable: false);
      }
    } catch (e, st) {
      debugPrint('WorkoutRepository._loadLogs error: $e\n$st');
      _logs = [];
    }
    _logsController.add(_logs);
  }

  Future<void> addSessionLog(WorkoutSessionLog log) async {
    _logs = [..._logs, log];
    await _persist();
  }

  Future<void> _persist() async {
    try {
      await _storage.saveJsonList(
        _logsKey,
        _logs.map((e) => e.toJson()).toList(growable: false),
      );
    } catch (e, st) {
      debugPrint('WorkoutRepository._persist error: $e\n$st');
    }
    _logsController.add(_logs);
  }

  Future<void> clearAllData() async {
    try {
      await _storage.remove(_logsKey);
    } catch (e, st) {
      debugPrint('WorkoutRepository.clearAllData error: $e\n$st');
    }
    _logs = [];
    _logsController.add(_logs);
  }

  /// Returns list of maps with keys: date (DateTime), totalMinutes (int), hasSession (bool).
  List<Map<String, dynamic>> getLast7DaysSummary() {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day)
        .subtract(const Duration(days: 6));

    final Map<DateTime, int> minutesPerDay = {};
    final Map<DateTime, bool> hasSessionPerDay = {};

    for (final log in _logs) {
      final day = DateTime(log.startTime.year, log.startTime.month, log.startTime.day);
      if (day.isBefore(start)) continue;
      minutesPerDay[day] = (minutesPerDay[day] ?? 0) + log.totalMinutes;
      hasSessionPerDay[day] = true;
    }

    final List<Map<String, dynamic>> result = [];
    for (int i = 0; i < 7; i++) {
      final date = start.add(Duration(days: i));
      result.add({
        'date': date,
        'totalMinutes': minutesPerDay[date] ?? 0,
        'hasSession': hasSessionPerDay[date] ?? false,
      });
    }
    return result;
  }

  (int totalMinutes, int activeDays) getLast7DaysTotals() {
    final data = getLast7DaysSummary();
    int totalMinutes = 0;
    int activeDays = 0;
    for (final day in data) {
      final minutes = day['totalMinutes'] as int? ?? 0;
      if (minutes > 0) activeDays++;
      totalMinutes += minutes;
    }
    return (totalMinutes, activeDays);
  }

  static List<WorkoutRoutine> get _seedRoutines => const [
        WorkoutRoutine(
          id: 'quick_full_body',
          name: 'Quick Full Body',
          description: 'A short, balanced routine to wake up your whole body.',
          difficulty: WorkoutDifficulty.beginner,
          goal: WorkoutGoal.strength,
          estimatedMinutes: 15,
          isFeatured: true,
          tags: ['full body', 'warmup'],
          mediaAsset: 'assets/programs/quick_full_body_hero.png',
        ),
        WorkoutRoutine(
          id: 'mobility_reset',
          name: 'Mobility Reset',
          description: 'Gentle stretches to undo desk tension and improve mobility.',
          difficulty: WorkoutDifficulty.beginner,
          goal: WorkoutGoal.mobility,
          estimatedMinutes: 12,
          isFeatured: true,
          tags: ['stretch', 'desk'],
          mediaAsset: 'assets/programs/mobility_reset_hero.png',
        ),
        WorkoutRoutine(
          id: 'cardio_boost',
          name: 'Cardio Boost',
          description: 'Interval-style cardio to raise your heart rate.',
          difficulty: WorkoutDifficulty.intermediate,
          goal: WorkoutGoal.cardio,
          estimatedMinutes: 20,
          tags: ['hiit', 'intervals'],
          mediaAsset: 'assets/programs/cardio_boost_hero.png',
        ),
        WorkoutRoutine(
          id: 'evening_unwind',
          name: 'Evening Unwind',
          description: 'Slow, grounding movements to help you wind down.',
          difficulty: WorkoutDifficulty.beginner,
          goal: WorkoutGoal.relax,
          estimatedMinutes: 10,
          tags: ['relax', 'evening'],
          mediaAsset: 'assets/programs/evening_unwind_hero.png',
        ),
        WorkoutRoutine(
          id: 'strength_focus',
          name: 'Strength Focus',
          description: 'Focused strength blocks for legs, core, and upper body.',
          difficulty: WorkoutDifficulty.advanced,
          goal: WorkoutGoal.strength,
          estimatedMinutes: 25,
          tags: ['strength'],
          mediaAsset: 'assets/programs/strength_focus_hero.png',
        ),
      ];

  static List<WorkoutStep> get _seedSteps {
    final List<WorkoutStep> steps = [];

    void add(
      String routineId,
      String title,
      String description, {
      int? seconds,
      int? reps,
      WorkoutStepType type = WorkoutStepType.timed,
      String? icon, // Material Icon name
      String? mediaAsset, // Path to PNG/GIF
      String? instructions,
      int? recommendedSeconds,
      int? recommendedReps,
    }) {
      steps.add(WorkoutStep(
        routineId: routineId,
        title: title,
        description: description,
        durationSeconds: seconds,
        reps: reps,
        type: type,
        iconName: icon,
        mediaType: mediaAsset != null && mediaAsset.endsWith('.gif')
            ? WorkoutMediaType.gif
            : WorkoutMediaType.image,
        mediaAsset: mediaAsset,
        instructions: instructions,
        recommendedSeconds: recommendedSeconds,
        recommendedReps: recommendedReps,
      ));
    }

    // 1. Quick Full Body (Balanced)
    add(
      'quick_full_body',
      'Warm-up March',
      'Light marching in place to get blood flowing.',
      seconds: 60,
      recommendedSeconds: 60,
      type: WorkoutStepType.timed,
      icon: 'directions_walk',
      mediaAsset: 'assets/exercises/warm_up_march.png',
      instructions:
          'Stand tall. Lift knees rhythmically while swinging opposite arms. Keep chest up.',
    );
    add(
      'quick_full_body',
      'Bodyweight Squats',
      'Basic squat to engage legs and glutes.',
      reps: 12,
      recommendedReps: 12,
      type: WorkoutStepType.reps,
      icon: 'accessibility_new', // Squat posture
      mediaAsset: 'assets/exercises/bodyweight_squats.png',
      instructions:
          'Feet shoulder-width. Sit back and down. Keep chest up. Drive through heels to stand.',
    );
    add(
      'quick_full_body',
      'Incline Push-ups',
      'Upper body pushing movement using a support.',
      reps: 10,
      recommendedReps: 10,
      type: WorkoutStepType.reps,
      icon: 'vertical_align_top', // Pushing up
      mediaAsset: 'assets/exercises/incline_pushups.png',
      instructions:
          'Hands on a stable surface (chair/wall). Lower chest towards it, then push back up. Core tight.',
    );
    add(
      'quick_full_body',
      'Reverse Lunges',
      'Unilateral leg exercise for balance.',
      reps: 12,
      recommendedReps: 12,
      type: WorkoutStepType.reps,
      icon: 'directions_walk', // Lunge motion
      mediaAsset: 'assets/exercises/reverse_lunges.png',
      instructions:
          'Step back, lower knee towards ground. Push through front heel to return. Alternate sides.',
    );
    add(
      'quick_full_body',
      'Plank Hold',
      'Core stability hold.',
      seconds: 40,
      recommendedSeconds: 40,
      type: WorkoutStepType.timed,
      icon: 'shield', // Stability
      mediaAsset: 'assets/exercises/plank_hold.png',
      instructions:
          'Forearms on floor. Straight line from head to heels. Squeeze glutes and core. Hold.',
    );

    // 2. Mobility Reset (Desk/Office Relief)
    add(
      'mobility_reset',
      'Neck Rolls',
      'Release tension in the neck.',
      seconds: 45,
      recommendedSeconds: 45,
      type: WorkoutStepType.timed,
      icon: 'face', // Head/Neck focus
      mediaAsset: 'assets/exercises/neck_rolls.png',
      instructions:
          'Slowly roll head from shoulder to shoulder. Avoid sharp pain. Breathe deeply.',
    );
    add(
      'mobility_reset',
      'Cat-Cow',
      'Mobilize the spine.',
      seconds: 60,
      recommendedSeconds: 60,
      type: WorkoutStepType.timed,
      icon: 'pets', // Cat
      mediaAsset: 'assets/exercises/cat_cow.png',
      instructions:
          'Tabletop position. Inhale, drop belly (Cow). Exhale, round back (Cat). Move comfortably.',
    );
    add(
      'mobility_reset',
      'Thoracic Rotations',
      'Open up the mid-back.',
      seconds: 60,
      recommendedSeconds: 60,
      type: WorkoutStepType.timed,
      icon: 'cyclone', // Rotation
      mediaAsset: 'assets/exercises/thoracic_rotations.png',
      instructions:
          'Hand behind head. Rotate elbow down, then open up towards ceiling. Follow with gaze.',
    );
    add(
      'mobility_reset',
      'Hip Circles',
      'Loosen up tight hips.',
      seconds: 45,
      recommendedSeconds: 45,
      type: WorkoutStepType.timed,
      icon: 'donut_large', // Circle
      mediaAsset: 'assets/exercises/hip_circles.png',
      instructions:
          'Hands on hips. Large circles pushing forward, side, and back. Reverse direction halfway.',
    );
    add(
      'mobility_reset',
      'Child\'s Pose',
      'Gentle lower back stretch.',
      seconds: 60,
      recommendedSeconds: 60,
      type: WorkoutStepType.timed,
      icon: 'baby_changing_station', // Child pose metaphor, or self_improvement
      mediaAsset: 'assets/exercises/childs_pose.png',
      instructions:
          'Kneel wide. Sit back on heels. Reach arms forward on floor. Rest forehead. Relax.',
    );

    // 3. Cardio Boost (HIIT-lite)
    add(
      'cardio_boost',
      'March in Place',
      'Warm up the body.',
      seconds: 60,
      recommendedSeconds: 60,
      type: WorkoutStepType.timed,
      icon: 'directions_walk',
      mediaAsset: 'assets/exercises/march_in_place.png',
      instructions: 'Pump arms and lift knees high. Warm up your system.',
    );
    add(
      'cardio_boost',
      'Step Jacks',
      'Low impact jumping jacks.',
      seconds: 45,
      recommendedSeconds: 45,
      type: WorkoutStepType.timed,
      icon: 'accessibility', // Arms out
      mediaAsset: 'assets/exercises/step_jacks.png',
      instructions:
          'Step side to side while raising arms overhead. Keep a steady, fast rhythm.',
    );
    add(
      'cardio_boost',
      'High Knees',
      'Drive knees up to increase heart rate.',
      seconds: 30,
      recommendedSeconds: 30,
      type: WorkoutStepType.timed,
      icon: 'publish', // Up arrow motion
      mediaAsset: 'assets/exercises/high_knees.png',
      instructions:
          'Run in place driving knees up high towards chest. Land soft.',
    );
    add(
      'cardio_boost',
      'Rest',
      'Catch your breath.',
      seconds: 30,
      recommendedSeconds: 30,
      type: WorkoutStepType.timed,
      icon: 'battery_charging_full', // Recharging
      mediaAsset: 'assets/exercises/rest.png',
      instructions: 'Walk slowly. Inhale through nose, exhale through mouth.',
    );
    add(
      'cardio_boost',
      'Fast Feet',
      'Quick agility movement.',
      seconds: 30,
      recommendedSeconds: 30,
      type: WorkoutStepType.timed,
      icon: 'bolt', // Fast
      mediaAsset: 'assets/exercises/fast_feet.png',
      instructions:
          'Athletic stance. Tap feet quickly in place. Stay on balls of feet.',
    );
    add(
      'cardio_boost',
      'Butt Kicks',
      'Active recovery movement.',
      seconds: 45,
      recommendedSeconds: 45,
      type: WorkoutStepType.timed,
      icon: 'replay', // Cycle motion
      mediaAsset: 'assets/exercises/butt_kicks.png',
      instructions: 'Jog in place, kicking heels up to glutes.',
    );

    // 4. Evening Unwind (Relaxation)
    add(
      'evening_unwind',
      'Neck Stretch',
      'Release neck tension.',
      seconds: 60,
      recommendedSeconds: 60,
      type: WorkoutStepType.timed,
      icon: 'sentiment_satisfied', // Relaxed face
      mediaAsset: 'assets/exercises/neck_stretch.png',
      instructions:
          'Gently tilt ear to shoulder. Hold. Breathe tension out. Switch sides.',
    );
    add(
      'evening_unwind',
      'Shoulder Rolls',
      'Relax the shoulders.',
      seconds: 60,
      recommendedSeconds: 60,
      type: WorkoutStepType.timed,
      icon: 'cached', // Rolling
      mediaAsset: 'assets/exercises/shoulder_rolls.png',
      instructions: 'Roll shoulders up, back, and down. Release the day\'s weight.',
    );
    add(
      'evening_unwind',
      'Seated Forward Fold',
      'Stretch the back and hamstrings.',
      seconds: 60,
      recommendedSeconds: 60,
      type: WorkoutStepType.timed,
      icon: 'airline_seat_legroom_extra', // Legs extended
      mediaAsset: 'assets/exercises/seated_forward_fold.png',
      instructions:
          'Legs straight. Hinge at hips to fold forward. Relax head. Don\'t force it.',
    );
    add(
      'evening_unwind',
      'Figure-4 Stretch',
      'Hip opener.',
      seconds: 60,
      recommendedSeconds: 60,
      type: WorkoutStepType.timed,
      icon: 'filter_4', // Figure 4
      mediaAsset: 'assets/exercises/figure4_stretch.png',
      instructions:
          'On back. Cross ankle over knee. Pull thigh towards you. Feel the hip stretch.',
    );
    add(
      'evening_unwind',
      'Deep Breathing',
      'Calm the nervous system.',
      seconds: 60,
      recommendedSeconds: 60,
      type: WorkoutStepType.timed,
      icon: 'air',
      mediaAsset: 'assets/exercises/deep_breathing.png',
      instructions:
          'Inhale 4s, Exhale 6s. Focus on the breath. Let go of thoughts.',
    );

    // 5. Strength Focus (Advanced)
    add(
      'strength_focus',
      'Bodyweight Squats',
      'Lower body strength.',
      reps: 15,
      recommendedReps: 15,
      type: WorkoutStepType.reps,
      icon: 'accessibility_new',
      mediaAsset: 'assets/exercises/bodyweight_squats.png',
      instructions:
          'Deep squats. Keep weight in heels. Squeeze glutes at top.',
    );
    add(
      'strength_focus',
      'Standard Push-ups',
      'Upper body strength.',
      reps: 10,
      recommendedReps: 10,
      type: WorkoutStepType.reps,
      icon: 'fitness_center',
      mediaAsset: 'assets/exercises/standard_pushups.png',
      instructions: 'Chest to floor. Elbows at 45 degrees. Push strong.',
    );
    add(
      'strength_focus',
      'Alternating Lunges',
      'Leg strength and balance.',
      reps: 24,
      recommendedReps: 24,
      type: WorkoutStepType.reps,
      icon: 'directions_walk',
      mediaAsset: 'assets/exercises/alternating_lunges.png',
      instructions: 'Step forward lunge. Knees 90 degrees. Alternate legs.',
    );
    add(
      'strength_focus',
      'Glute Bridges',
      'Posterior chain activation.',
      reps: 15,
      recommendedReps: 15,
      type: WorkoutStepType.reps,
      icon: 'terrain', // Bridge shape
      mediaAsset: 'assets/exercises/glute_bridges.png',
      instructions: 'Lift hips high. Squeeze glutes hard. Lower slow.',
    );
    add(
      'strength_focus',
      'Dead Bug',
      'Core stability.',
      reps: 16,
      recommendedReps: 16,
      type: WorkoutStepType.reps,
      icon: 'bug_report',
      mediaAsset: 'assets/exercises/dead_bug.png',
      instructions:
          'Opposite arm and leg lower. Keep lower back glued to floor. Control it.',
    );
    add(
      'strength_focus',
      'Wall Sit',
      'Isometric leg endurance.',
      seconds: 45,
      recommendedSeconds: 45,
      type: WorkoutStepType.timed,
      icon: 'chair', // Sit
      mediaAsset: 'assets/exercises/wall_sit.png',
      instructions:
          'Sit against wall. Thighs parallel to floor. Hold and breathe.',
    );

    return steps;
  }
}
