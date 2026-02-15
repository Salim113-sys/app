import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:daily_reset/theme.dart';
import 'package:daily_reset/components/core/components.dart';
import 'package:daily_reset/providers/habit_provider.dart';
import 'package:daily_reset/providers/daily_log_provider.dart';
import 'package:daily_reset/providers/streak_provider.dart';
import 'package:daily_reset/widgets/mood_selector.dart';
import 'package:daily_reset/widgets/habit_card.dart';
import 'package:daily_reset/widgets/today_overview_card.dart';
import 'package:daily_reset/providers/hydration_provider.dart';
import 'package:daily_reset/widgets/empty_state.dart';
import 'package:go_router/go_router.dart';
import 'package:daily_reset/widgets/hydration_controls_card.dart';
import 'package:daily_reset/models/program_pack.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _getMotivationalQuote() {
    final quotes = [
      'Small steps every day lead to big changes.',
      'You\'re doing great! Keep going.',
      'Progress, not perfection.',
      'Every day is a fresh start.',
      'Believe in your ability to figure things out.',
      'The secret of getting ahead is getting started.',
    ];
    return quotes[DateTime.now().day % quotes.length];
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = context.watch<HabitProvider>();
    final logProvider = context.watch<DailyLogProvider>();
    final hydrationProvider = context.watch<HydrationProvider>();
    final packs = ProgramPacksRepository.defaultPacks;

    return Scaffold(
      appBar: const DRAppBar(title: 'Today\'s Reset'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: context.textStyles.displaySmall?.semiBold.withColor(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                DateFormat('EEEE, MMMM d').format(DateTime.now()),
                style: context.textStyles.bodyLarge?.withColor(
                  Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Builder(
                builder: (context) {
                  // Calculate stats for Overview
                  final activeHabits = habitProvider.habits.where((h) => h.isEnabled).toList();
                  final completedCount = activeHabits.where((h) => logProvider.isHabitCompleted(h.id)).length;
                  final totalCount = activeHabits.length;
                  final streakProvider = context.watch<StreakProvider>();
                  
                  return TodayOverviewCard(
                    completedHabits: completedCount,
                    totalHabits: totalCount,
                    currentMood: logProvider.todayLog?.mood,
                    waterCurrentMl: hydrationProvider.todayTotalMl,
                    waterGoalMl: hydrationProvider.settings.dailyGoalMl,
                    streakDays: streakProvider.currentStreak,
                    badge: streakProvider.currentBadge,
                  );
                }
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'How are you feeling today?',
                style: context.textStyles.titleLarge?.semiBold,
              ),
              const SizedBox(height: AppSpacing.md),
              MoodSelector(
                selectedMood: logProvider.todayLog?.mood,
                onMoodSelected: (mood) => logProvider.setMood(mood),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Habits',
                    style: context.textStyles.titleLarge?.semiBold,
                  ),
                  TextButton.icon(
                    onPressed: () => context.push('/habits'),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Manage'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              if (habitProvider.isLoading)
                const Center(
                  child: Padding(
                    padding: AppSpacing.paddingXl,
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (habitProvider.habits.isEmpty)
                const EmptyState(
                  icon: Icons.self_improvement,
                  title: 'No habits yet',
                  description: 'Add your first habit to get started!',
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final pack in packs)
                      Builder(builder: (context) {
                        final packHabits = habitProvider.habits
                            .where((h) => h.programId == pack.id && h.isEnabled)
                            .toList();
                        if (packHabits.isEmpty) return const SizedBox.shrink();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                              child: Text(
                                pack.name,
                                style: context.textStyles.titleMedium?.semiBold,
                              ),
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: packHabits.length,
                              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                              itemBuilder: (context, index) {
                                final habit = packHabits[index];
                                final isCompleted = logProvider.isHabitCompleted(habit.id);
                                return HabitCard(
                                  habit: habit,
                                  isCompleted: isCompleted,
                                  onToggle: () => logProvider.toggleHabitCompletion(habit.id),
                                );
                              },
                            ),
                            const SizedBox(height: AppSpacing.md),
                          ],
                        );
                      }),
                  ],
                ),
              if (habitProvider.habits.isNotEmpty)
                  const SizedBox(height: AppSpacing.xl),
              // Hydration Control Section
              if (hydrationProvider.isInitialized)
                 const HydrationControlsCard(),
              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: AppSpacing.paddingLg,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, size: 24),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        _getMotivationalQuote(),
                        style: context.textStyles.bodyMedium?.medium.withColor(
                          Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
