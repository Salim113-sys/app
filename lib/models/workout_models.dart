import 'package:uuid/uuid.dart';

enum WorkoutDifficulty { beginner, intermediate, advanced }

enum WorkoutGoal { strength, mobility, cardio, relax }

enum WorkoutStepType { timed, reps }

enum WorkoutIntensity { low, medium, high }

enum WorkoutMediaType { icon, image, gif, video, illustration }

class WorkoutRoutine {
  final String id;
  final String name;
  final String description;
  final WorkoutDifficulty difficulty;
  final WorkoutGoal goal;
  final int estimatedMinutes;
  final bool isFeatured;
  final List<String> tags;
  final String? mediaAsset;

  const WorkoutRoutine({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.goal,
    required this.estimatedMinutes,
    this.isFeatured = false,
    this.tags = const [],
    this.mediaAsset,
  });

  WorkoutRoutine copyWith({
    String? id,
    String? name,
    String? description,
    WorkoutDifficulty? difficulty,
    WorkoutGoal? goal,
    int? estimatedMinutes,
    bool? isFeatured,
    List<String>? tags,
    String? mediaAsset,
  }) {
    return WorkoutRoutine(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      goal: goal ?? this.goal,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      isFeatured: isFeatured ?? this.isFeatured,
      tags: tags ?? this.tags,
      mediaAsset: mediaAsset ?? this.mediaAsset,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'difficulty': difficulty.name,
        'goal': goal.name,
        'estimatedMinutes': estimatedMinutes,
        'isFeatured': isFeatured,
        'tags': tags,
        'mediaAsset': mediaAsset,
      };

  factory WorkoutRoutine.fromJson(Map<String, dynamic> json) => WorkoutRoutine(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        difficulty: WorkoutDifficulty.values.firstWhere(
          (e) => e.name == json['difficulty'],
          orElse: () => WorkoutDifficulty.beginner,
        ),
        goal: WorkoutGoal.values.firstWhere(
          (e) => e.name == json['goal'],
          orElse: () => WorkoutGoal.strength,
        ),
        estimatedMinutes: json['estimatedMinutes'] as int? ?? 10,
        isFeatured: json['isFeatured'] as bool? ?? false,
        tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        mediaAsset: json['mediaAsset'] as String?,
      );
}

class WorkoutStep {
  final String id;
  final String routineId;
  final String title;
  final String description;
  final int? durationSeconds;
  final int? reps;
  final WorkoutStepType type;
  final String? iconName; // Legacy, kept for backward compatibility
  final WorkoutMediaType mediaType;
  final String? mediaAsset; // asset name or icon name (legacy)
  final String? mediaAssetPath; // Path to local asset image/gif
  final String? mediaUrl; // remote url
  final String? instructions;
  final int? recommendedSeconds;
  final int? recommendedReps;

  WorkoutStep({
    String? id,
    required this.routineId,
    required this.title,
    required this.description,
    required this.type,
    this.durationSeconds,
    this.reps,
    this.iconName,
    this.mediaType = WorkoutMediaType.icon,
    this.mediaAsset, // Path to local asset (GIF/Image), e.g. "assets/workouts/squat.gif"
    this.mediaAssetPath,
    this.mediaUrl,
    this.instructions,
    this.recommendedSeconds,
    this.recommendedReps,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'routineId': routineId,
        'title': title,
        'description': description,
        'durationSeconds': durationSeconds,
        'reps': reps,
        'type': type.name,
        'iconName': iconName,
        'mediaType': mediaType.name,
        'mediaAsset': mediaAsset,
        'mediaAssetPath': mediaAssetPath,
        'mediaUrl': mediaUrl,
        'instructions': instructions,
        'recommendedSeconds': recommendedSeconds,
        'recommendedReps': recommendedReps,
      };

  factory WorkoutStep.fromJson(Map<String, dynamic> json) {
    return WorkoutStep(
      id: json['id'] as String?,
      routineId: json['routineId'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      durationSeconds: json['durationSeconds'] as int?,
      reps: json['reps'] as int?,
      type: WorkoutStepType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => WorkoutStepType.timed,
      ),
      iconName: json['iconName'] as String?,
      mediaType: json['mediaType'] != null
          ? WorkoutMediaType.values.firstWhere(
              (e) => e.name == json['mediaType'],
              orElse: () => WorkoutMediaType.icon,
            )
          : WorkoutMediaType.icon,
      mediaAsset: json['mediaAsset'] as String?,
      mediaAssetPath: json['mediaAssetPath'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      instructions: json['instructions'] as String?,
      recommendedSeconds: json['recommendedSeconds'] as int?,
      recommendedReps: json['recommendedReps'] as int?,
    );
  }
}

class WorkoutSessionLog {
  final String id;
  final String routineId;
  final DateTime startTime;
  final DateTime endTime;
  final int completedStepsCount;
  final int skippedStepsCount;
  final int totalMinutes;
  final WorkoutIntensity? intensity;

  WorkoutSessionLog({
    String? id,
    required this.routineId,
    required this.startTime,
    required this.endTime,
    required this.completedStepsCount,
    required this.skippedStepsCount,
    required this.totalMinutes,
    this.intensity,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'routineId': routineId,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'completedStepsCount': completedStepsCount,
        'skippedStepsCount': skippedStepsCount,
        'totalMinutes': totalMinutes,
        'intensity': intensity?.name,
      };

  factory WorkoutSessionLog.fromJson(Map<String, dynamic> json) => WorkoutSessionLog(
        id: json['id'] as String?,
        routineId: json['routineId'] as String,
        startTime: DateTime.parse(json['startTime'] as String),
        endTime: DateTime.parse(json['endTime'] as String),
        completedStepsCount: json['completedStepsCount'] as int? ?? 0,
        skippedStepsCount: json['skippedStepsCount'] as int? ?? 0,
        totalMinutes: json['totalMinutes'] as int? ?? 0,
        intensity: (json['intensity'] as String?) != null
            ? WorkoutIntensity.values.firstWhere(
                (e) => e.name == json['intensity'],
                orElse: () => WorkoutIntensity.medium,
              )
            : null,
      );
}
