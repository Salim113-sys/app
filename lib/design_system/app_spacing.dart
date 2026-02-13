import 'package:flutter/material.dart';

/// Daily Reset Spacing Design System
/// Consistent spacing, radius, and elevation tokens

// ============================================================================
// SPACING TOKENS
// ============================================================================

/// Spacing scale following 4-point grid system
class AppSpacing {
  // Base units
  static const double unit = 4.0;

  // Named spacing values
  static const double none = 0.0;
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double section = 40.0;
  static const double page = 48.0;

  // Component-specific spacing
  static const double cardPadding = 16.0;
  static const double cardPaddingLarge = 20.0;
  static const double listItemGap = 12.0;
  static const double inlineGap = 8.0;
  static const double buttonPadding = 16.0;
  static const double inputPadding = 16.0;
  static const double screenPadding = 16.0;
  static const double screenPaddingLarge = 24.0;

  // Pre-built EdgeInsets for common use cases
  static const EdgeInsets paddingNone = EdgeInsets.zero;
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);
  static const EdgeInsets paddingXxl = EdgeInsets.all(xxl);
  static const EdgeInsets paddingXxxl = EdgeInsets.all(xxxl);

  // Horizontal padding
  static const EdgeInsets horizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets horizontalXxl = EdgeInsets.symmetric(horizontal: xxl);

  // Vertical padding
  static const EdgeInsets verticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: xl);
  static const EdgeInsets verticalXxl = EdgeInsets.symmetric(vertical: xxl);

  // Screen padding
  static const EdgeInsets screenHorizontal =
      EdgeInsets.symmetric(horizontal: screenPadding);
  static const EdgeInsets screenAll = EdgeInsets.all(screenPadding);
  static const EdgeInsets screenAllLarge = EdgeInsets.all(screenPaddingLarge);

  // Card padding
  static const EdgeInsets cardAll = EdgeInsets.all(cardPadding);
  static const EdgeInsets cardAllLarge = EdgeInsets.all(cardPaddingLarge);

  // Button padding
  static const EdgeInsets buttonHorizontal = EdgeInsets.symmetric(
    horizontal: buttonPadding,
    vertical: buttonPadding * 0.75,
  );
  static const EdgeInsets buttonLarge = EdgeInsets.symmetric(
    horizontal: buttonPadding * 2,
    vertical: buttonPadding,
  );

  // Input padding
  static const EdgeInsets inputContent = EdgeInsets.symmetric(
    horizontal: inputPadding,
    vertical: inputPadding,
  );

  // List item padding
  static const EdgeInsets listItem = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );
  static const EdgeInsets listItemDense = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );
}

// ============================================================================
// BORDER RADIUS TOKENS
// ============================================================================

/// Border radius scale for consistent rounded corners
class AppRadius {
  static const double none = 0.0;
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 6.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double xxl = 20.0;
  static const double xxxl = 24.0;
  static const double round = 28.0;
  static const double full = 9999.0;

  // Pre-built BorderRadius for common use cases
  static BorderRadius get noneR => BorderRadius.circular(none);
  static BorderRadius get xsR => BorderRadius.circular(xs);
  static BorderRadius get smR => BorderRadius.circular(sm);
  static BorderRadius get mdR => BorderRadius.circular(md);
  static BorderRadius get lgR => BorderRadius.circular(lg);
  static BorderRadius get xlR => BorderRadius.circular(xl);
  static BorderRadius get xxlR => BorderRadius.circular(xxl);
  static BorderRadius get xxxlR => BorderRadius.circular(xxxl);
  static BorderRadius get roundR => BorderRadius.circular(round);
  static BorderRadius get fullR => BorderRadius.circular(full);

  // Component-specific radii
  static BorderRadius get button => BorderRadius.circular(lg);
  static BorderRadius get card => BorderRadius.circular(xl);
  static BorderRadius get cardLarge => BorderRadius.circular(xxl);
  static BorderRadius get input => BorderRadius.circular(lg);
  static BorderRadius get chip => BorderRadius.circular(full);
  static BorderRadius get dialog => BorderRadius.circular(xxl);
  static BorderRadius get bottomSheet =>
      BorderRadius.vertical(top: Radius.circular(xxl));
  static BorderRadius get iconButton => BorderRadius.circular(round);
}

// ============================================================================
// ELEVATION / SHADOW TOKENS
// ============================================================================

/// Elevation levels following Material 3 with premium minimal adjustments
class AppElevation {
  static const double none = 0.0;
  static const double xs = 1.0;
  static const double sm = 2.0;
  static const double md = 4.0;
  static const double lg = 8.0;
  static const double xl = 12.0;
  static const double xxl = 16.0;
  static const double xxxl = 24.0;
}

/// Pre-built box shadows for light theme
class AppShadows {
  // Light theme shadows (subtle, minimal)
  static List<BoxShadow> lightNone = [];

  static List<BoxShadow> lightXs = [
    BoxShadow(
      color: const Color(0x0A000000), // 4% black
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> lightSm = [
    BoxShadow(
      color: const Color(0x0A000000), // 4% black
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> lightMd = [
    BoxShadow(
      color: const Color(0x0F000000), // 6% black
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> lightLg = [
    BoxShadow(
      color: const Color(0x14000000), // 8% black
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> lightXl = [
    BoxShadow(
      color: const Color(0x1A000000), // 10% black
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  // Dark theme shadows (more visible with subtle glow)
  static List<BoxShadow> darkNone = [];

  static List<BoxShadow> darkXs = [
    BoxShadow(
      color: const Color(0x1A000000), // 10% black
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> darkSm = [
    BoxShadow(
      color: const Color(0x1A000000),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> darkMd = [
    BoxShadow(
      color: const Color(0x24000000), // 14% black
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> darkLg = [
    BoxShadow(
      color: const Color(0x30000000), // 19% black
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> darkXl = [
    BoxShadow(
      color: const Color(0x40000000), // 25% black
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  // Helper to get shadows by brightness
  static List<BoxShadow> forBrightness(
      Brightness brightness, double elevation) {
    final isDark = brightness == Brightness.dark;

    if (elevation <= AppElevation.none) {
      return isDark ? darkNone : lightNone;
    } else if (elevation <= AppElevation.xs) {
      return isDark ? darkXs : lightXs;
    } else if (elevation <= AppElevation.sm) {
      return isDark ? darkSm : lightSm;
    } else if (elevation <= AppElevation.md) {
      return isDark ? darkMd : lightMd;
    } else if (elevation <= AppElevation.lg) {
      return isDark ? darkLg : lightLg;
    } else {
      return isDark ? darkXl : lightXl;
    }
  }
}

// ============================================================================
// ANIMATION DURATION TOKENS
// ============================================================================

/// Animation duration tokens for consistent motion
class AppDuration {
  static const Duration instant = Duration(milliseconds: 0);
  static const Duration fastest = Duration(milliseconds: 50);
  static const Duration fast = Duration(milliseconds: 100);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 300);
  static const Duration slower = Duration(milliseconds: 400);
  static const Duration slowest = Duration(milliseconds: 500);
  static const Duration pageTransition = Duration(milliseconds: 350);
  static const Duration typing = Duration(milliseconds: 1000);
}

/// Animation curves for consistent motion feel
class AppCurves {
  static const Curve standard = Curves.easeInOut;
  static const Curve enter = Curves.easeOut;
  static const Curve exit = Curves.easeIn;
  static const Curve bounce = Curves.elasticOut;
  static const Curve smooth = Curves.easeInOutCubic;
  static const Curve emphasize = Cubic(0.2, 0.0, 0.0, 1.0);
  static const Curve decelerate = Cubic(0.0, 0.0, 0.0, 1.0);
  static const Curve accelerate = Cubic(0.4, 0.0, 1.0, 1.0);
}

// ============================================================================
// BORDER TOKENS
// ============================================================================

/// Pre-built border styles
class AppBorders {
  /// Standard outline border
  static Border outline(Color color, {double width = 1.0}) {
    return Border.all(color: color, width: width);
  }

  /// Bottom border only (for list dividers)
  static Border bottom(Color color, {double width = 1.0}) {
    return Border(bottom: BorderSide(color: color, width: width));
  }

  /// Standard card border
  static BoxBorder cardBorder(Color color) {
    return Border.all(color: color, width: 1.0);
  }
}

/// Divider heights and styles
class AppDivider {
  static const double height = 1.0;
  static const double indent = 16.0;
  static const double thickHeight = 2.0;
}

// ============================================================================
// ICON SIZE TOKENS
// ============================================================================

/// Standard icon sizes
class AppIconSize {
  static const double xxs = 12.0;
  static const double xs = 14.0;
  static const double sm = 16.0;
  static const double md = 18.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 28.0;
  static const double xxxl = 32.0;
  static const double huge = 40.0;
  static const double display = 48.0;
  static const double hero = 64.0;
}
