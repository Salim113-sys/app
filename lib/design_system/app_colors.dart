import 'package:flutter/material.dart';

/// Daily Reset Color Design System
/// Premium Modern Minimal palette for Light + Dark themes

// ============================================================================
// LIGHT THEME COLORS
// ============================================================================

class LightColors {
  // Primary
  static const Color primary = Color(0xFF2D3436);
  static const Color primaryVariant = Color(0xFF636E72);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Accent (Success/Progress)
  static const Color accent = Color(0xFF00B894);
  static const Color accentVariant = Color(0xFF00A884);
  static const Color onAccent = Color(0xFFFFFFFF);

  // Secondary Accent (Info/Hydration)
  static const Color secondary = Color(0xFF74B9FF);
  static const Color onSecondary = Color(0xFF1A1D21);

  // Surfaces
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8F9FA);
  static const Color onSurface = Color(0xFF2D3436);
  static const Color onSurfaceVariant = Color(0xFF636E72);

  // Background
  static const Color background = Color(0xFFFAFBFC);
  static const Color onBackground = Color(0xFF1A1D21);

  // Outline & Dividers
  static const Color outline = Color(0xFFE1E4E8);
  static const Color outlineVariant = Color(0xFFF0F2F5);

  // Feedback Colors
  static const Color error = Color(0xFFE17055);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFE8E5);

  static const Color warning = Color(0xFFFDCB6E);
  static const Color onWarning = Color(0xFF5A4A00);

  static const Color success = Color(0xFF00B894);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color successContainer = Color(0xFFE0FFF5);

  // Special Purpose
  static const Color shadow = Color(0x0A000000); // 4% black
  static const Color overlay = Color(0x40000000); // 25% black
  static const Color disabled = Color(0xFFB0B3B8);

  // Legacy compatibility (map to new colors)
  static const Color lightPrimary = accent;
  static const Color lightSecondary = Color(0xFFFF6B6B);
}

// ============================================================================
// DARK THEME COLORS
// ============================================================================

class DarkColors {
  // Primary (inverted for dark mode - lighter)
  static const Color primary = Color(0xFFE8EAED);
  static const Color primaryVariant = Color(0xFFB0B3B8);
  static const Color onPrimary = Color(0xFF1A1D21);

  // Accent (Success/Progress) - slightly brighter for dark
  static const Color accent = Color(0xFF00D9A5);
  static const Color accentVariant = Color(0xFF00C896);
  static const Color onAccent = Color(0xFF003833);

  // Secondary Accent (Info/Hydration)
  static const Color secondary = Color(0xFF64B5F6);
  static const Color onSecondary = Color(0xFF00363D);

  // Surfaces
  static const Color surface = Color(0xFF1E2128);
  static const Color surfaceVariant = Color(0xFF282C34);
  static const Color onSurface = Color(0xFFE1E4E8);
  static const Color onSurfaceVariant = Color(0xFF9CA3AF);

  // Background
  static const Color background = Color(0xFF121418);
  static const Color onBackground = Color(0xFFE8EAED);

  // Outline & Dividers
  static const Color outline = Color(0xFF3A3F4B);
  static const Color outlineVariant = Color(0xFF2A2F3B);

  // Feedback Colors
  static const Color error = Color(0xFFFF8A80);
  static const Color onError = Color(0xFF5A1510);
  static const Color errorContainer = Color(0xFF8C2520);

  static const Color warning = Color(0xFFFFE082);
  static const Color onWarning = Color(0xFF5A4A00);

  static const Color success = Color(0xFF00D9A5);
  static const Color onSuccess = Color(0xFF003833);
  static const Color successContainer = Color(0xFF00574F);

  // Special Purpose
  static const Color shadow = Color(0x1A000000); // 10% black
  static const Color overlay = Color(0x66000000); // 40% black
  static const Color disabled = Color(0xFF4A4F5B);

  // Legacy compatibility
  static const Color darkPrimary = accent;
}

// ============================================================================
// SEMANTIC COLOR TOKENS
// ============================================================================

/// Semantic color tokens that adapt to theme
/// Use these in widgets via: AppColors.of(context).primary
class AppColors extends InheritedWidget {
  final AppColorTokens tokens;

  const AppColors({
    super.key,
    required this.tokens,
    required super.child,
  });

  static AppColorTokens of(BuildContext context) {
    final appColors = context.dependOnInheritedWidgetOfExactType<AppColors>();
    if (appColors != null) {
      return appColors.tokens;
    }
    // Fallback to Theme
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? AppColorTokens.fromDark()
        : AppColorTokens.fromLight();
  }

  @override
  bool updateShouldNotify(AppColors oldWidget) {
    return tokens != oldWidget.tokens;
  }
}

/// Color tokens for a specific theme
class AppColorTokens {
  final Color primary;
  final Color primaryVariant;
  final Color onPrimary;
  final Color accent;
  final Color onAccent;
  final Color secondary;
  final Color onSecondary;
  final Color surface;
  final Color surfaceVariant;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color background;
  final Color onBackground;
  final Color outline;
  final Color outlineVariant;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color warning;
  final Color onWarning;
  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color shadow;
  final Color overlay;
  final Color disabled;

  const AppColorTokens({
    required this.primary,
    required this.primaryVariant,
    required this.onPrimary,
    required this.accent,
    required this.onAccent,
    required this.secondary,
    required this.onSecondary,
    required this.surface,
    required this.surfaceVariant,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.background,
    required this.onBackground,
    required this.outline,
    required this.outlineVariant,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.warning,
    required this.onWarning,
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.shadow,
    required this.overlay,
    required this.disabled,
  });

  factory AppColorTokens.fromLight() => AppColorTokens(
        primary: LightColors.primary,
        primaryVariant: LightColors.primaryVariant,
        onPrimary: LightColors.onPrimary,
        accent: LightColors.accent,
        onAccent: LightColors.onAccent,
        secondary: LightColors.secondary,
        onSecondary: LightColors.onSecondary,
        surface: LightColors.surface,
        surfaceVariant: LightColors.surfaceVariant,
        onSurface: LightColors.onSurface,
        onSurfaceVariant: LightColors.onSurfaceVariant,
        background: LightColors.background,
        onBackground: LightColors.onBackground,
        outline: LightColors.outline,
        outlineVariant: LightColors.outlineVariant,
        error: LightColors.error,
        onError: LightColors.onError,
        errorContainer: LightColors.errorContainer,
        warning: LightColors.warning,
        onWarning: LightColors.onWarning,
        success: LightColors.success,
        onSuccess: LightColors.onSuccess,
        successContainer: LightColors.successContainer,
        shadow: LightColors.shadow,
        overlay: LightColors.overlay,
        disabled: LightColors.disabled,
      );

  factory AppColorTokens.fromDark() => AppColorTokens(
        primary: DarkColors.primary,
        primaryVariant: DarkColors.primaryVariant,
        onPrimary: DarkColors.onPrimary,
        accent: DarkColors.accent,
        onAccent: DarkColors.onAccent,
        secondary: DarkColors.secondary,
        onSecondary: DarkColors.onSecondary,
        surface: DarkColors.surface,
        surfaceVariant: DarkColors.surfaceVariant,
        onSurface: DarkColors.onSurface,
        onSurfaceVariant: DarkColors.onSurfaceVariant,
        background: DarkColors.background,
        onBackground: DarkColors.onBackground,
        outline: DarkColors.outline,
        outlineVariant: DarkColors.outlineVariant,
        error: DarkColors.error,
        onError: DarkColors.onError,
        errorContainer: DarkColors.errorContainer,
        warning: DarkColors.warning,
        onWarning: DarkColors.onWarning,
        success: DarkColors.success,
        onSuccess: DarkColors.onSuccess,
        successContainer: DarkColors.successContainer,
        shadow: DarkColors.shadow,
        overlay: DarkColors.overlay,
        disabled: DarkColors.disabled,
      );
}
