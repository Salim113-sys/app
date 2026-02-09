import 'package:uuid/uuid.dart';
import 'package:daily_reset/models/deep_work_settings.dart';

class FocusSessionEntry {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;
  final DeepWorkProfile profile;
  final String? projectTag;

  FocusSessionEntry({
    String? id,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.profile,
    this.projectTag,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'durationMinutes': durationMinutes,
        'profile': profile.name,
        'projectTag': projectTag,
      };

  factory FocusSessionEntry.fromJson(Map<String, dynamic> json) {
    DeepWorkProfile parseProfile(String? value) {
      if (value == null) return DeepWorkProfile.deepWork;
      for (final p in DeepWorkProfile.values) {
        if (p.name == value) return p;
      }
      return DeepWorkProfile.deepWork;
    }

    return FocusSessionEntry(
      id: json['id'] as String?,
      startTime: DateTime.tryParse(json['startTime'] as String? ?? '') ??
          DateTime.now(),
      endTime: DateTime.tryParse(json['endTime'] as String? ?? '') ??
          DateTime.now(),
      durationMinutes: (json['durationMinutes'] as int?) ?? 0,
      profile: parseProfile(json['profile'] as String?),
      projectTag: json['projectTag'] as String?,
    );
  }
}
