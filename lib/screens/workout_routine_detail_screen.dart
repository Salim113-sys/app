import 'package:daily_reset/models/workout_models.dart';
import 'package:daily_reset/providers/workout_provider.dart';
import 'package:daily_reset/widgets/exercise_image.dart';
import 'package:flutter/material.dart';
import 'package:daily_reset/widgets/program_hero_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class WorkoutRoutineDetailScreen extends StatelessWidget {
  final String routineId;

  const WorkoutRoutineDetailScreen({super.key, required this.routineId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();
    final routine = provider.routines.firstWhere((r) => r.id == routineId,
        orElse: () => provider.routines.first);
    final steps = provider.stepsForRoutine(routine.id);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Routine Detail'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeroSection(context, routine),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Exercises (${steps.length})',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: steps.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _ExerciseCard(step: steps[index]);
                    },
                  ),
                  const SizedBox(height: 32),
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
                child: FilledButton.icon(
                  onPressed: () {
                    context.push('/workout/session/${routine.id}');
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start session'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, WorkoutRoutine routine) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      color: theme.colorScheme.surfaceContainerLow,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          if (routine.mediaAsset != null)
            ProgramHeroImage(
              imagePath: routine.mediaAsset!,
              aspectRatio: 16 / 9,
            )
          else
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primaryContainer,
                      theme.colorScheme.tertiaryContainer,
                    ],
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  _iconForGoal(routine.goal),
                  size: 64,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          const SizedBox(height: 24),
          Text(
            routine.name,
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            routine.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              _HeroChip(
                icon: Icons.timer_outlined,
                label: '${routine.estimatedMinutes} min',
              ),
              _HeroChip(
                icon: Icons.bar_chart,
                label: _difficultyLabel(routine.difficulty),
              ),
              _HeroChip(
                icon: Icons.flag_outlined,
                label: _goalLabel(routine.goal),
              ),
            ],
          ),
        ],
      ),
    );
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

  String _goalLabel(WorkoutGoal g) {
    switch (g) {
      case WorkoutGoal.strength:
        return 'Strength';
      case WorkoutGoal.mobility:
        return 'Mobility';
      case WorkoutGoal.cardio:
        return 'Cardio';
      case WorkoutGoal.relax:
        return 'Relax';
    }
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
}

class _HeroChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final WorkoutStep step;

  const _ExerciseCard({required this.step});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determine the secondary label text
    String? secondaryLabel;
    if (step.recommendedReps != null) {
      secondaryLabel = '• ${step.recommendedReps} reps';
    } else if (step.recommendedSeconds != null) {
      secondaryLabel = '• ${step.recommendedSeconds} sec';
    }

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Visual Area
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: _buildVisual(context),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  if (secondaryLabel != null)
                    Text(
                      secondaryLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (secondaryLabel != null) const SizedBox(height: 2),
                  Text(
                    step.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                step.type == WorkoutStepType.timed
                    ? '${step.durationSeconds ?? 0}s'
                    : 'x${step.reps ?? 0}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisual(BuildContext context) {
    if (step.mediaAsset != null && step.mediaAsset!.isNotEmpty) {
      return ExerciseImage(
        imagePath: step.mediaAsset!,
        borderRadius: 12,
        aspectRatio: 1, // Square for thumbnail
      );
    }
    
    return _PremiumGradientVisual(
      text: step.title, 
      // If legacy iconName is null, the widget has smart fallbacks
      iconName: step.iconName,
    );
  }
}

class _PremiumGradientVisual extends StatelessWidget {
  final String text;
  final String? iconName;

  const _PremiumGradientVisual({
    required this.text,
    this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    // Deterministic color generation based on text hash
    final int hash = text.hashCode;
    
    // Curated premium pastel/vibrant colors
    final colors = [
      const Color(0xFF6B8EFF), // Blue
      const Color(0xFFFF8E8E), // Red/Pink
      const Color(0xFF5CD6C0), // Teal
      const Color(0xFFFFB36B), // Orange
      const Color(0xFFA685E2), // Purple
      const Color(0xFFFCCB6F), // Yellow
      const Color(0xFF68D391), // Green
      const Color(0xFF63B3ED), // Sky
    ];
    
    // Pick two colors based on hash
    final color1 = colors[hash.abs() % colors.length];
    final color2 = colors[(hash.abs() ~/ 7) % colors.length];

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color1, color2],
          ),
        ),
        child: Icon(
          _iconData(iconName),
          color: Colors.white, // Always white on premium gradient
          size: 28,
        ),
      ),
    );
  }

  IconData _iconData(String? name) {
    switch (name) {
      case 'directions_walk':
        return Icons.directions_walk;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'push_pin':
        return Icons.push_pin_outlined; // Push-ups
      case 'shield':
        return Icons.shield_outlined; // Plank
      case 'self_improvement':
        return Icons.self_improvement; // Yoga/Stretch
      case 'pets':
        return Icons.pets; // Cat-Cow
      case 'donut_large':
        return Icons.donut_large; // Hip Circles
      case 'directions_run':
        return Icons.directions_run; // Cardio
      case 'air':
        return Icons.air; // Breathing
      case 'bolt':
        return Icons.bolt; // Fast feet
      case 'event_seat':
        return Icons.event_seat; // Wall sit
      case 'bug_report':
        return Icons.bug_report; // Dead bug
      case 'accessibility_new':
        return Icons.accessibility_new;
      default:
        // Smart fallback based on text if icon is missing or generic
        if (text.toLowerCase().contains('squat')) return Icons.accessibility_new;
        if (text.toLowerCase().contains('lunge')) return Icons.directions_walk;
        if (text.toLowerCase().contains('push')) return Icons.download;
        if (text.toLowerCase().contains('stretch')) return Icons.self_improvement;
        return Icons.play_arrow;
    }
  }
}
