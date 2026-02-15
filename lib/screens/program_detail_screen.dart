import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daily_reset/models/program_pack.dart';
import 'package:daily_reset/models/habit.dart';
import 'package:daily_reset/providers/habit_provider.dart';
import 'package:daily_reset/models/hydration_settings.dart';
import 'package:daily_reset/providers/hydration_provider.dart';
import 'package:daily_reset/providers/workout_provider.dart';
import 'package:daily_reset/models/workout_models.dart';
import 'package:go_router/go_router.dart';
import 'package:daily_reset/components/core/components.dart';

class ProgramDetailScreen extends StatefulWidget {
  final ProgramPack pack;

  const ProgramDetailScreen({super.key, required this.pack});

  @override
  State<ProgramDetailScreen> createState() => _ProgramDetailScreenState();
}

class _ProgramDetailScreenState extends State<ProgramDetailScreen> {
  late Map<String, bool> _localEnabled;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _bootstrapForPack();
  }

  void _toggleHabit(String habitId, bool value) {
    setState(() {
      _localEnabled[habitId] = value;
    });
  }

  Future<void> _bootstrapForPack() async {
    // Workout should always have its default habits available. We ensure the
    // defaults are present in storage, then sync local toggle state from the
    // provider.
    final habitProvider = context.read<HabitProvider>();
    final isWorkoutPack = widget.pack.id == ProgramPacksRepository.workoutId;

    if (isWorkoutPack) {
      // HabitProvider is assumed to expose the underlying service.
      final service = habitProvider.habitService;
      await service.ensureWorkoutDefaultsSeeded();
      await habitProvider.reloadHabits();
    }

    final habits = habitProvider.habitsForProgram(widget.pack.id);
    if (mounted) {
      setState(() {
        _localEnabled = {
          for (final h in habits) h.id: h.isEnabled,
        };
      });
    }
  }

  Future<void> _applyChanges() async {
    final habitProvider = context.read<HabitProvider>();
    final habits = habitProvider.habitsForProgram(widget.pack.id);
    final updated = <Habit>[];

    for (final habit in habits) {
      final enabled = _localEnabled[habit.id] ?? habit.isEnabled;
      if (enabled != habit.isEnabled) {
        updated.add(habit.copyWith(isEnabled: enabled));
      }
    }

    if (updated.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No changes to apply.')),
        );
      }
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      await habitProvider.updateHabitsBatch(updated);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Updated ${widget.pack.name} habits.')),
      );
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save changes. Please try again.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = context.watch<HabitProvider>();
    final hydrationProvider = context.watch<HydrationProvider>();
    final workoutProvider = context.watch<WorkoutProvider>();
    final habits = habitProvider.habitsForProgram(widget.pack.id);
    final isWorkoutPack = widget.pack.id == ProgramPacksRepository.workoutId;
    final isHydrationPack = widget.pack.id == ProgramPacksRepository.hydrationId;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pack.name),
        actions: [
          if (isHydrationPack)
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                _showHydrationSettingsSheet(context, hydrationProvider);
              },
            ),
        ],
      ),
       body: Column(
        children: [
           Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.pack.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.pack.description,
                     style: Theme.of(context).textTheme.bodyMedium,
                   ),
                   const SizedBox(height: 24),
                   if (isHydrationPack)
                      _HydrationMiniAppSection(hydrationProvider: hydrationProvider)
                   else if (isWorkoutPack)
                      _WorkoutRoutinesSection(workoutProvider: workoutProvider)
                   else if (habits.isEmpty)
                    Text(
                      'No habits are currently linked to this program.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                   else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: habits.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final habit = habits[index];
                        final enabled = _localEnabled[habit.id] ?? habit.isEnabled;

                        if (!isWorkoutPack) {
                          // Keep existing simple card UX for non-workout programs.
                          return DRCard(
                            padding: EdgeInsets.zero,
                            borderRadius: BorderRadius.circular(12),
                            child: SwitchListTile(
                              value: enabled,
                              onChanged: (value) => _toggleHabit(habit.id, value),
                              title: Text(habit.name),
                              subtitle: habit.description != null
                                  ? Text(habit.description!)
                                  : null,
                            ),
                          );
                        }

                        // Workout: richer card layout with metadata row and toggle.
                        final frequencyLabel = _frequencyLabel(habit);
                        final focusLabel = _focusLabel(habit);
                        return DRCard(
                          padding: EdgeInsets.zero,
                          borderRadius: BorderRadius.circular(16),
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        habit.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(fontWeight: FontWeight.w600),
                                      ),
                                      if (habit.description != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          habit.description!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: 0.75),
                                              ),
                                        ),
                                      ],
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.fitness_center,
                                            size: 16,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            frequencyLabel,
                                            style: Theme.of(context).textTheme.labelSmall,
                                          ),
                                          if (focusLabel != null) ...[
                                            const SizedBox(width: 10),
                                            const Text('•'),
                                            const SizedBox(width: 10),
                                            Text(
                                              focusLabel,
                                              style:
                                                  Theme.of(context).textTheme.labelSmall,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Switch(
                                  value: enabled,
                                  onChanged: (value) => _toggleHabit(habit.id, value),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _saving
                            ? null
                            : () {
                                final programId =
                                    Uri.encodeComponent(widget.pack.id);
                                context.push('/habits/add?programId=$programId');
                              },
                        icon: const Icon(Icons.add),
                        label: const Text('Add habit'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saving ? null : _applyChanges,
                        child: _saving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(
                                isWorkoutPack ? 'Apply workout plan' : 'Apply changes',
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _frequencyLabel(Habit habit) {
    if (habit.targetDaysPerWeek == 7) {
      return 'Daily';
    }
    return '${habit.targetDaysPerWeek}x/week';
  }

  String? _focusLabel(Habit habit) {
    final lower = habit.name.toLowerCase();
    if (lower.contains('strength') || lower.contains('full body')) {
      return 'Strength';
    }
    if (lower.contains('mobility') || lower.contains('stretch')) {
      return 'Mobility';
    }
    if (lower.contains('core') || lower.contains('posture')) {
      return 'Core';
    }
    if (lower.contains('cardio') || lower.contains('walk')) {
      return 'Cardio';
    }
    return null;
  }
}

class _HydrationMiniAppSection extends StatelessWidget {
  final HydrationProvider hydrationProvider;

  const _HydrationMiniAppSection({required this.hydrationProvider});

  @override
  Widget build(BuildContext context) {
    final settings = hydrationProvider.settings;
    final total = hydrationProvider.todayTotalMl;
    final goal = settings.dailyGoalMl;
    final progress = (goal <= 0) ? 0.0 : (total / goal).clamp(0.0, 1.0);

    String profileLabel;
    switch (settings.profile) {
      case HydrationProfile.rest:
        profileLabel = 'Rest / Office day';
        break;
      case HydrationProfile.workout:
        profileLabel = 'Workout day';
        break;
      case HydrationProfile.focus:
        profileLabel = 'Focus / Study day';
        break;
      case HydrationProfile.custom:
        profileLabel = 'Custom';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Goal",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$total ml / $goal ml',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profileLabel,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 80,
              width: 80,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 400),
                builder: (context, value, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: value,
                        strokeWidth: 8,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Text('${(value * 100).round()}%'),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Quick add',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: [
            for (final size in settings.glassSizeOptionsMl)
              ElevatedButton(
                onPressed: () {
                  hydrationProvider.logDrink(size, source: 'quick');
                },
                child: Text('+ $size ml'),
              ),
            OutlinedButton.icon(
              onPressed: () async {
                final amount = await _showCustomAmountDialog(context);
                if (amount != null && amount > 0) {
                  await hydrationProvider.logDrink(amount, source: 'custom');
                }
              },
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Custom amount'),
            ),
          ],
        ),
      ],
    );
  }

  Future<int?> _showCustomAmountDialog(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add custom amount'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount in ml',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = int.tryParse(controller.text.trim());
                Navigator.of(context).pop(value);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class _WorkoutRoutinesSection extends StatefulWidget {
  final WorkoutProvider workoutProvider;

  const _WorkoutRoutinesSection({required this.workoutProvider});

  @override
  State<_WorkoutRoutinesSection> createState() => _WorkoutRoutinesSectionState();
}

class _WorkoutRoutinesSectionState extends State<_WorkoutRoutinesSection> {
  WorkoutGoal? _goalFilter;
  WorkoutDifficulty? _difficultyFilter;

  @override
  Widget build(BuildContext context) {
    final routines = widget.workoutProvider.routines.where((r) {
      final matchesGoal = _goalFilter == null || r.goal == _goalFilter;
      final matchesDiff =
          _difficultyFilter == null || r.difficulty == _difficultyFilter;
      return matchesGoal && matchesDiff;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _FilterChip<WorkoutGoal>(
              label: 'Strength',
              value: WorkoutGoal.strength,
              groupValue: _goalFilter,
              onChanged: (v) => setState(() => _goalFilter = v),
            ),
            _FilterChip<WorkoutGoal>(
              label: 'Mobility',
              value: WorkoutGoal.mobility,
              groupValue: _goalFilter,
              onChanged: (v) => setState(() => _goalFilter = v),
            ),
            _FilterChip<WorkoutGoal>(
              label: 'Cardio',
              value: WorkoutGoal.cardio,
              groupValue: _goalFilter,
              onChanged: (v) => setState(() => _goalFilter = v),
            ),
            _FilterChip<WorkoutGoal>(
              label: 'Relax',
              value: WorkoutGoal.relax,
              groupValue: _goalFilter,
              onChanged: (v) => setState(() => _goalFilter = v),
            ),
            _FilterChip<WorkoutDifficulty>(
              label: 'Beginner',
              value: WorkoutDifficulty.beginner,
              groupValue: _difficultyFilter,
              onChanged: (v) => setState(() => _difficultyFilter = v),
            ),
            _FilterChip<WorkoutDifficulty>(
              label: 'Intermediate',
              value: WorkoutDifficulty.intermediate,
              groupValue: _difficultyFilter,
              onChanged: (v) => setState(() => _difficultyFilter = v),
            ),
            _FilterChip<WorkoutDifficulty>(
              label: 'Advanced',
              value: WorkoutDifficulty.advanced,
              groupValue: _difficultyFilter,
              onChanged: (v) => setState(() => _difficultyFilter = v),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: routines.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final routine = routines[index];
            return _WorkoutRoutineCard(routine: routine);
          },
        ),
      ],
    );
  }
}

class _FilterChip<T> extends StatelessWidget {
  final String label;
  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;

  const _FilterChip({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) =>
          onChanged(selected ? null : value),
    );
  }
}

class _WorkoutRoutineCard extends StatelessWidget {
  final WorkoutRoutine routine;

  const _WorkoutRoutineCard({required this.routine});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DRCard(
      padding: EdgeInsets.zero,
      elevation: 0,
      backgroundColor:
          theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(20),
      borderColor: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          context.push(
            '/workout/routines/${routine.id}',
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left illustration area
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color:
                      theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Icon(
                  _iconForGoal(routine.goal),
                  size: 32,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              // Right content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routine.name,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.timer_outlined,
                            size: 14,
                            color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          '${routine.estimatedMinutes} min',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer
                                .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _difficultyLabel(routine.difficulty),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      routine.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForGoal(WorkoutGoal g) {
    switch (g) {
      case WorkoutGoal.strength:
        return Icons.fitness_center;
      case WorkoutGoal.mobility:
        return Icons.accessibility_new;
      case WorkoutGoal.cardio:
        return Icons.directions_run;
      case WorkoutGoal.relax:
        return Icons.self_improvement;
    }
  }

  String _difficultyLabel(WorkoutDifficulty d) {
    switch (d) {
      case WorkoutDifficulty.beginner:
        return 'Beginner';
      case WorkoutDifficulty.intermediate:
        return 'Intermediate';
      case WorkoutDifficulty.advanced:
        return 'Advanced';
    }
  }
}

void _showHydrationSettingsSheet(
  BuildContext context,
  HydrationProvider hydrationProvider,
) {
  final settings = hydrationProvider.settings;
  final goalController =
      TextEditingController(text: settings.dailyGoalMl.toString());
  HydrationProfile selectedProfile = settings.profile;
  bool remindersEnabled = settings.remindersEnabled;
  int startMinutes = settings.reminderStartMinutes;
  int endMinutes = settings.reminderEndMinutes;
  int intervalMinutes = settings.reminderIntervalMinutes;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            Future<void> pickTime(bool isStart) async {
              final initialMinutes = isStart ? startMinutes : endMinutes;
              final initial = TimeOfDay(
                hour: initialMinutes ~/ 60,
                minute: initialMinutes % 60,
              );
              final picked = await showTimePicker(
                context: context,
                initialTime: initial,
              );
              if (picked != null) {
                setState(() {
                  final mins = picked.hour * 60 + picked.minute;
                  if (isStart) {
                    startMinutes = mins;
                  } else {
                    endMinutes = mins;
                  }
                });
              }
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Hydration Settings',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Profile',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _profileChip(
                      context,
                      label: 'Rest / Office',
                      value: HydrationProfile.rest,
                      groupValue: selectedProfile,
                      onChanged: (v) {
                        setState(() => selectedProfile = v);
                      },
                    ),
                    _profileChip(
                      context,
                      label: 'Workout',
                      value: HydrationProfile.workout,
                      groupValue: selectedProfile,
                      onChanged: (v) {
                        setState(() => selectedProfile = v);
                      },
                    ),
                    _profileChip(
                      context,
                      label: 'Focus / Study',
                      value: HydrationProfile.focus,
                      groupValue: selectedProfile,
                      onChanged: (v) {
                        setState(() => selectedProfile = v);
                      },
                    ),
                    _profileChip(
                      context,
                      label: 'Custom',
                      value: HydrationProfile.custom,
                      groupValue: selectedProfile,
                      onChanged: (v) {
                        setState(() => selectedProfile = v);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: goalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Daily goal (ml)',
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  value: remindersEnabled,
                  onChanged: (value) {
                    setState(() => remindersEnabled = value);
                  },
                  title: const Text('Hydration reminders'),
                ),
                if (remindersEnabled) ...[
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Start time'),
                          subtitle:
                              Text(_formatMinutes(context, startMinutes)),
                          onTap: () => pickTime(true),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('End time'),
                          subtitle: Text(_formatMinutes(context, endMinutes)),
                          onTap: () => pickTime(false),
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Interval (minutes)',
                    ),
                    onChanged: (value) {
                      final parsed = int.tryParse(value);
                      if (parsed != null && parsed > 0) {
                        intervalMinutes = parsed;
                      }
                    },
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final goal = int.tryParse(goalController.text.trim()) ??
                          settings.dailyGoalMl;
                      final updated = settings.copyWith(
                        dailyGoalMl: goal,
                        profile: selectedProfile,
                        remindersEnabled: remindersEnabled,
                        reminderStartMinutes: startMinutes,
                        reminderEndMinutes: endMinutes,
                        reminderIntervalMinutes: intervalMinutes,
                      );
                      await hydrationProvider.saveSettings(updated);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

Widget _profileChip(
  BuildContext context, {
  required String label,
  required HydrationProfile value,
  required HydrationProfile groupValue,
  required ValueChanged<HydrationProfile> onChanged,
}) {
  final selected = value == groupValue;
  return ChoiceChip(
    label: Text(label),
    selected: selected,
    onSelected: (_) => onChanged(value),
  );
}

String _formatMinutes(BuildContext context, int minutes) {
  final timeOfDay = TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
  return MaterialLocalizations.of(context).formatTimeOfDay(timeOfDay,
      alwaysUse24HourFormat:
          MediaQuery.maybeOf(context)?.alwaysUse24HourFormat ?? false);
}
