import 'package:flutter/material.dart';
import '../../design_system/design_system.dart';

/// DRCard - Premium minimal card component
///
/// A consistent card wrapper with subtle elevation, rounded corners,
/// and optional border. Follows the Daily Reset design system.
class DRCard extends StatelessWidget {
  const DRCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.elevation = 0,
    this.showBorder = true,
    this.showShadow = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final double elevation;
  final bool showBorder;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    final defaultBorderColor = brightness == Brightness.light
        ? LightColors.outline.withValues(alpha: 0.5)
        : DarkColors.outline.withValues(alpha: 0.5);

    final defaultBackgroundColor = backgroundColor ??
        (brightness == Brightness.light
            ? LightColors.surface
            : DarkColors.surface);

    final defaultBorderRadius = borderRadius ?? AppRadius.card;

    Widget cardContent = Padding(
      padding: padding ?? AppSpacing.cardAll,
      child: child,
    );

    // Add InkWell if onTap is provided
    if (onTap != null || onLongPress != null) {
      cardContent = InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: defaultBorderRadius,
        child: cardContent,
      );
    }

    // Wrap with margin if provided
    if (margin != null) {
      cardContent = Padding(
        padding: margin!,
        child: cardContent,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: defaultBackgroundColor,
        borderRadius: defaultBorderRadius,
        border: showBorder
            ? Border.all(
                color: borderColor ?? defaultBorderColor,
                width: 1,
              )
            : null,
        boxShadow:
            showShadow ? AppShadows.forBrightness(brightness, elevation) : null,
      ),
      child: ClipRRect(
        borderRadius: defaultBorderRadius,
        child: cardContent,
      ),
    );
  }
}

/// DRCard variants for common use cases
class DRCardVariant {
  /// Standard card with subtle border
  static DRCard standard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    Color? backgroundColor,
  }) {
    return DRCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      backgroundColor: backgroundColor,
      showBorder: true,
      showShadow: false,
      child: child,
    );
  }

  /// Elevated card with shadow
  static DRCard elevated({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    Color? backgroundColor,
    double elevation = AppElevation.md,
  }) {
    return DRCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      backgroundColor: backgroundColor,
      showBorder: false,
      showShadow: true,
      elevation: elevation,
      child: child,
    );
  }

  /// Flat card without border or shadow
  static DRCard flat({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    Color? backgroundColor,
  }) {
    return DRCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      backgroundColor: backgroundColor,
      showBorder: false,
      showShadow: false,
      child: child,
    );
  }
}
