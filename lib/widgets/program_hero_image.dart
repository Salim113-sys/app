import 'package:flutter/material.dart';

class ProgramHeroImage extends StatelessWidget {
  final String imagePath;
  final double aspectRatio;
  final double borderRadius;

  const ProgramHeroImage({
    super.key,
    required this.imagePath,
    this.aspectRatio = 16 / 9,
    this.borderRadius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: FittedBox(
          fit: BoxFit.contain, // show whole image
          child: Image.asset(
            imagePath,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                alignment: Alignment.center,
                child: Icon(Icons.broken_image, color: Theme.of(context).colorScheme.onSurfaceVariant),
              );
            },
          ),
        ),
      ),
    );
  }
}
