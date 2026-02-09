import 'package:flutter/material.dart';

enum DeepWorkProfile {
  deepWork,
  study,
  creative,
  lightAdmin,
  custom,
}

class DeepWorkSettings {
  final int dailyFocusGoalMinutes;
  final int defaultSessionMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int sessionsBeforeLongBreak;
  final bool soundEnabled;
  final DeepWorkProfile focusProfile;
  final bool remindersEnabled;
  final int reminderStartMinutes;
  final int reminderEndMinutes;
  final int reminderIntervalMinutes;

  const DeepWorkSettings({
    this.dailyFocusGoalMinutes = 120,
    this.defaultSessionMinutes = 25,
    this.shortBreakMinutes = 5,
    this.longBreakMinutes = 15,
    this.sessionsBeforeLongBreak = 4,
    this.soundEnabled = true,
    this.focusProfile = DeepWorkProfile.deepWork,
    this.remindersEnabled = false,
    this.reminderStartMinutes = 9 * 60,
    this.reminderEndMinutes = 21 * 60,
    this.reminderIntervalMinutes = 90,
  });

  TimeOfDay get reminderStartTime =>
      TimeOfDay(hour: reminderStartMinutes ~/ 60, minute: reminderStartMinutes % 60);

  TimeOfDay get reminderEndTime =>
      TimeOfDay(hour: reminderEndMinutes ~/ 60, minute: reminderEndMinutes % 60);

  DeepWorkSettings copyWith({
    int? dailyFocusGoalMinutes,
    int? defaultSessionMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? sessionsBeforeLongBreak,
    bool? soundEnabled,
    DeepWorkProfile? focusProfile,
    bool? remindersEnabled,
    int? reminderStartMinutes,
    int? reminderEndMinutes,
    int? reminderIntervalMinutes,
  }) {
    return DeepWorkSettings(
      dailyFocusGoalMinutes:
          dailyFocusGoalMinutes ?? this.dailyFocusGoalMinutes,
      defaultSessionMinutes:
          defaultSessionMinutes ?? this.defaultSessionMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      sessionsBeforeLongBreak:
          sessionsBeforeLongBreak ?? this.sessionsBeforeLongBreak,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      focusProfile: focusProfile ?? this.focusProfile,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      reminderStartMinutes:
          reminderStartMinutes ?? this.reminderStartMinutes,
      reminderEndMinutes: reminderEndMinutes ?? this.reminderEndMinutes,
      reminderIntervalMinutes:
          reminderIntervalMinutes ?? this.reminderIntervalMinutes,
    );
  }

  Map<String, dynamic> toJson() => {
        'dailyFocusGoalMinutes': dailyFocusGoalMinutes,
        'defaultSessionMinutes': defaultSessionMinutes,
        'shortBreakMinutes': shortBreakMinutes,
        'longBreakMinutes': longBreakMinutes,
        'sessionsBeforeLongBreak': sessionsBeforeLongBreak,
        'soundEnabled': soundEnabled,
        'focusProfile': focusProfile.name,
        'remindersEnabled': remindersEnabled,
        'reminderStartMinutes': reminderStartMinutes,
        'reminderEndMinutes': reminderEndMinutes,
        'reminderIntervalMinutes': reminderIntervalMinutes,
      };

  factory DeepWorkSettings.fromJson(Map<String, dynamic> json) {
    DeepWorkProfile parseProfile(String? value) {
      if (value == null) return DeepWorkProfile.deepWork;
      for (final p in DeepWorkProfile.values) {
        if (p.name == value) return p;
      }
      return DeepWorkProfile.deepWork;
    }

    return DeepWorkSettings(
      dailyFocusGoalMinutes:
          (json['dailyFocusGoalMinutes'] as int?) ?? 120,
      defaultSessionMinutes:
          (json['defaultSessionMinutes'] as int?) ?? 25,
      shortBreakMinutes: (json['shortBreakMinutes'] as int?) ?? 5,
      longBreakMinutes: (json['longBreakMinutes'] as int?) ?? 15,
      sessionsBeforeLongBreak:
          (json['sessionsBeforeLongBreak'] as int?) ?? 4,
      soundEnabled: (json['soundEnabled'] as bool?) ?? true,
      focusProfile: parseProfile(json['focusProfile'] as String?),
      remindersEnabled: (json['remindersEnabled'] as bool?) ?? false,
      reminderStartMinutes:
          (json['reminderStartMinutes'] as int?) ?? 9 * 60,
      reminderEndMinutes:
          (json['reminderEndMinutes'] as int?) ?? 21 * 60,
      reminderIntervalMinutes:
          (json['reminderIntervalMinutes'] as int?) ?? 90,
    );
  }
}
