import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daily_reset/providers/hydration_provider.dart';
import 'package:daily_reset/theme.dart';
import 'package:daily_reset/widgets/water_bottle_fill.dart';

class HydrationControlsCard extends StatelessWidget {
  const HydrationControlsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final hydrationProvider = context.watch<HydrationProvider>();
    final settings = hydrationProvider.settings;
    final currentMl = hydrationProvider.todayTotalMl;
    final goalMl = settings.dailyGoalMl;
    
    // Avoid division by zero
    // Avoid division by zero
    // final progress = (goalMl <= 0) ? 0.0 : (currentMl / goalMl).clamp(0.0, 1.0);
    
    // Convert ML to L for cleaner display if > 1000? 
    // Actually keep ML/ML is precise. Or 0.8 / 2.0 L as requested.
    // "0.8 L / 2.0 L"
    String formatLiters(int ml) {
      if (ml == 0) return '0 L';
      return '${(ml / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')} L';
    }

    final theme = Theme.of(context);

    // Default quick add buttons: 250ml, 500ml, 1000ml (1L)
    final quickAdds = [250, 500, 1000];

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: AppSpacing.paddingMd,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 3D Glass
                SizedBox(
                  height: 140,
                  width: 70,
                  child: WaterBottleFill(
                    progress: (goalMl > 0 ? currentMl / goalMl : 0.0),
                  ),
                ),
                const SizedBox(width: 24),
                // Stats & Controls
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.water_drop, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Hydration',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${currentMl.toInt()} / ${goalMl.toInt()} ml',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        'Goal: ${formatLiters(goalMl)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Quick Adds Grid
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final amount in quickAdds)
                            SizedBox(
                              width: 70, // Fixed width for nice grid
                              child: ElevatedButton(
                                onPressed: () {
                                  hydrationProvider.logDrink(amount, source: 'quick_home');
                                },
                                style: ElevatedButton.styleFrom(
                                   padding: const EdgeInsets.symmetric(vertical: 12),
                                   visualDensity: VisualDensity.compact,
                                   backgroundColor: theme.colorScheme.surface,
                                   foregroundColor: theme.colorScheme.primary,
                                   elevation: 0,
                                   side: BorderSide(color: theme.colorScheme.outlineVariant),
                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text(
                                  '+$amount',
                                   style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
