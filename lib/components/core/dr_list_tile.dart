// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import '../../design_system/design_system.dart';

/// DRListTile - Premium minimal list tile component
///
/// Consistent list tile styling following the Daily Reset design system.
/// Supports leading icon, title, subtitle, trailing widget, and onTap.
class DRListTile extends StatelessWidget {
  const DRListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.isEnabled = true,
    this.isDestructive = false,
    this.showChevron = false,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isEnabled;
  final bool isDestructive;
  final bool showChevron;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    final defaultPadding = padding ?? AppSpacing.listItem;
    final defaultBorderRadius = borderRadius ?? AppRadius.lgR;

    // Determine text colors
    Color titleColor;
    Color? subtitleColor;

    if (!isEnabled) {
      titleColor = brightness == Brightness.light
          ? LightColors.disabled
          : DarkColors.disabled;
      subtitleColor = titleColor;
    } else if (isDestructive) {
      titleColor =
          brightness == Brightness.light ? LightColors.error : DarkColors.error;
      subtitleColor = titleColor.withValues(alpha: 0.7);
    } else {
      titleColor = brightness == Brightness.light
          ? LightColors.onSurface
          : DarkColors.onSurface;
      subtitleColor = brightness == Brightness.light
          ? LightColors.onSurfaceVariant
          : DarkColors.onSurfaceVariant;
    }

    Widget content = Padding(
      padding: defaultPadding,
      child: Row(
        children: [
          // Leading widget
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppSpacing.md),
          ],

          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w500,
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

          // Trailing widget
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.sm),
            trailing!,
          ],

          // Chevron indicator
          if (showChevron && onTap != null) ...[
            const SizedBox(width: AppSpacing.sm),
            Icon(
              Icons.chevron_right,
              size: AppIconSize.xl,
              color: brightness == Brightness.light
                  ? LightColors.onSurfaceVariant
                  : DarkColors.onSurfaceVariant,
            ),
          ],
        ],
      ),
    );

    // Wrap with inkwell if onTap is provided
    if (onTap != null || onLongPress != null) {
      content = InkWell(
        onTap: isEnabled ? onTap : null,
        onLongPress: isEnabled ? onLongPress : null,
        borderRadius: defaultBorderRadius,
        child: content,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: defaultBorderRadius,
      ),
      child: content,
    );
  }
}

/// DRListTile with icon leading
class DRListTileIcon extends DRListTile {
  DRListTileIcon({
    super.key,
    required String title,
    String? subtitle,
    required IconData icon,
    Widget? trailing,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    bool isEnabled = true,
    bool isDestructive = false,
    bool showChevron = false,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Color? iconColor,
    BorderRadius? borderRadius,
  }) : super(
          title: title,
          subtitle: subtitle,
          leading: _buildIcon(icon, isDestructive, iconColor),
          trailing: trailing,
          onTap: onTap,
          onLongPress: onLongPress,
          isEnabled: isEnabled,
          isDestructive: isDestructive,
          showChevron: showChevron,
          padding: padding,
          backgroundColor: backgroundColor,
          borderRadius: borderRadius,
        );

  static Widget _buildIcon(
      IconData icon, bool isDestructive, Color? iconColor) {
    return Builder(
      builder: (context) {
        final brightness = Theme.of(context).brightness;
        final color = iconColor ??
            (isDestructive
                ? (brightness == Brightness.light
                    ? LightColors.error
                    : DarkColors.error)
                : (brightness == Brightness.light
                    ? LightColors.accent
                    : DarkColors.accent));
        return Icon(icon, size: AppIconSize.xl, color: color);
      },
    );
  }
}

/// DRListTile with switch trailing
class DRListTileSwitch extends StatelessWidget {
  const DRListTileSwitch({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    required this.value,
    required this.onChanged,
    this.isEnabled = true,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool isEnabled;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return DRListTile(
      title: title,
      subtitle: subtitle,
      leading: leading,
      padding: padding,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      isEnabled: isEnabled,
      onTap: isEnabled && onChanged != null ? () => onChanged!(!value) : null,
      trailing: Switch(
        value: value,
        onChanged: isEnabled ? onChanged : null,
      ),
    );
  }
}
