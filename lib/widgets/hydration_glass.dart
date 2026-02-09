import 'package:flutter/material.dart';

class HydrationGlass extends StatelessWidget {
  final double currentMl;
  final double goalMl;
  final double height;
  final double width;

  const HydrationGlass({
    super.key,
    required this.currentMl,
    required this.goalMl,
    this.height = 160,
    this.width = 100,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate percentage (clamped 0..1)
    final double percentage = (goalMl > 0 ? currentMl / goalMl : 0.0).clamp(0.0, 1.0);
    final theme = Theme.of(context);

    // Glass aesthetics
    final glassColor = theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);
    final borderColor = theme.colorScheme.outlineVariant.withValues(alpha: 0.5);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // 1. The Empty Glass Container (Background + Border)
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: glassColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(4),
              bottom: Radius.circular(16),
            ),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),

        // 2. The Water (Animated) with 3D effect
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(14),
          ),
          child: Container(
            height: height - 4,
            width: width - 4,
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              height: (height - 4) * percentage,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF4FC3F7).withValues(alpha: 0.9), // Light Blue
                    const Color(0xFF0288D1), // Darker Blue
                  ],
                ),
              ),
              child: Stack(
                children: [
                   // Top surface reflection (Meniscus)
                   Positioned(
                     top: 0, left: 0, right: 0, height: 4,
                     child: Container(
                       decoration: BoxDecoration(
                         color: Colors.white.withValues(alpha: 0.3),
                         borderRadius: BorderRadius.all(Radius.elliptical(width, 4)),
                       ),
                     ),
                   ),
                   // Bubbles
                   if (percentage > 0.2) ...[
                      Positioned(bottom: 20, right: 20, child: _Bubble(size: 6)),
                      Positioned(bottom: 40, left: 15, child: _Bubble(size: 4)),
                      Positioned(bottom: 10, left: 30, child: _Bubble(size: 8)),
                   ],
                ],
              ),
            ),
          ),
        ),

        // 3. Tick Marks (Measurement Lines) for 250ml
        // Only show if we have a valid goal
        if (goalMl > 0)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _GlassTicksPainter(
                  goalMl: goalMl,
                  tickInterval: 250,
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
          
        // 4. Glare / Reflection (Pseudo-3D effect)
        Positioned(
          top: 8,
          right: 8,
          bottom: 16,
          width: width * 0.1,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.0),
                ],
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }
}

class _GlassTicksPainter extends CustomPainter {
  final double goalMl;
  final double tickInterval;
  final Color color;

  _GlassTicksPainter({
    required this.goalMl,
    required this.tickInterval,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    final double totalHeight = size.height - 4; // Inside height matches water container
    // Start drawing from bottom
    
    // How many ticks?
    final int tickCount = (goalMl / tickInterval).floor();

    for (int i = 1; i < tickCount; i++) {
        final double mlAtTick = i * tickInterval;
        if (mlAtTick >= goalMl) break;
        
        final double pct = mlAtTick / goalMl;
        final double y = size.height - 2 - (totalHeight * pct); // -2 for bottom border offset
        
        // Draw tick on the left side
        canvas.drawLine(Offset(4, y), Offset(12, y), paint);
        // Draw tick on the right side
        canvas.drawLine(Offset(size.width - 12, y), Offset(size.width - 4, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Bubble extends StatelessWidget {
  final double size;
  const _Bubble({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.4),
      ),
    );
  }
}
