import 'dart:async';
import 'package:flutter/material.dart';
import 'package:daily_reset/components/core/components.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _instruction = 'Inhale';
  Timer? _instructionTimer;
  
  // 4-4-4-4 Box Breathing or 4-7-8? Let's do 4-4-4-4 for visual symmetry first.
  // Inhale (4s) -> Hold (4s) -> Exhale (4s) -> Hold (4s)
  // Total cycle: 16s
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
    
    _controller.addListener(_updateInstruction);
  }

  void _updateInstruction() {
    final value = _controller.value;
    if (value < 0.25) {
       if (_instruction != 'Inhale') setState(() => _instruction = 'Inhale');
    } else if (value < 0.50) {
       if (_instruction != 'Hold') setState(() => _instruction = 'Hold');
    } else if (value < 0.75) {
       if (_instruction != 'Exhale') setState(() => _instruction = 'Exhale');
    } else {
       if (_instruction != 'Hold') setState(() => _instruction = 'Hold');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _instructionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: DRAppBarWithClose(title: 'Breathe'),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Visualize scaling based on phase
            double scale = 1.0;
            final value = _controller.value;
            
            if (value < 0.25) {
              // Inhale: 1.0 -> 1.5
              scale = 1.0 + (value * 4) * 0.5;
            } else if (value < 0.50) {
              // Hold: 1.5
              scale = 1.5;
            } else if (value < 0.75) {
              // Exhale: 1.5 -> 1.0
              scale = 1.5 - ((value - 0.5) * 4) * 0.5;
            } else {
              // Hold: 1.0
              scale = 1.0;
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer glow
                    Container(
                      width: 200 * scale,
                      height: 200 * scale,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                      ),
                    ),
                    // Inner circle
                    Container(
                      width: 150 * scale,
                      height: 150 * scale,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primary.withValues(alpha: 0.2), // More opaque
                        gradient: RadialGradient(
                           colors: [
                             theme.colorScheme.primary.withValues(alpha: 0.6),
                             theme.colorScheme.primary.withValues(alpha: 0.1),
                           ],
                        ),
                      ),
                    ),
                    Text(
                      _instruction,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100),
                Text(
                  'Box Breathing',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Inhale... Hold... Exhale... Hold',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
