import 'dart:async';

import 'package:daily_reset/models/workout_models.dart';
import 'package:daily_reset/providers/workout_provider.dart';
import 'package:daily_reset/components/core/components.dart';
import 'package:daily_reset/widgets/exercise_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutSessionScreen extends StatefulWidget {
  final String routineId;

  const WorkoutSessionScreen({super.key, required this.routineId});

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  late List<WorkoutStep> _steps;
  late WorkoutRoutine _routine;
  int _currentIndex = 0;
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isPaused = false;
  late DateTime _startTime;
  int _completedSteps = 0;
  int _skippedSteps = 0;

  @override
  void initState() {
    super.initState();
    final provider = context.read<WorkoutProvider>();
    _routine = provider.routines.firstWhere((r) => r.id == widget.routineId,
        orElse: () => provider.routines.first);
    _steps = provider.stepsForRoutine(_routine.id);
    _startTime = DateTime.now();
    _loadCurrentStep();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _loadCurrentStep() {
    _timer?.cancel();
    final step = _steps[_currentIndex];
    if (step.type == WorkoutStepType.timed) {
      _remainingSeconds = step.durationSeconds ?? 0;
      _startTimer();
    } else {
      _remainingSeconds = 0;
    }
    setState(() {});
  }

  void _startTimer() {
    _isPaused = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused) return;
      if (_remainingSeconds <= 1) {
        timer.cancel();
        _onNext(autoComplete: true);
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void _togglePause() {
    if (_steps[_currentIndex].type != WorkoutStepType.timed) return;
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _onNext({bool autoComplete = false}) {
    if (!autoComplete) {
      _completedSteps++;
    }
    if (_currentIndex < _steps.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _loadCurrentStep();
    } else {
      _finishSession();
    }
  }

  void _onPrevious() {
    if (_currentIndex == 0) return;
    setState(() {
      _currentIndex--;
    });
    _loadCurrentStep();
  }

  void _onSkip() {
    _skippedSteps++;
    if (_currentIndex < _steps.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _loadCurrentStep();
    } else {
      _finishSession();
    }
  }

  Future<void> _finishSession() async {
    _timer?.cancel();
    final provider = context.read<WorkoutProvider>();
    final endTime = DateTime.now();
    final totalMinutes = endTime.difference(_startTime).inMinutes.clamp(1, 180);
    final log = WorkoutSessionLog(
      routineId: _routine.id,
      startTime: _startTime,
      endTime: endTime,
      completedStepsCount: _completedSteps,
      skippedStepsCount: _skippedSteps,
      totalMinutes: totalMinutes,
      intensity: WorkoutIntensity.medium,
    );
    await provider.addSessionLog(log);
    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Good job!'),
          content: const Text(
              'Session complete. Great work taking time for your body today.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  String _getDifficultyLabel(WorkoutDifficulty d) {
    switch (d) {
      case WorkoutDifficulty.beginner:
        return 'Beginner';
      case WorkoutDifficulty.intermediate:
        return 'Intermediate';
      case WorkoutDifficulty.advanced:
        return 'Advanced';
    }
  }

  String _buildMetadataString(WorkoutStep step) {
    final difficulty = _getDifficultyLabel(_routine.difficulty);
    String part1 = '';
    
    // Prefer recommended values, fallback to actual
    if (step.recommendedReps != null) {
      part1 = '${step.recommendedReps} reps';
    } else if (step.recommendedSeconds != null) {
      part1 = '${step.recommendedSeconds} sec';
    } else if (step.reps != null && step.reps! > 0) {
      part1 = '${step.reps} reps';
    } else if (step.durationSeconds != null && step.durationSeconds! > 0) {
      part1 = '${step.durationSeconds} sec';
    }

    if (part1.isNotEmpty) {
      return '$part1 • $difficulty';
    }
    return difficulty;
  }

  @override
  Widget build(BuildContext context) {
    if (_steps.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Workout')),
        body: const Center(child: Text('No steps defined for this routine.')),
      );
    }
    final step = _steps[_currentIndex];
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(_routine.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Visual area
            Expanded(
              flex: 3,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 32,
                    maxHeight: MediaQuery.of(context).size.height * 0.45,
                  ),
                  child: _buildStepVisual(context, step),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Exercise Name
            Text(
              step.title,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            // Instructions
            if (step.instructions != null && step.instructions!.isNotEmpty)
              Text(
                step.instructions!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              )
            else
              Text(
                step.description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: 8),

            // Metadata: "X reps • Beginner"
            Text(
              _buildMetadataString(step),
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Timer / Reps Large Display
            if (step.type == WorkoutStepType.timed)
              Text(
                '${_remainingSeconds}s',
                style: theme.textTheme.displayMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              )
            else
              Text(
                '${step.reps ?? 0} reps',
                style: theme.textTheme.displayMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              
            const Spacer(flex: 2),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.filledTonal(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _currentIndex > 0 ? _onPrevious : null,
                ),
                if (step.type == WorkoutStepType.timed)
                  IconButton.filled(
                    icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                    iconSize: 32,
                    padding: const EdgeInsets.all(16),
                    onPressed: _togglePause,
                  )
                else
                  const SizedBox(width: 64), // Spacer for center button alignment
                IconButton.filledTonal(
                  icon: const Icon(Icons.skip_next),
                  onPressed: _onSkip,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _onNext,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _currentIndex == _steps.length - 1
                      ? 'Finish Session'
                      : 'Next Step',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 8),
            DRButtonGhost(
              label: 'End session early',
              size: DRButtonSize.small,
              onPressed: _finishSession,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepVisual(BuildContext context, WorkoutStep step) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: step.mediaAssetPath != null
          ? ExerciseImage(
              imagePath: step.mediaAssetPath!,
              borderRadius: 24,
              aspectRatio: 4 / 3,
            )
          : (step.mediaUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    step.mediaUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholder(context, step),
                  ),
                )
              : _buildPlaceholder(context, step)),
    );
  }

  Widget _buildPlaceholder(BuildContext context, WorkoutStep step) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.tertiaryContainer,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _iconData(step.iconName),
            size: 64,
            color: theme.colorScheme.onPrimaryContainer,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              step.title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
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
        return Icons.push_pin_outlined;
      case 'shield':
        return Icons.shield_outlined;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'pets':
        return Icons.pets;
      case 'donut_large':
        return Icons.donut_large;
      case 'directions_run':
        return Icons.directions_run;
      case 'air':
        return Icons.air;
      case 'bolt':
        return Icons.bolt;
      case 'event_seat':
        return Icons.event_seat;
      case 'bug_report':
        return Icons.bug_report;
      default:
        return Icons.circle_outlined;
    }
  }
}
