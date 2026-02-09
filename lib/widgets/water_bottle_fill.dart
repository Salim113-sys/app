import 'package:flutter/material.dart';

class WaterBottleFill extends StatelessWidget {
  /// Value between 0.0 and 1.0
  final double progress;

  const WaterBottleFill({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);

    return AspectRatio(
      aspectRatio: 1 / 2, // tall bottle shape
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = constraints.maxHeight;

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.4),
                width: 2,
              ),
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  width: double.infinity,
                  height: maxHeight * clamped,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(22),
                      top: Radius.circular(22),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF7EE7E1),
                        Color(0xFF4ECDC4),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 10,
                  right: 10,
                  child: Opacity(
                    opacity: 0.25,
                    child: Container(
                      height: 12,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
