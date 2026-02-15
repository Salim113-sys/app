import 'package:flutter/material.dart';

// Export design tokens so existing imports keep working.
export 'design_system/app_spacing.dart';
export 'design_system/app_colors.dart';
// Export typography utilities, but hide extensions to avoid conflicts with legacy helpers below.
export 'design_system/app_typography.dart' hide TextStyleExtensions, TextThemeContext;

import 'design_system/app_theme.dart' as ds_theme;

/// ---------------------------------------------------------------------------
/// Compatibility layer:
/// Existing code imports `package:daily_reset/theme.dart`.
/// We keep the legacy API surface while delegating to the new design system.
/// ---------------------------------------------------------------------------

/// Theme getters expected by ThemeProvider
ThemeData get lightTheme => ds_theme.buildLightTheme();
ThemeData get darkTheme => ds_theme.buildDarkTheme();

/// Legacy theme variants:
/// For now we map them to the design-system light theme to keep the whole app consistent.
/// (We can add real variants later by parameterizing the DS theme builder.)
ThemeData get calmTheme => lightTheme;
ThemeData get sunriseTheme => lightTheme;
ThemeData get oceanTheme => lightTheme;

/// Legacy spacing class used heavily across screens/widgets.
///
/// NOTE: We now export AppSpacing from design_system/app_spacing.dart.
/// If old code relied on the *old numeric values*, the UI will change (intentionally),
/// but compilation will remain stable.

/// Legacy radius class used across screens/widgets.
///
/// NOTE: We now export AppRadius from design_system/app_spacing.dart.

/// Legacy extension: `context.textStyles`
extension TextStyleContext on BuildContext {
  TextTheme get textStyles => Theme.of(this).textTheme;

  // Optional convenience shortcuts (safe if any file uses them)
  TextStyle? get displayLarge => textStyles.displayLarge;
  TextStyle? get displayMedium => textStyles.displayMedium;
  TextStyle? get displaySmall => textStyles.displaySmall;

  TextStyle? get headlineLarge => textStyles.headlineLarge;
  TextStyle? get headlineMedium => textStyles.headlineMedium;
  TextStyle? get headlineSmall => textStyles.headlineSmall;

  TextStyle? get titleLarge => textStyles.titleLarge;
  TextStyle? get titleMedium => textStyles.titleMedium;
  TextStyle? get titleSmall => textStyles.titleSmall;

  TextStyle? get bodyLarge => textStyles.bodyLarge;
  TextStyle? get bodyMedium => textStyles.bodyMedium;
  TextStyle? get bodySmall => textStyles.bodySmall;

  TextStyle? get labelLarge => textStyles.labelLarge;
  TextStyle? get labelMedium => textStyles.labelMedium;
  TextStyle? get labelSmall => textStyles.labelSmall;
}

/// Legacy extension: `.bold`, `.semiBold`, `.medium`, `.withColor()`, `.withSize()`
extension TextStyleExtensions on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);

  /// Back-compat aliases (some codebases use these names)
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
  TextStyle get normal => copyWith(fontWeight: FontWeight.w400);

  TextStyle get light => copyWith(fontWeight: FontWeight.w300);

  TextStyle withColor(Color color) => copyWith(color: color);
  TextStyle withSize(double size) => copyWith(fontSize: size);
}
