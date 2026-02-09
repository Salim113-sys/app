import 'package:flutter/material.dart';

/// Profile presets for different hydration needs.
enum HydrationProfile {
  rest,
  workout,
  focus,
  custom,
}

class HydrationSettings {
  final int dailyGoalMl;
  final HydrationProfile profile;
  final List<int> glassSizeOptionsMl;
  final bool remindersEnabled;
  /// Minutes after midnight for start time.
  final int reminderStartMinutes;
  /// Minutes after midnight for end time.
  final int reminderEndMinutes;
  final int reminderIntervalMinutes;

  const HydrationSettings({
    this.dailyGoalMl = 2000,
    this.profile = HydrationProfile.rest,
    this.glassSizeOptionsMl = const [200, 250, 300],
    this.remindersEnabled = false,
    this.reminderStartMinutes = 9 * 60,
    this.reminderEndMinutes = 21 * 60,
    this.reminderIntervalMinutes = 60,
  });

  TimeOfDay get reminderStartTime =>
      TimeOfDay(hour: reminderStartMinutes ~/ 60, minute: reminderStartMinutes % 60);

  TimeOfDay get reminderEndTime =>
      TimeOfDay(hour: reminderEndMinutes ~/ 60, minute: reminderEndMinutes % 60);

  HydrationSettings copyWith({
    int? dailyGoalMl,
    HydrationProfile? profile,
    List<int>? glassSizeOptionsMl,
    bool? remindersEnabled,
    int? reminderStartMinutes,
    int? reminderEndMinutes,
    int? reminderIntervalMinutes,
  }) {
    return HydrationSettings(
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
      profile: profile ?? this.profile,
      glassSizeOptionsMl: glassSizeOptionsMl ?? this.glassSizeOptionsMl,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      reminderStartMinutes: reminderStartMinutes ?? this.reminderStartMinutes,
      reminderEndMinutes: reminderEndMinutes ?? this.reminderEndMinutes,
      reminderIntervalMinutes:
          reminderIntervalMinutes ?? this.reminderIntervalMinutes,
    );
  }

  Map<String, dynamic> toJson() => {
        'dailyGoalMl': dailyGoalMl,
        'profile': profile.name,
        'glassSizeOptionsMl': glassSizeOptionsMl,
        'remindersEnabled': remindersEnabled,
        'reminderStartMinutes': reminderStartMinutes,
        'reminderEndMinutes': reminderEndMinutes,
        'reminderIntervalMinutes': reminderIntervalMinutes,
      };

  factory HydrationSettings.fromJson(Map<String, dynamic> json) {
    HydrationProfile parseProfile(String? value) {
      if (value == null) return HydrationProfile.rest;
      for (final p in HydrationProfile.values) {
        if (p.name == value) return p;
      }
      return HydrationProfile.rest;
    }

    return HydrationSettings(
      dailyGoalMl: (json['dailyGoalMl'] as int?) ?? 2000,
      profile: parseProfile(json['profile'] as String?),
      glassSizeOptionsMl: ((json['glassSizeOptionsMl'] as List?)
              ?.whereType<int>()
              .toList()) ??
          const [200, 250, 300],
      remindersEnabled: (json['remindersEnabled'] as bool?) ?? false,
      reminderStartMinutes: (json['reminderStartMinutes'] as int?) ?? 9 * 60,
      reminderEndMinutes: (json['reminderEndMinutes'] as int?) ?? 21 * 60,
      reminderIntervalMinutes:
          (json['reminderIntervalMinutes'] as int?) ?? 60,
    );
  }
}
