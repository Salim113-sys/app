import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:daily_reset/models/daily_log.dart';
import 'package:intl/intl.dart';

class MoodSplineChart extends StatelessWidget {
  final List<MoodLevel?> moods;

  const MoodSplineChart({super.key, required this.moods});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: _MoodSplinePainter(
                moods: moods,
                colorScheme: Theme.of(context).colorScheme,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final date = DateTime.now().subtract(Duration(days: 6 - index));
              return Text(
                DateFormat('E').format(date).substring(0, 1),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _MoodSplinePainter extends CustomPainter {
  final List<MoodLevel?> moods;
  final ColorScheme colorScheme;

  _MoodSplinePainter({required this.moods, required this.colorScheme});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colorScheme.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..style = PaintingStyle.fill;

    // Grid lines
    final gridPaint = Paint()
      ..color = colorScheme.outlineVariant.withValues(alpha: 0.5)
      ..strokeWidth = 1;

    final double stepX = size.width / 6;
    final double stepY = size.height / 4; // 5 levels (1..5) means 4 gaps

    // Draw horizontal grid lines
    for (int i = 0; i < 5; i++) {
        final y = i * stepY;
        canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final path = Path();
    final filledPath = Path(); // For gradient fill

    // Collect valid points
    final points = <Offset>[];
    for (int i = 0; i < moods.length; i++) {
      if (moods[i] != null) {
        // value 1 (bottom) to 5 (top)
        // Y coord: 5 -> 0, 1 -> size.height
        // Normalized: (5 - val) * stepY
        final x = i * stepX;
        final val = moods[i]!.value;
        final y = (5 - val) * stepY;
        points.add(Offset(x, y));
      }
    }

    if (points.isEmpty) return;

    if (points.length == 1) {
       // Just one dot
       final p = points.first;
       canvas.drawCircle(p, 5, paint..style = PaintingStyle.fill); 
       return;
    }

    // Draw spline
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      
      // Control points for smooth curve
      final cp1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final cp2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);

      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p1.dx, p1.dy);
    }

    canvas.drawPath(path, paint);

    // Draw Gradient Fill
    if (points.length > 1) {
        filledPath.addPath(path, Offset.zero);
        filledPath.lineTo(points.last.dx, size.height);
        filledPath.lineTo(points.first.dx, size.height);
        filledPath.close();

        final gradient = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
                colorScheme.primary.withValues(alpha: 0.3),
                colorScheme.primary.withValues(alpha: 0.0),
            ],
        );
        
        final fillPaint = Paint()
            ..style = PaintingStyle.fill
            ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
            
        canvas.drawPath(filledPath, fillPaint);
    }
  
    // Draw dots
    for (int i = 0; i < moods.length; i++) {
        final mood = moods[i];
        if (mood != null) {
            final x = i * stepX;
            final y = (5 - mood.value) * stepY;
            
            dotPaint.color = _getMoodColor(mood);
            canvas.drawCircle(Offset(x, y), 5, dotPaint);
            
            // Draw Emoji above dot
            final textSpan = TextSpan(
                text: mood.emoji,
                style: const TextStyle(fontSize: 16),
            );
            final textPainter = TextPainter(
                text: textSpan,
                textDirection: ui.TextDirection.ltr,
                textAlign: TextAlign.center,
            );
            textPainter.layout();
            textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - 24));
        }
    }
  }

  Color _getMoodColor(MoodLevel mood) {
    switch (mood) {
      case MoodLevel.veryLow:
        return const Color(0xFFE74C3C);
      case MoodLevel.low:
        return const Color(0xFFFF8A80);
      case MoodLevel.neutral:
        return const Color(0xFFFFB74D);
      case MoodLevel.good:
        return const Color(0xFF95E1D3);
      case MoodLevel.veryGood:
        return const Color(0xFF4ECDC4);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
