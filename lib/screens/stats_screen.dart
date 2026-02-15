import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daily_reset/theme.dart';
import 'package:daily_reset/components/core/components.dart';
import 'package:daily_reset/providers/habit_provider.dart';
import 'package:daily_reset/providers/daily_log_provider.dart';
import 'package:daily_reset/models/program_pack.dart';
import 'package:daily_reset/providers/hydration_provider.dart';
import 'package:daily_reset/providers/workout_provider.dart';
import 'package:daily_reset/widgets/charts/mood_spline_chart.dart';
import 'package:daily_reset/widgets/charts/habit_breakdown_chart.dart';
import 'package:daily_reset/widgets/empty_state.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = context.watch<HabitProvider>();
    final logProvider = context.watch<DailyLogProvider>();
    final hydrationProvider = context.watch<HydrationProvider>();
    final workoutProvider = context.watch<WorkoutProvider>();

    return Scaffold(
      appBar: const DRAppBar(title: 'Your Progress'),
      body: habitProvider.habits.isEmpty
          ? const EmptyState(
              icon: Icons.show_chart,
              title: 'No stats yet',
              description: 'Add habits and track your progress to see stats!',
            )
          : ListView(
              padding: AppSpacing.paddingLg,
              children: [
                _SectionTitle('Mood Trend', icon: Icons.mood),
                const SizedBox(height: AppSpacing.sm),
                // Mood Chart is already styled, but let's wrap it nicely
                MoodSplineChart(moods: logProvider.getLast7DaysMoods()),
                
                const SizedBox(height: AppSpacing.xl),
                _SectionTitle('Habits', icon: Icons.check_circle_outline),
                const SizedBox(height: AppSpacing.sm),
                HabitBreakdownChart(
                  habits: habitProvider.habits.where((h) => h.isEnabled).toList(),
                  recentLogs: logProvider.recentLogs,
                ),
                
                if (hydrationProvider.isInitialized) ...[
                  const SizedBox(height: AppSpacing.xl),
                  _SectionTitle('Hydration', icon: Icons.water_drop_outlined),
                  const SizedBox(height: AppSpacing.sm),
                  _HydrationStatsCard(hydrationProvider: hydrationProvider),
                ],

                const SizedBox(height: AppSpacing.xl),
                _SectionTitle('Workouts', icon: Icons.fitness_center),
                const SizedBox(height: AppSpacing.sm),
                _WorkoutStatsCard(workoutProvider: workoutProvider),
                
                const SizedBox(height: AppSpacing.xl),
                _SectionTitle('Programs', icon: Icons.layers_outlined),
                const SizedBox(height: AppSpacing.sm),
                _ProgramStatsSection(
                   habitProvider: habitProvider,
                   logProvider: logProvider,
                ),
                
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle(this.title, {required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: context.textStyles.titleMedium?.bold.withColor(
            Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

/// A standard card for dashboard items to ensure consistency
class _DashboardCard extends StatelessWidget {
  final Widget child;

  const _DashboardCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface, // Clean surface
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
          )
        ],
      ),
      child: child,
    );
  }
}

class _HydrationStatsCard extends StatelessWidget {
  final HydrationProvider hydrationProvider;
  const _HydrationStatsCard({required this.hydrationProvider});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: hydrationProvider.getLast7DayTotals(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
        
        final data = snapshot.data as List<Map<String, dynamic>>;
        final settings = hydrationProvider.settings;
        int goalHits = 0;
        
        for (final day in data) {
           if ((day['totalMl'] as int) >= settings.dailyGoalMl) goalHits++;
        }

        return _DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final day in data)
                      Expanded(
                        child: _StatsBar(
                           label: _weekday(day['date'] as DateTime),
                           value: (day['totalMl'] as int).toDouble(),
                           goal: settings.dailyGoalMl.toDouble(),
                           color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Goal hit $goalHits/7 days',
                 style: context.textStyles.bodySmall?.withColor(Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        );
      },
    );
  }
  
  String _weekday(DateTime dt) => ['M','T','W','T','F','S','S'][dt.weekday - 1];
}

class _WorkoutStatsCard extends StatelessWidget {
  final WorkoutProvider workoutProvider;
  const _WorkoutStatsCard({required this.workoutProvider});

  @override
  Widget build(BuildContext context) {
    final summary = workoutProvider.getLast7DaysSummary();
    final (totalMins, activeDays) = workoutProvider.getLast7DaysTotals();
    
    if (summary.isEmpty && totalMins == 0) return const _DashboardCard(child: Text("No workouts yet."));

    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final day in summary)
                  Expanded(
                    child: _StatsBar(
                      label: _weekday(day['date'] as DateTime),
                      value: day['hasSession'] ? 1.0 : 0.0,
                      goal: 1.0, 
                      color: Theme.of(context).colorScheme.secondary,
                      isBinary: true,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '$activeDays active days • $totalMins mins total',
            style: context.textStyles.bodySmall?.withColor(Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
  String _weekday(DateTime dt) => ['M','T','W','T','F','S','S'][dt.weekday - 1];
}

class _StatsBar extends StatelessWidget {
  final String label;
  final double value;
  final double goal;
  final Color color;
  final bool isBinary;

  const _StatsBar({
    required this.label, 
    required this.value, 
    required this.goal, 
    required this.color,
    this.isBinary = false,
  });

  @override
  Widget build(BuildContext context) {
    double ratio = 0;
    if (isBinary) {
      ratio = value > 0 ? 1.0 : 0.1;
    } else {
      ratio = goal <= 0 ? 0 : (value / goal).clamp(0.0, 1.0); // Cap at 1.0 for visual neatness
    }

    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutBack,
              width: 12, // slightly thicker
              height: isBinary ? (value > 0 ? 60 : 4) : (100 * ratio).clamp(4.0, 80.0), // Min height 4
              decoration: BoxDecoration(
                color: ratio >= 1.0 
                    ? color 
                    : color.withValues(alpha: 0.3 + (ratio * 0.4)),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: context.textStyles.labelSmall),
      ],
    );
  }
}

class _ProgramStatsSection extends StatelessWidget {
  final HabitProvider habitProvider;
  final DailyLogProvider logProvider;

  const _ProgramStatsSection({required this.habitProvider, required this.logProvider});

  @override
  Widget build(BuildContext context) {
    final packs = ProgramPacksRepository.defaultPacks;
    final List<Widget> items = [];

    for (final pack in packs) {
      final habitIds = habitProvider.habits.where((h) => h.programId == pack.id).map((h) => h.id).toList();
      if (habitIds.isEmpty) continue;

      final (activeDays, totalDays) = logProvider.getProgramActivityForLastDays(habitIds, days: 7);
      if (activeDays == 0) continue;

      items.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _DashboardCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_iconForPack(pack.iconKey), color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              title: Text(pack.name, style: context.textStyles.titleSmall?.bold),
              subtitle: Text('$activeDays / 7 days active'),
              trailing: CircularProgressIndicator(
                 value: activeDays / 7, 
                 strokeWidth: 4, 
                 backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
        )
      );
    }
    
    if (items.isEmpty) return const Padding(padding: EdgeInsets.all(8), child: Text("Start a program to see stats here."));
    
    return Column(children: items);
  }

  IconData _iconForPack(String iconKey) {
    switch (iconKey) {
      case 'water': return Icons.local_drink_outlined;
      case 'walk': return Icons.directions_walk_outlined;
      case 'focus': return Icons.center_focus_strong;
      case 'workout': return Icons.fitness_center;
      default: return Icons.auto_awesome_outlined;
    }
  }
}


