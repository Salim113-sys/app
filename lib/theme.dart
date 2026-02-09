import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  static const EdgeInsets horizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: xl);

  static const EdgeInsets verticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: xl);
}

class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
}

extension TextStyleContext on BuildContext {
  TextTheme get textStyles => Theme.of(this).textTheme;
}

extension TextStyleExtensions on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get normal => copyWith(fontWeight: FontWeight.w400);
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
  TextStyle withColor(Color color) => copyWith(color: color);
  TextStyle withSize(double size) => copyWith(fontSize: size);
}

// Colors
class LightModeColors {
  static const lightPrimary = Color(0xFF4ECDC4);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightPrimaryContainer = Color(0xFFE0F7F5);
  static const lightOnPrimaryContainer = Color(0xFF003833);
  static const lightSecondary = Color(0xFFFF6B6B);
  static const lightOnSecondary = Color(0xFFFFFFFF);
  static const lightTertiary = Color(0xFF95E1D3);
  static const lightOnTertiary = Color(0xFF003833);
  static const lightError = Color(0xFFE74C3C);
  static const lightOnError = Color(0xFFFFFFFF);
  static const lightErrorContainer = Color(0xFFFFE8E5);
  static const lightOnErrorContainer = Color(0xFF5A1510);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightOnSurface = Color(0xFF1A1A1A);
  static const lightBackground = Color(0xFFFAFAF9);
  static const lightSurfaceVariant = Color(0xFFF5F5F4);
  static const lightOnSurfaceVariant = Color(0xFF52525B);
  static const lightOutline = Color(0xFFD4D4D8);
  static const lightShadow = Color(0xFF000000);
  static const lightInversePrimary = Color(0xFF80E5DE);
}

class DarkModeColors {
  static const darkPrimary = Color(0xFF80E5DE);
  static const darkOnPrimary = Color(0xFF003833);
  static const darkPrimaryContainer = Color(0xFF00574F);
  static const darkOnPrimaryContainer = Color(0xFFE0F7F5);
  static const darkSecondary = Color(0xFFFF8A80);
  static const darkOnSecondary = Color(0xFF4A1410);
  static const darkTertiary = Color(0xFFB0F4E8);
  static const darkOnTertiary = Color(0xFF003833);
  static const darkError = Color(0xFFFF8A80);
  static const darkOnError = Color(0xFF5A1510);
  static const darkErrorContainer = Color(0xFF8C2520);
  static const darkOnErrorContainer = Color(0xFFFFE8E5);
  static const darkSurface = Color(0xFF1A1F2E);
  static const darkOnSurface = Color(0xFFE8E8E8);
  static const darkSurfaceVariant = Color(0xFF2A3140);
  static const darkOnSurfaceVariant = Color(0xFFC4C7CF);
  static const darkOutline = Color(0xFF52525B);
  static const darkShadow = Color(0xFF000000);
  static const darkInversePrimary = Color(0xFF4ECDC4);
}

class CalmModeColors {
  static const calmPrimary = Color(0xFF7FA99B);
  static const calmOnPrimary = Color(0xFFFFFFFF);
  static const calmPrimaryContainer = Color(0xFFE5F4F1);
  static const calmOnPrimaryContainer = Color(0xFF2D443E);
  static const calmSecondary = Color(0xFFDCC7AA);
  static const calmOnSecondary = Color(0xFF4A3B2A);
  static const calmTertiary = Color(0xFFA6B1E1);
  static const calmOnTertiary = Color(0xFF2B3A67);
  static const calmError = Color(0xFFE57373);
  static const calmOnError = Color(0xFFFFFFFF);
  static const calmErrorContainer = Color(0xFFFFEBEE);
  static const calmOnErrorContainer = Color(0xFF9E2A2B);
  static const calmSurface = Color(0xFFFDFBF7);
  static const calmOnSurface = Color(0xFF4A4A4A);
  static const calmBackground = Color(0xFFFDFBF7);
  static const calmSurfaceVariant = Color(0xFFF2EFE9);
  static const calmOnSurfaceVariant = Color(0xFF7D7873);
  static const calmOutline = Color(0xFFA69F96);
  static const calmShadow = Color(0xFF8D8376);
  static const calmInversePrimary = Color(0xFF5C8A7C);
}

ThemeData get lightTheme => _buildThemeData(
  brightness: Brightness.light,
  primary: LightModeColors.lightPrimary,
  onPrimary: LightModeColors.lightOnPrimary,
  primaryContainer: LightModeColors.lightPrimaryContainer,
  onPrimaryContainer: LightModeColors.lightOnPrimaryContainer,
  secondary: LightModeColors.lightSecondary,
  onSecondary: LightModeColors.lightOnSecondary,
  tertiary: LightModeColors.lightTertiary,
  onTertiary: LightModeColors.lightOnTertiary,
  error: LightModeColors.lightError,
  onError: LightModeColors.lightOnError,
  surface: LightModeColors.lightSurface,
  surfaceVariant: LightModeColors.lightSurfaceVariant,
  onSurface: LightModeColors.lightOnSurface,
  onSurfaceVariant: LightModeColors.lightOnSurfaceVariant,
  background: LightModeColors.lightBackground,
);

ThemeData get darkTheme => _buildThemeData(
  brightness: Brightness.dark,
  primary: DarkModeColors.darkPrimary,
  onPrimary: DarkModeColors.darkOnPrimary,
  primaryContainer: DarkModeColors.darkPrimaryContainer,
  onPrimaryContainer: DarkModeColors.darkOnPrimaryContainer,
  secondary: DarkModeColors.darkSecondary,
  onSecondary: DarkModeColors.darkOnSecondary,
  tertiary: DarkModeColors.darkTertiary,
  onTertiary: DarkModeColors.darkOnTertiary,
  error: DarkModeColors.darkError,
  onError: DarkModeColors.darkOnError,
  surface: DarkModeColors.darkSurface,
  surfaceVariant: DarkModeColors.darkSurfaceVariant,
  onSurface: DarkModeColors.darkOnSurface,
  onSurfaceVariant: DarkModeColors.darkOnSurfaceVariant,
  background: DarkModeColors.darkSurface,
);

ThemeData get calmTheme => _buildThemeData(
  brightness: Brightness.light,
  primary: CalmModeColors.calmPrimary,
  onPrimary: CalmModeColors.calmOnPrimary,
  primaryContainer: CalmModeColors.calmPrimaryContainer,
  onPrimaryContainer: CalmModeColors.calmOnPrimaryContainer,
  secondary: CalmModeColors.calmSecondary,
  onSecondary: CalmModeColors.calmOnSecondary,
  tertiary: CalmModeColors.calmTertiary,
  onTertiary: CalmModeColors.calmOnTertiary,
  error: CalmModeColors.calmError,
  onError: CalmModeColors.calmOnError,
  surface: CalmModeColors.calmSurface,
  surfaceVariant: CalmModeColors.calmSurfaceVariant,
  onSurface: CalmModeColors.calmOnSurface,
  onSurfaceVariant: CalmModeColors.calmOnSurfaceVariant,
  background: CalmModeColors.calmBackground,
);

ThemeData get sunriseTheme => _buildThemeData(
  brightness: Brightness.light,
  primary: const Color(0xFFFF9F7F),
  onPrimary: Colors.white,
  primaryContainer: const Color(0xFFFFF0E5),
  onPrimaryContainer: const Color(0xFF5A1A00),
  secondary: const Color(0xFFFFD166),
  onSecondary: const Color(0xFF4A3B00),
  tertiary: const Color(0xFFFF70A6),
  onTertiary: Colors.white,
  background: const Color(0xFFFFF9F5),
  surface: const Color(0xFFFFF9F5),
  surfaceVariant: const Color(0xFFFDEEE9),
  onSurface: const Color(0xFF4A2B20),
  onSurfaceVariant: const Color(0xFF8D6E63),
  error: const Color(0xFFBA1A1A),
  onError: Colors.white,
);

ThemeData get oceanTheme => _buildThemeData(
  brightness: Brightness.light,
  primary: const Color(0xFF00B4D8),
  onPrimary: Colors.white,
  primaryContainer: const Color(0xFFE0F7FA),
  onPrimaryContainer: const Color(0xFF00363D),
  secondary: const Color(0xFF48CAE4),
  onSecondary: Colors.white,
  tertiary: const Color(0xFF90E0EF),
  onTertiary: const Color(0xFF00363D),
  background: const Color(0xFFF0F9FA),
  surface: const Color(0xFFF0F9FA),
  surfaceVariant: const Color(0xFFE1F5FE),
  onSurface: const Color(0xFF00363D),
  onSurfaceVariant: const Color(0xFF455A64),
  error: const Color(0xFFBA1A1A),
  onError: Colors.white,
);


ThemeData _buildThemeData({
  required Brightness brightness,
  required Color primary,
  required Color onPrimary,
  required Color primaryContainer,
  required Color onPrimaryContainer,
  required Color secondary,
  required Color onSecondary,
  required Color tertiary,
  required Color onTertiary,
  required Color background,
  required Color surface,
  required Color surfaceVariant,
  required Color onSurface,
  required Color onSurfaceVariant,
  required Color error,
  required Color onError,
}) {
  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: primaryContainer,
    onPrimaryContainer: onPrimaryContainer,
    secondary: secondary,
    onSecondary: onSecondary,
    tertiary: tertiary,
    onTertiary: onTertiary,
    error: error,
    onError: onError,
    surface: surface,
    onSurface: onSurface,
    surfaceContainerHighest: surfaceVariant,
    onSurfaceVariant: onSurfaceVariant,
    outline: onSurfaceVariant.withValues(alpha: 0.5),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: background,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: surface, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3), width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: primary,
        foregroundColor: onPrimary,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: BorderSide(color: primary, width: 1.5),
        foregroundColor: primary,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          foregroundColor: primary,
        ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceVariant,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: primary, width: 2)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    textTheme: _buildTextTheme(brightness),
  );
}

class FontSizes {
  static const double displayLarge = 57.0;
  static const double displayMedium = 45.0;
  static const double displaySmall = 36.0;
  static const double headlineLarge = 32.0;
  static const double headlineMedium = 28.0;
  static const double headlineSmall = 24.0;
  static const double titleLarge = 22.0;
  static const double titleMedium = 16.0;
  static const double titleSmall = 14.0;
  static const double labelLarge = 14.0;
  static const double labelMedium = 12.0;
  static const double labelSmall = 11.0;
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
}

TextTheme _buildTextTheme(Brightness brightness) {
  // Integration/widget test bindings do not always provide a full asset bundle.
  // Fallback to default text theme there to avoid async google_fonts asset errors.
  final binding = WidgetsBinding.instance;
  final isTestBinding = binding.runtimeType.toString().contains('Test');
  if (isTestBinding) {
    return ThemeData(brightness: brightness).textTheme;
  }

  return TextTheme(
    displayLarge: GoogleFonts.inter(fontSize: FontSizes.displayLarge, fontWeight: FontWeight.w400, letterSpacing: -0.25),
    displayMedium: GoogleFonts.inter(fontSize: FontSizes.displayMedium, fontWeight: FontWeight.w400),
    displaySmall: GoogleFonts.inter(fontSize: FontSizes.displaySmall, fontWeight: FontWeight.w400),
    headlineLarge: GoogleFonts.inter(fontSize: FontSizes.headlineLarge, fontWeight: FontWeight.w600, letterSpacing: -0.5),
    headlineMedium: GoogleFonts.inter(fontSize: FontSizes.headlineMedium, fontWeight: FontWeight.w600),
    headlineSmall: GoogleFonts.inter(fontSize: FontSizes.headlineSmall, fontWeight: FontWeight.w600),
    titleLarge: GoogleFonts.inter(fontSize: FontSizes.titleLarge, fontWeight: FontWeight.w600),
    titleMedium: GoogleFonts.inter(fontSize: FontSizes.titleMedium, fontWeight: FontWeight.w500),
    titleSmall: GoogleFonts.inter(fontSize: FontSizes.titleSmall, fontWeight: FontWeight.w500),
    labelLarge: GoogleFonts.inter(fontSize: FontSizes.labelLarge, fontWeight: FontWeight.w500, letterSpacing: 0.1),
    labelMedium: GoogleFonts.inter(fontSize: FontSizes.labelMedium, fontWeight: FontWeight.w500, letterSpacing: 0.5),
    labelSmall: GoogleFonts.inter(fontSize: FontSizes.labelSmall, fontWeight: FontWeight.w500, letterSpacing: 0.5),
    bodyLarge: GoogleFonts.inter(fontSize: FontSizes.bodyLarge, fontWeight: FontWeight.w400, letterSpacing: 0.15),
    bodyMedium: GoogleFonts.inter(fontSize: FontSizes.bodyMedium, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    bodySmall: GoogleFonts.inter(fontSize: FontSizes.bodySmall, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  );
}
