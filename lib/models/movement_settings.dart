import 'package:flutter/material.dart';

enum MovementProfile {
  deskWorker,
  standing,
  recovery,
  custom,
}

class MovementSettings {
  final int dailyMovementGoalMinutes;
  final bool remindersEnabled;
  final int reminderStartMinutes;
  final int reminderEndMinutes;
  final int reminderIntervalMinutes;
  final MovementProfile movementProfile;

  const MovementSettings({
    this.dailyMovementGoalMinutes = 30,
    this.remindersEnabled = true,
    this.reminderStartMinutes = 9 * 60,
    this.reminderEndMinutes = 21 * 60,
    this.reminderIntervalMinutes = 60,
    this.movementProfile = MovementProfile.deskWorker,
  });

  TimeOfDay get reminderStartTime => TimeOfDay(
        hour: reminderStartMinutes ~/ 60,
        minute: reminderStartMinutes % 60,
      );

  TimeOfDay get reminderEndTime => TimeOfDay(
        hour: reminderEndMinutes ~/ 60,
        minute: reminderEndMinutes % 60,
      );

  MovementSettings copyWith({
    int? dailyMovementGoalMinutes,
    bool? remindersEnabled,
    int? reminderStartMinutes,
    int? reminderEndMinutes,
    int? reminderIntervalMinutes,
    MovementProfile? movementProfile,
  }) {
    return MovementSettings(
      dailyMovementGoalMinutes:
          dailyMovementGoalMinutes ?? this.dailyMovementGoalMinutes,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      reminderStartMinutes: reminderStartMinutes ?? this.reminderStartMinutes,
      reminderEndMinutes: reminderEndMinutes ?? this.reminderEndMinutes,
      reminderIntervalMinutes:
          reminderIntervalMinutes ?? this.reminderIntervalMinutes,
      movementProfile: movementProfile ?? this.movementProfile,
    );
  }

  Map<String, dynamic> toJson() => {
        'dailyMovementGoalMinutes': dailyMovementGoalMinutes,
        'remindersEnabled': remindersEnabled,
        'reminderStartMinutes': reminderStartMinutes,
        'reminderEndMinutes': reminderEndMinutes,
        'reminderIntervalMinutes': reminderIntervalMinutes,
        'movementProfile': movementProfile.name,
      };

  factory MovementSettings.fromJson(Map<String, dynamic> json) {
    MovementProfile parseProfile(String? value) {
      if (value == null) return MovementProfile.deskWorker;
      for (final p in MovementProfile.values) {
        if (p.name == value) return p;
      }
      return MovementProfile.deskWorker;
    }

    return MovementSettings(
      dailyMovementGoalMinutes:
          (json['dailyMovementGoalMinutes'] as int?) ?? 30,
      remindersEnabled: (json['remindersEnabled'] as bool?) ?? true,
      reminderStartMinutes: (json['reminderStartMinutes'] as int?) ?? 9 * 60,
      reminderEndMinutes: (json['reminderEndMinutes'] as int?) ?? 21 * 60,
      reminderIntervalMinutes:
          (json['reminderIntervalMinutes'] as int?) ?? 60,
      movementProfile: parseProfile(json['movementProfile'] as String?),
    );
  }
}
