import 'package:flutter/material.dart';
import '../../design_system/design_system.dart';

/// DRSectionHeader - Premium minimal section header component
///
/// Consistent section header styling following the Daily Reset design system.
/// Supports title, optional icon, and optional action button.
class DRSectionHeader extends StatelessWidget {
  const DRSectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.actionLabel,
    this.onActionPressed,
    this.padding,
    this.showDivider = false,
  });

  final String title;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final EdgeInsetsGeometry? padding;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    final titleColor = brightness == Brightness.light
        ? LightColors.onBackground
        : DarkColors.onBackground;

    final actionColor =
        brightness == Brightness.light ? LightColors.accent : DarkColors.accent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding ??
              const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
          child: Row(
            children: [
              // Icon
              if (icon != null) ...[
                Icon(
                  icon,
                  size: AppIconSize.lg,
                  color: titleColor,
                ),
                const SizedBox(width: AppSpacing.sm),
              ],

              // Title
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Action button
              if (actionLabel != null && onActionPressed != null)
                TextButton(
                  onPressed: onActionPressed,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    minimumSize: const Size(0, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    actionLabel!,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: actionColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (showDivider)
          Padding(
            padding: padding ?? AppSpacing.horizontalLg,
            child: Divider(
              color: brightness == Brightness.light
                  ? LightColors.outline
                  : DarkColors.outline,
              height: 1,
              thickness: 1,
            ),
          ),
      ],
    );
  }
}

/// DRSectionHeader with subtitle
class DRSectionHeaderWithSubtitle extends StatelessWidget {
  const DRSectionHeaderWithSubtitle({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.actionLabel,
    this.onActionPressed,
    this.padding,
    this.showDivider = false,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final EdgeInsetsGeometry? padding;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    final titleColor = brightness == Brightness.light
        ? LightColors.onBackground
        : DarkColors.onBackground;

    final subtitleColor = brightness == Brightness.light
        ? LightColors.onSurfaceVariant
        : DarkColors.onSurfaceVariant;

    final actionColor =
        brightness == Brightness.light ? LightColors.accent : DarkColors.accent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding ??
              const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              if (icon != null) ...[
                Icon(
                  icon,
                  size: AppIconSize.lg,
                  color: titleColor,
                ),
                const SizedBox(width: AppSpacing.sm),
              ],

              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: titleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Action button
              if (actionLabel != null && onActionPressed != null)
                TextButton(
                  onPressed: onActionPressed,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    minimumSize: const Size(0, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    actionLabel!,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: actionColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (showDivider)
          Padding(
            padding: padding ?? AppSpacing.horizontalLg,
            child: Divider(
              color: brightness == Brightness.light
                  ? LightColors.outline
                  : DarkColors.outline,
              height: 1,
              thickness: 1,
            ),
          ),
      ],
    );
  }
}

/// Simple section header for cards
class DRSectionHeaderSmall extends StatelessWidget {
  const DRSectionHeaderSmall({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionPressed,
    this.padding,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    final titleColor = brightness == Brightness.light
        ? LightColors.onSurface
        : DarkColors.onSurface;

    final actionColor =
        brightness == Brightness.light ? LightColors.accent : DarkColors.accent;

    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: titleColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (actionLabel != null && onActionPressed != null)
            TextButton(
              onPressed: onActionPressed,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 28),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                actionLabel!,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: actionColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
