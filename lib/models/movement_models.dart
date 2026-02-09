import 'package:uuid/uuid.dart';

enum MovementRoutineType { stretch, walk, yoga, posture, breathing }

class MovementRoutine {
  final String id;
  final String name;
  final String description;
  final MovementRoutineType type;
  final int estimatedMinutes;
  final List<String> tags;

  const MovementRoutine({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.estimatedMinutes,
    this.tags = const [],
  });
}

class MovementSessionLog {
  final String id;
  final String routineId;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;
  final MovementRoutineType? type;
  final String? note;

  MovementSessionLog({
    String? id,
    required this.routineId,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    this.type,
    this.note,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'routineId': routineId,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'durationMinutes': durationMinutes,
        'type': type?.name,
        'note': note,
      };

  factory MovementSessionLog.fromJson(Map<String, dynamic> json) {
    MovementRoutineType? parseType(String? value) {
      if (value == null) return null;
      for (final t in MovementRoutineType.values) {
        if (t.name == value) return t;
      }
      return null;
    }

    return MovementSessionLog(
      id: json['id'] as String?,
      routineId: json['routineId'] as String,
      startTime:
          DateTime.tryParse(json['startTime'] as String? ?? '') ?? DateTime.now(),
      endTime:
          DateTime.tryParse(json['endTime'] as String? ?? '') ?? DateTime.now(),
      durationMinutes: (json['durationMinutes'] as int?) ?? 0,
      type: parseType(json['type'] as String?),
      note: json['note'] as String?,
    );
  }
}
