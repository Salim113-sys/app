import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daily_reset/theme.dart';
import 'package:daily_reset/components/core/components.dart';
import 'package:daily_reset/models/habit.dart';
import 'package:daily_reset/models/program_pack.dart';
import 'package:daily_reset/providers/habit_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:daily_reset/widgets/weekday_selector.dart';

class HabitFormScreen extends StatefulWidget {
  final String? habitId;
  final String? programId;

  const HabitFormScreen({super.key, this.habitId, this.programId});

  @override
  State<HabitFormScreen> createState() => _HabitFormScreenState();
}

class _HabitFormScreenState extends State<HabitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  HabitCategory _selectedCategory = HabitCategory.life;
  int _targetDaysPerWeek = 7;
  bool _isLoading = false;
  int? _reminderTimeMinutes;
  List<int> _selectedDays = const [1, 2, 3, 4, 5, 6, 7];
  // Program/pack this habit belongs to. Defaults to General when not provided.
  String _selectedProgramId = ProgramPacksRepository.generalId;

  bool get isEditing => widget.habitId != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadHabit();
      });
    }
    // For new habits, default days follow targetDaysPerWeek.
    if (!isEditing) {
      final preselectedProgramId = widget.programId;
      if (preselectedProgramId != null &&
          ProgramPacksRepository.defaultPacks
              .any((pack) => pack.id == preselectedProgramId)) {
        _selectedProgramId = preselectedProgramId;
      }
      _selectedDays = Habit.deriveReminderDays(_targetDaysPerWeek);
    }
  }

  void _loadHabit() {
    final habit = context.read<HabitProvider>().getHabitById(widget.habitId!);
    if (habit != null) {
      setState(() {
        _nameController.text = habit.name;
        _descriptionController.text = habit.description ?? '';
        _selectedCategory = habit.category;
        _selectedProgramId = habit.programId;
        _reminderTimeMinutes = habit.reminderTimeMinutes;
        _selectedDays = habit.reminderDays == null || habit.reminderDays!.isEmpty
            ? Habit.deriveReminderDays(habit.targetDaysPerWeek)
            : (List<int>.from(habit.reminderDays!)..sort());
        // Ensure targetDaysPerWeek always equals the number of active days
        _targetDaysPerWeek = _selectedDays.length.clamp(1, 7);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DRAppBarWithBack(title: isEditing ? 'Edit Habit' : 'Add Habit'),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Habit Name',
                style: context.textStyles.titleMedium?.semiBold,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'e.g., Morning meditation',
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a habit name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Description (Optional)',
                style: context.textStyles.titleMedium?.semiBold,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Add more details...',
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Category',
                style: context.textStyles.titleMedium?.semiBold,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: HabitCategory.values.map((category) {
                  final isSelected = _selectedCategory == category;
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(category.emoji),
                        const SizedBox(width: AppSpacing.xs),
                        Text(category.displayName),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Program',
                style: context.textStyles.titleMedium?.semiBold,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: ProgramPacksRepository.defaultPacks.map((pack) {
                  final isSelected = _selectedProgramId == pack.id;
                  return ChoiceChip(
                    label: Text(pack.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (!selected) return;
                      setState(() {
                        _selectedProgramId = pack.id;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Target Days Per Week',
                style: context.textStyles.titleMedium?.semiBold,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$_targetDaysPerWeek ${_targetDaysPerWeek == 1 ? 'day' : 'days'} per week',
                    style: context.textStyles.bodyLarge,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: _selectedDays.length > 1
                              ? () {
                                  setState(() {
                                    // Remove the last selected day to reduce the count by one
                                    final next = List<int>.from(_selectedDays)..sort();
                                    if (next.isNotEmpty) {
                                      next.removeLast();
                                    }
                                    _selectedDays = next;
                                    _targetDaysPerWeek = _selectedDays.length.clamp(1, 7);
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.remove),
                        ),
                        Text(
                          '$_targetDaysPerWeek',
                          style: context.textStyles.titleLarge?.bold,
                        ),
                        IconButton(
                          onPressed: _selectedDays.length < 7
                              ? () {
                                  setState(() {
                                    // Add the next missing weekday (1..7) to increase the count by one
                                    final next = List<int>.from(_selectedDays)..sort();
                                    for (var day = 1; day <= 7; day++) {
                                      if (!next.contains(day)) {
                                        next.add(day);
                                        break;
                                      }
                                    }
                                    next.sort();
                                    _selectedDays = next;
                                    _targetDaysPerWeek = _selectedDays.length.clamp(1, 7);
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Active days',
                style: context.textStyles.titleMedium?.semiBold,
              ),
              const SizedBox(height: AppSpacing.sm),
              WeekdaySelector(
                selectedDays: _selectedDays,
                onChanged: (days) {
                  setState(() {
        final normalized = days.toSet().toList()..sort();
        _selectedDays = normalized.isEmpty
            ? Habit.deriveReminderDays(1)
            : normalized;
        _targetDaysPerWeek = _selectedDays.length.clamp(1, 7);
                  });
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Reminder time',
                style: context.textStyles.titleMedium?.semiBold,
              ),
              const SizedBox(height: AppSpacing.sm),
              Card(
                child: ListTile(
                  leading: Icon(Icons.access_time, color: Theme.of(context).colorScheme.primary),
                  title: Text(
                    _reminderTimeMinutes == null
                        ? 'No reminder set'
                        : 'Reminder: ${_formatReminderTime(context, _reminderTimeMinutes!)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_reminderTimeMinutes != null)
                        IconButton(
                          tooltip: 'Clear',
                          onPressed: () => setState(() => _reminderTimeMinutes = null),
                          icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.error),
                        ),
                      Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ],
                  ),
                  onTap: _pickReminderTime,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveHabit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isEditing ? 'Update habit' : 'Save habit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveHabit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Ensure targetDaysPerWeek is always in sync with the selected days
      final normalizedDays = _normalizedSelectedDaysOrDefault();
      final reminderDaysToSave =
          _reminderTimeMinutes == null ? null : normalizedDays;
      final effectiveDaysCount = normalizedDays?.length ?? _targetDaysPerWeek;
      _targetDaysPerWeek = effectiveDaysCount.clamp(1, 7);
      final habitProvider = context.read<HabitProvider>();
      
      if (isEditing) {
        final existingHabit = habitProvider.getHabitById(widget.habitId!);
        if (existingHabit != null) {
          final updatedHabit = existingHabit.copyWith(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            category: _selectedCategory,
            programId: _selectedProgramId,
            targetDaysPerWeek: _targetDaysPerWeek,
            reminderTimeMinutes: _reminderTimeMinutes,
            reminderDays: reminderDaysToSave,
          );
          await habitProvider.updateHabit(updatedHabit);
        }
      } else {
        final newHabit = Habit(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          category: _selectedCategory,
          programId: _selectedProgramId,
          targetDaysPerWeek: _targetDaysPerWeek,
          reminderTimeMinutes: _reminderTimeMinutes,
          reminderDays: reminderDaysToSave,
        );
        await habitProvider.addHabit(newHabit);
      }

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? 'Habit updated!' : 'Habit added!'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatReminderTime(BuildContext context, int minutes) {
    final timeOfDay = TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
    return MaterialLocalizations.of(context).formatTimeOfDay(timeOfDay,
        alwaysUse24HourFormat: MediaQuery.maybeOf(context)?.alwaysUse24HourFormat ?? false);
  }

  Future<void> _pickReminderTime() async {
    final now = TimeOfDay.now();
    final initial = _reminderTimeMinutes == null
        ? now
        : TimeOfDay(hour: _reminderTimeMinutes! ~/ 60, minute: _reminderTimeMinutes! % 60);
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      setState(() => _reminderTimeMinutes = picked.hour * 60 + picked.minute);
    }
  }

  List<int>? _normalizedSelectedDaysOrDefault() {
    // Normalize currently selected days; ensure at least one day.
    final days = (_selectedDays.toSet().toList()..sort());
    if (days.isEmpty) {
      return Habit.deriveReminderDays(1);
    }
    return days;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
