import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daily_reset/theme.dart';
import 'package:daily_reset/components/core/components.dart';
import 'package:daily_reset/providers/habit_provider.dart';
import 'package:daily_reset/widgets/empty_state.dart';
import 'package:go_router/go_router.dart';

class HabitsListScreen extends StatelessWidget {
  const HabitsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = context.watch<HabitProvider>();

    return Scaffold(
      appBar: DRAppBarWithBack(title: 'Manage Habits'),
      body: habitProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : habitProvider.habits.isEmpty
              ? EmptyState(
                  icon: Icons.self_improvement,
                  title: 'No habits yet',
                  description: 'Start building better habits today!',
                  action: DRButtonPrimary(
                    label: 'Add Your First Habit',
                    onPressed: () => context.push('/habits/add'),
                    icon: Icons.add,
                  ),
                )
              : ListView.separated(
                  padding: AppSpacing.paddingLg,
                  itemCount: habitProvider.habits.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final habit = habitProvider.habits[index];
                    return DRCard(
                      padding: EdgeInsets.zero,
                      child: DRListTile(
                        padding: AppSpacing.paddingMd,
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          child: Text(
                            habit.category.emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        titleWidget: Row(
                          children: [
                            Expanded(
                              child: Text(
                                habit.name,
                                style: context.textStyles.bodyLarge?.medium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (habit.reminderTimeMinutes != null) ...[
                              const SizedBox(width: AppSpacing.sm),
                              Icon(Icons.access_time,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.primary),
                              const SizedBox(width: 4),
                              Text(
                                _formatReminderTime(context, habit.reminderTimeMinutes!),
                                style: context.textStyles.labelSmall?.withColor(
                                  Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                        subtitleWidget: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                               habit.reminderDaysSummary,
                               style: context.textStyles.labelSmall?.withColor(
                                 Theme.of(context).colorScheme.onSurfaceVariant,
                               ),
                             ),
                             const SizedBox(height: AppSpacing.xs),
                            if (habit.description != null &&
                                habit.description!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: AppSpacing.xs),
                                child: Text(
                                  habit.description!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            Wrap(
                              spacing: AppSpacing.sm,
                              children: [
                                Chip(
                                  label: Text(
                                    habit.category.displayName,
                                    style: context.textStyles.labelSmall,
                                  ),
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                ),
                                Chip(
                                  label: Text(
                                    '${habit.targetDaysPerWeek}x/week',
                                    style: context.textStyles.labelSmall,
                                  ),
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: const Row(
                                children: [
                                  Icon(Icons.edit_outlined, size: 20),
                                  SizedBox(width: AppSpacing.sm),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline, size: 20, color: Theme.of(context).colorScheme.error),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              context.push('/habits/edit/${habit.id}');
                            } else if (value == 'delete') {
                              _showDeleteDialog(context, habit.id, habit.name);
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/habits/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Habit'),
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, String habitId, String habitName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Habit'),
        content: Text('Are you sure you want to delete "$habitName"? This action cannot be undone.'),
        actions: [
          DRButtonGhost(
            label: 'Cancel',
            size: DRButtonSize.small,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          DRButtonDestructive(
            label: 'Delete',
            size: DRButtonSize.small,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<HabitProvider>().deleteHabit(habitId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Habit deleted')),
        );
      }
    }
  }
}

String _formatReminderTime(BuildContext context, int minutes) {
  final timeOfDay = TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
  return MaterialLocalizations.of(context).formatTimeOfDay(timeOfDay,
      alwaysUse24HourFormat: MediaQuery.maybeOf(context)?.alwaysUse24HourFormat ?? false);
}
