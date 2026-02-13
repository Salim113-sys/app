// ignore_for_file: prefer_const_constructors_in_immutables, use_super_parameters

import 'package:flutter/material.dart';
import '../../design_system/design_system.dart';

/// DRButton - Premium minimal button component
///
/// Consistent button styling following the Daily Reset design system.
/// Supports primary, secondary, outline, ghost, and destructive variants.
enum DRButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  destructive,
}

enum DRButtonSize {
  small,
  medium,
  large,
}

class DRButton extends StatelessWidget {
  const DRButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = DRButtonVariant.primary,
    this.size = DRButtonSize.medium,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final DRButtonVariant variant;
  final DRButtonSize size;
  final IconData? icon;
  final IconPosition iconPosition;
  final bool isLoading;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final colors = brightness == Brightness.dark
        ? AppColorTokens.fromDark()
        : AppColorTokens.fromLight();

    final (backgroundColor, foregroundColor, borderColor) =
        _getColors(colors, brightness);

    final (padding, textStyle, iconSize) = _getSize();

    Widget buttonChild = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          )
        else ...[
          if (icon != null && iconPosition == IconPosition.left) ...[
            Icon(icon, size: iconSize),
            const SizedBox(width: AppSpacing.sm),
          ],
          Flexible(
            child: Text(
              label,
              style: textStyle.copyWith(color: foregroundColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (icon != null && iconPosition == IconPosition.right) ...[
            const SizedBox(width: AppSpacing.sm),
            Icon(icon, size: iconSize),
          ],
        ],
      ],
    );

    final borderRadius = BorderRadius.circular(_getBorderRadius());

    switch (variant) {
      case DRButtonVariant.primary:
      case DRButtonVariant.secondary:
      case DRButtonVariant.destructive:
        return Material(
          color: backgroundColor,
          borderRadius: borderRadius,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: borderRadius,
            child: Container(
              padding: padding,
              constraints: BoxConstraints(
                minWidth: _getMinWidth(),
              ),
              child: buttonChild,
            ),
          ),
        );
      case DRButtonVariant.outline:
        return Material(
          color: Colors.transparent,
          borderRadius: borderRadius,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: borderRadius,
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                border: Border.all(
                  color: borderColor ?? foregroundColor,
                  width: 1.5,
                ),
                borderRadius: borderRadius,
              ),
              constraints: BoxConstraints(
                minWidth: _getMinWidth(),
              ),
              child: buttonChild,
            ),
          ),
        );
      case DRButtonVariant.ghost:
        return Material(
          color: Colors.transparent,
          borderRadius: borderRadius,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: borderRadius,
            child: Container(
              padding: padding,
              constraints: BoxConstraints(
                minWidth: _getMinWidth(),
              ),
              child: buttonChild,
            ),
          ),
        );
    }
  }

  (Color, Color, Color?) _getColors(
      AppColorTokens colors, Brightness brightness) {
    switch (variant) {
      case DRButtonVariant.primary:
        return (colors.accent, colors.onAccent, null);
      case DRButtonVariant.secondary:
        final bgColor = brightness == Brightness.light
            ? LightColors.surfaceVariant
            : DarkColors.surfaceVariant;
        return (bgColor, colors.accent, null);
      case DRButtonVariant.outline:
        return (Colors.transparent, colors.accent, colors.accent);
      case DRButtonVariant.ghost:
        return (Colors.transparent, colors.accent, null);
      case DRButtonVariant.destructive:
        return (colors.error, colors.onError, null);
    }
  }

  (EdgeInsetsGeometry, TextStyle, double) _getSize() {
    switch (size) {
      case DRButtonSize.small:
        return (
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          14.0,
        );
      case DRButtonSize.medium:
        return (
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          18.0,
        );
      case DRButtonSize.large:
        return (
          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          20.0,
        );
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case DRButtonSize.small:
        return AppRadius.md;
      case DRButtonSize.medium:
        return AppRadius.lg;
      case DRButtonSize.large:
        return AppRadius.lg;
    }
  }

  double _getMinWidth() {
    switch (size) {
      case DRButtonSize.small:
        return 64;
      case DRButtonSize.medium:
        return 88;
      case DRButtonSize.large:
        return 120;
    }
  }
}

enum IconPosition { left, right }

/// Convenience constructors for common button types
class DRButtonPrimary extends DRButton {
  DRButtonPrimary({
    super.key,
    required String label,
    VoidCallback? onPressed,
    IconData? icon,
    IconPosition iconPosition = IconPosition.left,
    bool isLoading = false,
    bool isFullWidth = false,
    DRButtonSize size = DRButtonSize.medium,
  }) : super(
          label: label,
          onPressed: onPressed,
          icon: icon,
          iconPosition: iconPosition,
          isLoading: isLoading,
          isFullWidth: isFullWidth,
          size: size,
          variant: DRButtonVariant.primary,
        );
}

class DRButtonOutline extends DRButton {
  DRButtonOutline({
    super.key,
    required String label,
    VoidCallback? onPressed,
    IconData? icon,
    IconPosition iconPosition = IconPosition.left,
    bool isLoading = false,
    bool isFullWidth = false,
    DRButtonSize size = DRButtonSize.medium,
  }) : super(
          label: label,
          onPressed: onPressed,
          icon: icon,
          iconPosition: iconPosition,
          isLoading: isLoading,
          isFullWidth: isFullWidth,
          size: size,
          variant: DRButtonVariant.outline,
        );
}

class DRButtonGhost extends DRButton {
  DRButtonGhost({
    super.key,
    required String label,
    VoidCallback? onPressed,
    IconData? icon,
    IconPosition iconPosition = IconPosition.left,
    bool isLoading = false,
    bool isFullWidth = false,
    DRButtonSize size = DRButtonSize.medium,
  }) : super(
          label: label,
          onPressed: onPressed,
          icon: icon,
          iconPosition: iconPosition,
          isLoading: isLoading,
          isFullWidth: isFullWidth,
          size: size,
          variant: DRButtonVariant.ghost,
        );
}

class DRButtonDestructive extends DRButton {
  DRButtonDestructive({
    super.key,
    required String label,
    VoidCallback? onPressed,
    IconData? icon,
    IconPosition iconPosition = IconPosition.left,
    bool isLoading = false,
    bool isFullWidth = false,
    DRButtonSize size = DRButtonSize.medium,
  }) : super(
          label: label,
          onPressed: onPressed,
          icon: icon,
          iconPosition: iconPosition,
          isLoading: isLoading,
          isFullWidth: isFullWidth,
          size: size,
          variant: DRButtonVariant.destructive,
        );
}
