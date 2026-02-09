import 'package:uuid/uuid.dart';

enum MoodLevel {
  veryLow,
  low,
  neutral,
  good,
  veryGood;

  String get displayName {
    switch (this) {
      case MoodLevel.veryLow:
        return 'Rough';
      case MoodLevel.low:
        return 'Not great';
      case MoodLevel.neutral:
        return 'Okay';
      case MoodLevel.good:
        return 'Good';
      case MoodLevel.veryGood:
        return 'Amazing';
    }
  }

  String get emoji {
    switch (this) {
      case MoodLevel.veryLow:
        return '😫'; // Exhausted / Rough
      case MoodLevel.low:
        return '😓'; // Stressed / Low
      case MoodLevel.neutral:
        return '😌'; // Calm / Okay
      case MoodLevel.good:
        return '✨'; // Good / Energized - showing sparkle/energy instead of just a face
      case MoodLevel.veryGood:
        return '🔥'; // Amazing / On fire
    }
  }

  int get value {
    switch (this) {
      case MoodLevel.veryLow:
        return 1;
      case MoodLevel.low:
        return 2;
      case MoodLevel.neutral:
        return 3;
      case MoodLevel.good:
        return 4;
      case MoodLevel.veryGood:
        return 5;
    }
  }
}

class DailyLog {
  final String id;
  final DateTime date;
  final MoodLevel? mood;
  final List<String> completedHabitIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  DailyLog({
    String? id,
    required DateTime date,
    this.mood,
    List<String>? completedHabitIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        date = DateTime(date.year, date.month, date.day),
        completedHabitIds = completedHabitIds ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'mood': mood?.name,
    'completedHabitIds': completedHabitIds,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory DailyLog.fromJson(Map<String, dynamic> json) => DailyLog(
    id: json['id'] as String,
    date: DateTime.parse(json['date'] as String),
    mood: json['mood'] != null
        ? MoodLevel.values.firstWhere(
            (e) => e.name == json['mood'],
            orElse: () => MoodLevel.neutral,
          )
        : null,
    completedHabitIds: (json['completedHabitIds'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  DailyLog copyWith({
    String? id,
    DateTime? date,
    MoodLevel? mood,
    List<String>? completedHabitIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DailyLog(
    id: id ?? this.id,
    date: date ?? this.date,
    mood: mood ?? this.mood,
    completedHabitIds: completedHabitIds ?? this.completedHabitIds,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? DateTime.now(),
  );
}
