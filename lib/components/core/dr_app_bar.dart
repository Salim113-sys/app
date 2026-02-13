// ignore_for_file: prefer_const_constructors_in_immutables, use_super_parameters

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/design_system.dart';

/// DRAppBar - Premium minimal app bar component
///
/// Consistent app bar styling following the Daily Reset design system.
/// Supports title, actions, back button, and close button variants.
class DRAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DRAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = false,
    this.showCloseButton = false,
    this.centerTitle = false,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.onBackPressed,
    this.bottom,
  });

  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final bool showCloseButton;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final VoidCallback? onBackPressed;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final canPop = GoRouter.of(context).canPop();

    final defaultBackgroundColor = backgroundColor ?? Colors.transparent;
    final defaultForegroundColor = foregroundColor ??
        (brightness == Brightness.light
            ? LightColors.onBackground
            : DarkColors.onBackground);

    Widget? leadingWidget;
    if (leading != null) {
      leadingWidget = leading;
    } else if (showCloseButton && canPop) {
      leadingWidget = IconButton(
        icon: Icon(Icons.close, color: defaultForegroundColor),
        onPressed: onBackPressed ?? () => context.pop(),
      );
    } else if (showBackButton && canPop) {
      leadingWidget = IconButton(
        icon: Icon(Icons.arrow_back, color: defaultForegroundColor),
        onPressed: onBackPressed ?? () => context.pop(),
      );
    }

    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.headlineSmall?.copyWith(
          color: defaultForegroundColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: actions,
      leading: leadingWidget,
      centerTitle: centerTitle,
      backgroundColor: defaultBackgroundColor,
      foregroundColor: defaultForegroundColor,
      elevation: elevation,
      scrolledUnderElevation: 0,
      bottom: bottom,
    );
  }
}

/// DRAppBar with back button preset
class DRAppBarWithBack extends DRAppBar {
  DRAppBarWithBack({
    super.key,
    required String title,
    List<Widget>? actions,
    bool centerTitle = false,
    Color? backgroundColor,
    Color? foregroundColor,
    VoidCallback? onBackPressed,
    PreferredSizeWidget? bottom,
  }) : super(
          title: title,
          actions: actions,
          showBackButton: true,
          centerTitle: centerTitle,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          onBackPressed: onBackPressed,
          bottom: bottom,
        );
}

/// DRAppBar with close button preset (for modal screens)
class DRAppBarWithClose extends DRAppBar {
  DRAppBarWithClose({
    super.key,
    required String title,
    List<Widget>? actions,
    bool centerTitle = false,
    Color? backgroundColor,
    Color? foregroundColor,
    VoidCallback? onBackPressed,
    PreferredSizeWidget? bottom,
  }) : super(
          title: title,
          actions: actions,
          showCloseButton: true,
          centerTitle: centerTitle,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          onBackPressed: onBackPressed,
          bottom: bottom,
        );
}

/// Simple app bar for settings/sub-pages
class DRAppBarSimple extends StatelessWidget implements PreferredSizeWidget {
  const DRAppBarSimple({
    super.key,
    required this.title,
    this.showBack = true,
  });

  final String title;
  final bool showBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final fgColor = brightness == Brightness.light
        ? LightColors.onBackground
        : DarkColors.onBackground;

    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.headlineSmall?.copyWith(
          color: fgColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.transparent,
      foregroundColor: fgColor,
      elevation: 0,
      leading: showBack && GoRouter.of(context).canPop()
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: fgColor),
              onPressed: () => context.pop(),
            )
          : null,
    );
  }
}
