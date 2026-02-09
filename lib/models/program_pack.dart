class ProgramPack {
  final String id;
  final String name;
  final String description;
  /// Semantic key for later UI/icon mapping, e.g. "water", "walk", "focus", "workout".
  final String iconKey;
  final bool isActive;

  const ProgramPack({
    required this.id,
    required this.name,
    required this.description,
    required this.iconKey,
    this.isActive = true,
  });

  ProgramPack copyWith({
    String? id,
    String? name,
    String? description,
    String? iconKey,
    bool? isActive,
  }) {
    return ProgramPack(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconKey: iconKey ?? this.iconKey,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'iconKey': iconKey,
        'isActive': isActive,
      };

  factory ProgramPack.fromJson(Map<String, dynamic> json) {
    return ProgramPack(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      iconKey: json['iconKey'] as String? ?? 'general',
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}

/// Seed program packs for the core Daily Reset experience.
///
/// These are kept in one place so future UI can easily list them.
class ProgramPacksRepository {
  static const String hydrationId = 'hydration';
  static const String movementId = 'movement';
  static const String deepWorkId = 'deep_work';
  static const String workoutId = 'workout';
  static const String generalId = 'general';

  static const List<ProgramPack> defaultPacks = [
    ProgramPack(
      id: hydrationId,
      name: 'Hydration',
      description: 'Stay energized and clear-headed with simple hydration habits.',
      iconKey: 'water',
    ),
    ProgramPack(
      id: movementId,
      name: 'Movement',
      description: 'Light movement to keep your body active throughout the day.',
      iconKey: 'walk',
    ),
    ProgramPack(
      id: deepWorkId,
      name: 'Deep Work',
      description: 'Focused work sessions to move your most important projects forward.',
      iconKey: 'focus',
    ),
    ProgramPack(
      id: workoutId,
      name: 'Workout',
      description: 'Intentional exercise sessions to build strength and resilience.',
      iconKey: 'workout',
    ),
    ProgramPack(
      id: generalId,
      name: 'General',
      description: 'Flexible habits that don’t belong to a specific program yet.',
      iconKey: 'general',
    ),
  ];
}
