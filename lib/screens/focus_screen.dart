import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:daily_reset/providers/focus_provider.dart';
import 'package:daily_reset/theme.dart';
import 'package:daily_reset/components/core/components.dart';

class FocusScreen extends StatelessWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final focusProvider = context.watch<FocusProvider>();
    final theme = Theme.of(context);

    // Format remaining time MM:SS
    final minutes = (focusProvider.remainingSeconds / 60).floor().toString().padLeft(2, '0');
    final seconds = (focusProvider.remainingSeconds % 60).toString().padLeft(2, '0');
    final timeString = '$minutes:$seconds';

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: DRAppBarWithClose(
        title: 'Focus Mode',
        onBackPressed: () {
          // Confirm exit if running
          if (focusProvider.state == FocusState.running) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Quit Session?'),
                content: const Text('Your focus progress will be lost.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      focusProvider.stop();
                      Navigator.pop(ctx);
                      context.pop();
                    },
                    child: const Text('Quit'),
                  ),
                ],
              ),
            );
          } else {
            context.pop();
          }
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingLg,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (focusProvider.state == FocusState.idle) ...[
                const Icon(Icons.timer_outlined, size: 80),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Deep Work Session',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Choose a duration to focus.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    _DurationChip(minutes: 15, onSelect: () => focusProvider.startSession(15)),
                    _DurationChip(minutes: 25, onSelect: () => focusProvider.startSession(25)),
                    _DurationChip(minutes: 45, onSelect: () => focusProvider.startSession(45)),
                    _DurationChip(minutes: 60, onSelect: () => focusProvider.startSession(60)),
                  ],
                ),
              ] else if (focusProvider.state == FocusState.completed) ...[
                 const Icon(Icons.check_circle, size: 80, color: Colors.green),
                 const SizedBox(height: AppSpacing.xl),
                 Text('Session Complete!', style: theme.textTheme.headlineMedium),
                 const SizedBox(height: AppSpacing.lg),
                 ElevatedButton(
                   onPressed: () => focusProvider.stop(),
                   child: const Text('Done'),
                 ),
              ] else ...[
                 // Running or Paused
                 Stack(
                   alignment: Alignment.center,
                   children: [
                     SizedBox(
                       width: 250,
                       height: 250,
                       child: CircularProgressIndicator(
                         value: focusProvider.progress,
                         strokeWidth: 12,
                         backgroundColor: theme.colorScheme.surfaceContainerHighest,
                         valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                         strokeCap: StrokeCap.round,
                       ),
                     ),
                     Column(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         Text(
                           timeString,
                           style: theme.textTheme.displayLarge?.copyWith(
                             fontWeight: FontWeight.bold,
                             fontFeatures: [const FontFeature.tabularFigures()],
                           ),
                         ),
                         const SizedBox(height: 8),
                         Text(
                           focusProvider.state == FocusState.paused ? 'Paused' : 'Focusing',
                           style: theme.textTheme.titleMedium?.copyWith(
                             color: theme.colorScheme.primary,
                           ),
                         ),
                       ],
                     ),
                   ],
                 ),
                 const SizedBox(height: 60),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     if (focusProvider.state == FocusState.running)
                       FloatingActionButton.large(
                         onPressed: focusProvider.pause,
                         child: const Icon(Icons.pause),
                       )
                     else
                       FloatingActionButton.large(
                         onPressed: focusProvider.resume,
                         child: const Icon(Icons.play_arrow),
                       ),
                       
                     const SizedBox(width: 20),
                     FloatingActionButton(
                       onPressed: () => focusProvider.stop(),
                       backgroundColor: theme.colorScheme.errorContainer,
                       foregroundColor: theme.colorScheme.onErrorContainer,
                       elevation: 0,
                       child: const Icon(Icons.stop),
                     ),
                   ],
                 ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DurationChip extends StatelessWidget {
  final int minutes;
  final VoidCallback onSelect;

  const _DurationChip({required this.minutes, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text('$minutes min'),
      onPressed: onSelect,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
