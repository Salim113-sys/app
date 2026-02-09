import 'package:uuid/uuid.dart';
import 'package:daily_reset/models/program_pack.dart';

enum HabitCategory {
  body,
  mind,
  focus,
  life;

  String get displayName {
    switch (this) {
      case HabitCategory.body:
        return 'Body';
      case HabitCategory.mind:
        return 'Mind';
      case HabitCategory.focus:
        return 'Focus';
      case HabitCategory.life:
        return 'Life';
    }
  }

  String get emoji {
    switch (this) {
      case HabitCategory.body:
        return '💪';
      case HabitCategory.mind:
        return '🧠';
      case HabitCategory.focus:
        return '🎯';
      case HabitCategory.life:
        return '🌟';
    }
  }
}

class Habit {
  static const Object _unset = Object();

  final String id;
  final String name;
  final String? description;
  final HabitCategory category;
  /// ID of the program/pack this habit belongs to.
  ///
  /// Uses [ProgramPacksRepository.generalId] as a safe default when not set.
  final String programId;
  final int targetDaysPerWeek;
  // Minutes after midnight for reminder time (e.g., 18:30 => 18*60+30). Null = no reminder.
  final int? reminderTimeMinutes;
  // Days of week for reminders using DateTime.weekday values: 1=Mon ... 7=Sun. Null => derive from targetDaysPerWeek (sensible defaults).
  final List<int>? reminderDays;
  final DateTime createdAt;
  final DateTime updatedAt;
  /// Whether this habit is currently active/visible in the Today view.
  ///
  /// Controlled by the user via Programs/pack configuration.
  final bool isEnabled;

  Habit({
    String? id,
    required this.name,
    this.description,
    required this.category,
    String? programId,
    required this.targetDaysPerWeek,
    this.reminderTimeMinutes,
    this.reminderDays,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEnabled,
  })  : id = id ?? const Uuid().v4(),
        programId = programId ?? ProgramPacksRepository.generalId,
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        isEnabled = isEnabled ?? true {
    if (name.trim().isEmpty) {
      throw ArgumentError('Habit name cannot be empty');
    }
    if (targetDaysPerWeek < 1 || targetDaysPerWeek > 7) {
      throw ArgumentError('Target days per week must be between 1 and 7');
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'category': category.name,
    'programId': programId,
    'targetDaysPerWeek': targetDaysPerWeek,
    'reminderTimeMinutes': reminderTimeMinutes,
    'reminderDays': reminderDays,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'isEnabled': isEnabled,
  };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String?,
    category: HabitCategory.values.firstWhere(
      (e) => e.name == json['category'],
      orElse: () => HabitCategory.life,
    ),
    programId: _deriveProgramId(json),
    targetDaysPerWeek: json['targetDaysPerWeek'] as int,
    reminderTimeMinutes: json['reminderTimeMinutes'] as int?,
    reminderDays: (json['reminderDays'] as List?)?.map((e) => e as int).toList(),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    isEnabled: json['isEnabled'] as bool? ?? true,
  );

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    HabitCategory? category,
    String? programId,
    int? targetDaysPerWeek,
    Object? reminderTimeMinutes = _unset,
    Object? reminderDays = _unset,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEnabled,
  }) => Habit(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    category: category ?? this.category,
    programId: programId ?? this.programId,
    targetDaysPerWeek: targetDaysPerWeek ?? this.targetDaysPerWeek,
    reminderTimeMinutes: identical(reminderTimeMinutes, _unset)
        ? this.reminderTimeMinutes
        : reminderTimeMinutes as int?,
    reminderDays: identical(reminderDays, _unset)
        ? this.reminderDays
        : reminderDays as List<int>?,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? DateTime.now(),
    isEnabled: isEnabled ?? this.isEnabled,
  );

  /// Derive a suitable program id for legacy habit JSON that did not contain a
  /// `programId` field.
  ///
  /// This keeps existing users’ data working without crashes while assigning
  /// them to a reasonable default pack.
  static String _deriveProgramId(Map<String, dynamic> json) {
    final raw = json['programId'];
    if (raw is String && raw.isNotEmpty) {
      return raw;
    }

    final name = (json['name'] as String? ?? '').toLowerCase();
    final categoryName = json['category'] as String?;

    // Basic heuristics using habit name first.
    if (name.contains('water') || name.contains('drink') || name.contains('hydration')) {
      return ProgramPacksRepository.hydrationId;
    }
    if (name.contains('walk') || name.contains('steps') || name.contains('stretch')) {
      return ProgramPacksRepository.movementId;
    }
    if (name.contains('deep work') || name.contains('focus') || name.contains('study')) {
      return ProgramPacksRepository.deepWorkId;
    }
    if (name.contains('workout') || name.contains('run') || name.contains('exercise')) {
      return ProgramPacksRepository.workoutId;
    }

    // Fallback heuristics using category, if present.
    switch (categoryName) {
      case 'body':
        return ProgramPacksRepository.movementId;
      case 'focus':
        return ProgramPacksRepository.deepWorkId;
      default:
        return ProgramPacksRepository.generalId;
    }
  }

  // ===== Utility helpers for days of week =====
  // Short names aligned to DateTime.weekday (1..7)
  static const List<String> _weekdayShort = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];

  // Provide sensible default days if none explicitly selected, matching NotificationService.
  static List<int> deriveReminderDays(int targetDaysPerWeek) {
    switch (targetDaysPerWeek.clamp(1, 7)) {
      case 1:
        return const [3]; // Wed
      case 2:
        return const [2, 5]; // Tue, Fri
      case 3:
        return const [1, 3, 5]; // Mon, Wed, Fri
      case 4:
        return const [1, 2, 4, 6]; // Mon, Tue, Thu, Sat
      case 5:
        return const [1, 2, 3, 4, 5]; // Weekdays
      case 6:
        return const [1, 2, 3, 4, 5, 6]; // Mon-Sat
      case 7:
      default:
        return const [1, 2, 3, 4, 5, 6, 7];
    }
  }

  // Returns selected days or derived defaults.
  List<int> get effectiveReminderDays {
    final days = (reminderDays == null || reminderDays!.isEmpty)
        ? deriveReminderDays(targetDaysPerWeek)
        : reminderDays!;
    // Normalize: unique and sorted asc
    final set = days.toSet().toList()..sort();
    return set;
  }

  // Human-friendly summary for UI, e.g. "Every day", "Weekdays", or "Mon, Wed, Fri".
  String get reminderDaysSummary {
    final days = effectiveReminderDays;
    if (days.length == 7) return 'Every day';
    if (days.length == 5 && days.toSet().containsAll(const {1, 2, 3, 4, 5})) {
      return 'Weekdays';
    }
    if (days.length == 2 && days.toSet().containsAll(const {6, 7})) {
      return 'Weekends';
    }
    final labels = days.map((d) => _weekdayShort[(d - 1).clamp(0, 6)]).toList();
    return labels.join(', ');
  }

  /// Returns a specific emoji for this habit based on its name,
  /// falling back to the category emoji if no specific match is found.
  String get displayEmoji {
    final lower = name.toLowerCase();

    // 1. Exact/Specific matches from requirements
    if (lower.contains('drink water')) return '💧';
    if (lower.contains('morning stretch')) return '🤸‍♂️';
    if (lower.contains('evening walk')) return '🚶‍♂️';
    if (lower.contains('full body strength')) return '🏋️‍♂️';
    if (lower.contains('morning mobility')) return '🧘‍♂️';
    if (lower.contains('core') && lower.contains('posture')) return '🧘‍♀️';

    // 2. Keyword heuristics
    // Hydration
    if (lower.contains('water') || lower.contains('drink') || lower.contains('hydrate')) {
      return '💧';
    }
    
    // Movement / Walking
    if (lower.contains('walk') || lower.contains('step') || lower.contains('movement')) {
      // Avoid duplicate 🚶‍♂️ if already used? Context says "choisis une variante".
      // Let's use 🚶‍♀️ for generic walking to differentiate from Evening Walk if needed,
      // or just keep consistent.
      return '🚶‍♀️'; 
    }

    // Workout / Strength
    if (lower.contains('workout') || lower.contains('exercise') || lower.contains('gym') || lower.contains('strength')) {
      return '🏋️‍♀️';
    }
    if (lower.contains('run') || lower.contains('jog')) {
      return '🏃‍♂️';
    }

    // Yoga / Mind
    if (lower.contains('yoga') || lower.contains('meditate') || lower.contains('breathe') || lower.contains('breath')) {
      return '🧘‍♀️';
    }
    
    // Focus / Work
    if (lower.contains('focus') || lower.contains('deep work') || lower.contains('study') || lower.contains('code')) {
      return '💻';
    }
    if (lower.contains('read') || lower.contains('book')) {
      return '📚';
    }
    if (lower.contains('journal') || lower.contains('writ') || lower.contains('gratitude')) {
      return '📔';
    }
    
    // Sleep / Rest
    if (lower.contains('sleep') || lower.contains('bed') || lower.contains('nap')) {
      return '🛌';
    }

    // 3. Fallback to category default
    return category.emoji;
  }
}
