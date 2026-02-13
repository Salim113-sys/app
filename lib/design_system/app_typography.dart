import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Daily Reset Typography Design System
/// Inter font family with refined scale and letter spacing

/// Font size tokens following Material 3 scale with adjustments
class AppFontSizes {
  // Display
  static const double displayLarge = 40.0;
  static const double displayMedium = 32.0;
  static const double displaySmall = 28.0;

  // Headline
  static const double headlineLarge = 24.0;
  static const double headlineMedium = 20.0;
  static const double headlineSmall = 18.0;

  // Title
  static const double titleLarge = 16.0;
  static const double titleMedium = 14.0;
  static const double titleSmall = 13.0;

  // Body
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;

  // Label
  static const double labelLarge = 12.0;
  static const double labelMedium = 11.0;
  static const double labelSmall = 10.0;
}

/// Letter spacing tokens for different text styles
class AppLetterSpacing {
  static const double displayLarge = -0.5;
  static const double displayMedium = -0.3;
  static const double displaySmall = -0.2;
  static const double headlineLarge = -0.2;
  static const double headlineMedium = 0.0;
  static const double headlineSmall = 0.0;
  static const double titleLarge = 0.1;
  static const double titleMedium = 0.15;
  static const double titleSmall = 0.2;
  static const double bodyLarge = 0.2;
  static const double bodyMedium = 0.25;
  static const double bodySmall = 0.3;
  static const double labelLarge = 0.5;
  static const double labelMedium = 0.5;
  static const double labelSmall = 0.5;
}

/// Line height tokens (as multipliers)
class AppLineHeight {
  static const double tight = 1.2;
  static const double normal = 1.4;
  static const double relaxed = 1.6;
  static const double loose = 1.8;
}

/// Font weight tokens
class AppFontWeight {
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}

/// Builds the app text theme using Inter font family
TextTheme buildAppTextTheme({Brightness brightness = Brightness.light}) {
  // Check if we're in a test environment to avoid asset loading issues
  final binding = WidgetsBinding.instance;
  final isTestBinding = binding.runtimeType.toString().contains('Test');

  if (isTestBinding) {
    return ThemeData(brightness: brightness).textTheme;
  }

  return TextTheme(
    // Display styles - for hero numbers, large stats
    displayLarge: GoogleFonts.inter(
      fontSize: AppFontSizes.displayLarge,
      fontWeight: AppFontWeight.bold,
      letterSpacing: AppLetterSpacing.displayLarge,
      height: AppLineHeight.tight,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: AppFontSizes.displayMedium,
      fontWeight: AppFontWeight.semiBold,
      letterSpacing: AppLetterSpacing.displayMedium,
      height: AppLineHeight.tight,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: AppFontSizes.displaySmall,
      fontWeight: AppFontWeight.semiBold,
      letterSpacing: AppLetterSpacing.displaySmall,
      height: AppLineHeight.tight,
    ),

    // Headline styles - for screen titles, section headers
    headlineLarge: GoogleFonts.inter(
      fontSize: AppFontSizes.headlineLarge,
      fontWeight: AppFontWeight.semiBold,
      letterSpacing: AppLetterSpacing.headlineLarge,
      height: AppLineHeight.tight,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: AppFontSizes.headlineMedium,
      fontWeight: AppFontWeight.semiBold,
      letterSpacing: AppLetterSpacing.headlineMedium,
      height: AppLineHeight.normal,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: AppFontSizes.headlineSmall,
      fontWeight: AppFontWeight.semiBold,
      letterSpacing: AppLetterSpacing.headlineSmall,
      height: AppLineHeight.normal,
    ),

    // Title styles - for card titles, list item titles
    titleLarge: GoogleFonts.inter(
      fontSize: AppFontSizes.titleLarge,
      fontWeight: AppFontWeight.semiBold,
      letterSpacing: AppLetterSpacing.titleLarge,
      height: AppLineHeight.normal,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: AppFontSizes.titleMedium,
      fontWeight: AppFontWeight.medium,
      letterSpacing: AppLetterSpacing.titleMedium,
      height: AppLineHeight.normal,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: AppFontSizes.titleSmall,
      fontWeight: AppFontWeight.medium,
      letterSpacing: AppLetterSpacing.titleSmall,
      height: AppLineHeight.normal,
    ),

    // Body styles - for content text
    bodyLarge: GoogleFonts.inter(
      fontSize: AppFontSizes.bodyLarge,
      fontWeight: AppFontWeight.regular,
      letterSpacing: AppLetterSpacing.bodyLarge,
      height: AppLineHeight.relaxed,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: AppFontSizes.bodyMedium,
      fontWeight: AppFontWeight.regular,
      letterSpacing: AppLetterSpacing.bodyMedium,
      height: AppLineHeight.relaxed,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: AppFontSizes.bodySmall,
      fontWeight: AppFontWeight.regular,
      letterSpacing: AppLetterSpacing.bodySmall,
      height: AppLineHeight.relaxed,
    ),

    // Label styles - for buttons, badges, captions
    labelLarge: GoogleFonts.inter(
      fontSize: AppFontSizes.labelLarge,
      fontWeight: AppFontWeight.semiBold,
      letterSpacing: AppLetterSpacing.labelLarge,
      height: AppLineHeight.normal,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: AppFontSizes.labelMedium,
      fontWeight: AppFontWeight.medium,
      letterSpacing: AppLetterSpacing.labelMedium,
      height: AppLineHeight.normal,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: AppFontSizes.labelSmall,
      fontWeight: AppFontWeight.medium,
      letterSpacing: AppLetterSpacing.labelSmall,
      height: AppLineHeight.normal,
    ),
  );
}

/// Extension for easy access to text styles with color
extension TextStyleExtensions on TextStyle {
  /// Returns a copy of this style with the given color
  TextStyle withColor(Color color) => copyWith(color: color);

  /// Returns a copy of this style with bold weight
  TextStyle get bold => copyWith(fontWeight: AppFontWeight.bold);

  /// Returns a copy of this style with semi-bold weight
  TextStyle get semiBold => copyWith(fontWeight: AppFontWeight.semiBold);

  /// Returns a copy of this style with medium weight
  TextStyle get medium => copyWith(fontWeight: AppFontWeight.medium);

  /// Returns a copy of this style with regular weight
  TextStyle get regular => copyWith(fontWeight: AppFontWeight.regular);

  /// Returns a copy of this style with light weight
  TextStyle get light => copyWith(fontWeight: AppFontWeight.light);
}

/// Extension on BuildContext for easy text style access
extension TextThemeContext on BuildContext {
  /// Returns the TextTheme from the current Theme
  TextTheme get textStyles => Theme.of(this).textTheme;

  /// Shortcut for displayLarge
  TextStyle? get displayLarge => textStyles.displayLarge;

  /// Shortcut for displayMedium
  TextStyle? get displayMedium => textStyles.displayMedium;

  /// Shortcut for headlineLarge
  TextStyle? get headlineLarge => textStyles.headlineLarge;

  /// Shortcut for headlineMedium
  TextStyle? get headlineMedium => textStyles.headlineMedium;

  /// Shortcut for titleLarge
  TextStyle? get titleLarge => textStyles.titleLarge;

  /// Shortcut for titleMedium
  TextStyle? get titleMedium => textStyles.titleMedium;

  /// Shortcut for bodyLarge
  TextStyle? get bodyLarge => textStyles.bodyLarge;

  /// Shortcut for bodyMedium
  TextStyle? get bodyMedium => textStyles.bodyMedium;

  /// Shortcut for bodySmall
  TextStyle? get bodySmall => textStyles.bodySmall;

  /// Shortcut for labelLarge
  TextStyle? get labelLarge => textStyles.labelLarge;
}
