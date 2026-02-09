import 'package:flutter/material.dart';

class ExerciseImage extends StatelessWidget {
  final String imagePath;
  final double borderRadius;
  final double aspectRatio;

  const ExerciseImage({
    super.key,
    required this.imagePath,
    this.borderRadius = 24,
    this.aspectRatio = 1, // square by default
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          child: FittedBox(
            fit: BoxFit.contain, // show the whole image
            alignment: Alignment.center,
            child: Image.asset(imagePath),
          ),
        ),
      ),
    );
  }
}
