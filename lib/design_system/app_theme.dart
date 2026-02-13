import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

/// Daily Reset App Theme
/// Premium Modern Minimal theme assembly

/// Builds the light theme with new design tokens
ThemeData buildLightTheme() {
  final colorScheme = ColorScheme(
    brightness: Brightness.light,
    // Primary (using accent as primary for brand consistency)
    primary: LightColors.accent,
    onPrimary: LightColors.onAccent,
    primaryContainer: LightColors.successContainer,
    onPrimaryContainer: LightColors.onBackground,
    // Secondary
    secondary: LightColors.secondary,
    onSecondary: LightColors.onSecondary,
    secondaryContainer: LightColors.secondary.withValues(alpha: 0.15),
    onSecondaryContainer: LightColors.onSecondary,
    // Tertiary (for accent variation)
    tertiary: LightColors.primary,
    onTertiary: LightColors.onPrimary,
    // Error
    error: LightColors.error,
    onError: LightColors.onError,
    errorContainer: LightColors.errorContainer,
    onErrorContainer: LightColors.error,
    // Surfaces
    surface: LightColors.surface,
    onSurface: LightColors.onSurface,
    surfaceContainerHighest: LightColors.surfaceVariant,
    onSurfaceVariant: LightColors.onSurfaceVariant,
    // Outline
    outline: LightColors.outline,
    outlineVariant: LightColors.outlineVariant,
    // Shadow
    shadow: LightColors.shadow,
    // Inverse
    inverseSurface: DarkColors.surface,
    onInverseSurface: DarkColors.onSurface,
    inversePrimary: DarkColors.accent,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: LightColors.background,
    textTheme: buildAppTextTheme(brightness: Brightness.light),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: LightColors.onBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleSpacing: AppSpacing.lg,
      titleTextStyle: buildAppTextTheme().headlineSmall?.copyWith(
            color: LightColors.onBackground,
            fontWeight: FontWeight.w600,
          ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 0,
      color: LightColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.card,
        side: BorderSide(
          color: LightColors.outline.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      margin: EdgeInsets.zero,
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: LightColors.accent,
        foregroundColor: LightColors.onAccent,
        disabledBackgroundColor: LightColors.disabled.withValues(alpha: 0.3),
        disabledForegroundColor: LightColors.disabled,
        padding: AppSpacing.buttonHorizontal,
        minimumSize: const Size(88, 48),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.button,
        ),
        textStyle: buildAppTextTheme().labelLarge,
      ),
    ),

    // Filled Button Theme
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: LightColors.accent,
        foregroundColor: LightColors.onAccent,
        disabledBackgroundColor: LightColors.disabled.withValues(alpha: 0.3),
        disabledForegroundColor: LightColors.disabled,
        padding: AppSpacing.buttonHorizontal,
        minimumSize: const Size(88, 48),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.button,
        ),
        textStyle: buildAppTextTheme().labelLarge,
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: LightColors.accent,
        disabledForegroundColor: LightColors.disabled,
        padding: AppSpacing.buttonHorizontal,
        minimumSize: const Size(88, 48),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.button,
        ),
        side: BorderSide(
          color: LightColors.accent,
          width: 1.5,
        ),
        textStyle: buildAppTextTheme().labelLarge,
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: LightColors.accent,
        disabledForegroundColor: LightColors.disabled,
        padding: AppSpacing.buttonHorizontal,
        minimumSize: const Size(88, 48),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.button,
        ),
        textStyle: buildAppTextTheme().labelLarge,
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: LightColors.surfaceVariant,
      contentPadding: AppSpacing.inputContent,
      border: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide(
          color: LightColors.accent,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide(
          color: LightColors.error,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide(
          color: LightColors.error,
          width: 2,
        ),
      ),
      labelStyle: buildAppTextTheme()
          .bodyMedium
          ?.copyWith(color: LightColors.onSurfaceVariant),
      hintStyle: buildAppTextTheme()
          .bodyMedium
          ?.copyWith(color: LightColors.onSurfaceVariant),
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return LightColors.accent;
        }
        return LightColors.onSurfaceVariant;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return LightColors.accent.withValues(alpha: 0.5);
        }
        return LightColors.outline;
      }),
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return LightColors.accent;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(LightColors.onAccent),
      side: BorderSide(
        color: LightColors.outline,
        width: 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: LightColors.accent,
      foregroundColor: LightColors.onAccent,
      elevation: AppElevation.md,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.iconButton,
      ),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: LightColors.surfaceVariant,
      selectedColor: LightColors.accent.withValues(alpha: 0.15),
      disabledColor: LightColors.disabled.withValues(alpha: 0.2),
      labelStyle: buildAppTextTheme().labelLarge,
      secondaryLabelStyle: buildAppTextTheme().labelLarge?.copyWith(
            color: LightColors.accent,
          ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.chip,
      ),
      side: BorderSide.none,
    ),

    // Navigation Bar Theme
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: LightColors.surface,
      indicatorColor: LightColors.accent.withValues(alpha: 0.15),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return buildAppTextTheme().labelMedium!.copyWith(
                color: LightColors.accent,
                fontWeight: FontWeight.w600,
              );
        }
        return buildAppTextTheme().labelMedium!.copyWith(
              color: LightColors.onSurfaceVariant,
            );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: LightColors.accent);
        }
        return IconThemeData(color: LightColors.onSurfaceVariant);
      }),
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: LightColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.dialog,
      ),
      titleTextStyle: buildAppTextTheme().headlineSmall?.copyWith(
            color: LightColors.onSurface,
          ),
      contentTextStyle: buildAppTextTheme().bodyMedium?.copyWith(
            color: LightColors.onSurfaceVariant,
          ),
    ),

    // SnackBar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: LightColors.primary,
      contentTextStyle: buildAppTextTheme().bodyMedium?.copyWith(
            color: LightColors.onPrimary,
          ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lgR,
      ),
      behavior: SnackBarBehavior.floating,
    ),

    // Bottom Sheet Theme
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: LightColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.bottomSheet,
      ),
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: LightColors.outline,
      thickness: AppDivider.height,
      space: AppSpacing.lg,
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: LightColors.accent,
      linearTrackColor: LightColors.surfaceVariant,
      circularTrackColor: LightColors.surfaceVariant,
    ),

    // List Tile Theme
    listTileTheme: ListTileThemeData(
      contentPadding: AppSpacing.listItem,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lgR,
      ),
    ),
  );
}

/// Builds the dark theme with new design tokens
ThemeData buildDarkTheme() {
  final colorScheme = ColorScheme(
    brightness: Brightness.dark,
    // Primary
    primary: DarkColors.accent,
    onPrimary: DarkColors.onAccent,
    primaryContainer: DarkColors.successContainer,
    onPrimaryContainer: DarkColors.onBackground,
    // Secondary
    secondary: DarkColors.secondary,
    onSecondary: DarkColors.onSecondary,
    secondaryContainer: DarkColors.secondary.withValues(alpha: 0.2),
    onSecondaryContainer: DarkColors.onSecondary,
    // Tertiary
    tertiary: DarkColors.primary,
    onTertiary: DarkColors.onPrimary,
    // Error
    error: DarkColors.error,
    onError: DarkColors.onError,
    errorContainer: DarkColors.errorContainer,
    onErrorContainer: DarkColors.error,
    // Surfaces
    surface: DarkColors.surface,
    onSurface: DarkColors.onSurface,
    surfaceContainerHighest: DarkColors.surfaceVariant,
    onSurfaceVariant: DarkColors.onSurfaceVariant,
    // Outline
    outline: DarkColors.outline,
    outlineVariant: DarkColors.outlineVariant,
    // Shadow
    shadow: DarkColors.shadow,
    // Inverse
    inverseSurface: LightColors.surface,
    onInverseSurface: LightColors.onSurface,
    inversePrimary: LightColors.accent,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: DarkColors.background,
    textTheme: buildAppTextTheme(brightness: Brightness.dark),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: DarkColors.onBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleSpacing: AppSpacing.lg,
      titleTextStyle: buildAppTextTheme(brightness: Brightness.dark)
          .headlineSmall
          ?.copyWith(
            color: DarkColors.onBackground,
            fontWeight: FontWeight.w600,
          ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 0,
      color: DarkColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.card,
        side: BorderSide(
          color: DarkColors.outline.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      margin: EdgeInsets.zero,
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: DarkColors.accent,
        foregroundColor: DarkColors.onAccent,
        disabledBackgroundColor: DarkColors.disabled.withValues(alpha: 0.3),
        disabledForegroundColor: DarkColors.disabled,
        padding: AppSpacing.buttonHorizontal,
        minimumSize: const Size(88, 48),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.button,
        ),
        textStyle: buildAppTextTheme(brightness: Brightness.dark).labelLarge,
      ),
    ),

    // Filled Button Theme
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: DarkColors.accent,
        foregroundColor: DarkColors.onAccent,
        disabledBackgroundColor: DarkColors.disabled.withValues(alpha: 0.3),
        disabledForegroundColor: DarkColors.disabled,
        padding: AppSpacing.buttonHorizontal,
        minimumSize: const Size(88, 48),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.button,
        ),
        textStyle: buildAppTextTheme(brightness: Brightness.dark).labelLarge,
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: DarkColors.accent,
        disabledForegroundColor: DarkColors.disabled,
        padding: AppSpacing.buttonHorizontal,
        minimumSize: const Size(88, 48),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.button,
        ),
        side: BorderSide(
          color: DarkColors.accent,
          width: 1.5,
        ),
        textStyle: buildAppTextTheme(brightness: Brightness.dark).labelLarge,
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: DarkColors.accent,
        disabledForegroundColor: DarkColors.disabled,
        padding: AppSpacing.buttonHorizontal,
        minimumSize: const Size(88, 48),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.button,
        ),
        textStyle: buildAppTextTheme(brightness: Brightness.dark).labelLarge,
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DarkColors.surfaceVariant,
      contentPadding: AppSpacing.inputContent,
      border: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide(
          color: DarkColors.accent,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide(
          color: DarkColors.error,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppRadius.input,
        borderSide: BorderSide(
          color: DarkColors.error,
          width: 2,
        ),
      ),
      labelStyle: buildAppTextTheme(brightness: Brightness.dark)
          .bodyMedium
          ?.copyWith(color: DarkColors.onSurfaceVariant),
      hintStyle: buildAppTextTheme(brightness: Brightness.dark)
          .bodyMedium
          ?.copyWith(color: DarkColors.onSurfaceVariant),
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return DarkColors.accent;
        }
        return DarkColors.onSurfaceVariant;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return DarkColors.accent.withValues(alpha: 0.5);
        }
        return DarkColors.outline;
      }),
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return DarkColors.accent;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(DarkColors.onAccent),
      side: BorderSide(
        color: DarkColors.outline,
        width: 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: DarkColors.accent,
      foregroundColor: DarkColors.onAccent,
      elevation: AppElevation.md,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.iconButton,
      ),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: DarkColors.surfaceVariant,
      selectedColor: DarkColors.accent.withValues(alpha: 0.2),
      disabledColor: DarkColors.disabled.withValues(alpha: 0.2),
      labelStyle: buildAppTextTheme(brightness: Brightness.dark).labelLarge,
      secondaryLabelStyle:
          buildAppTextTheme(brightness: Brightness.dark).labelLarge?.copyWith(
                color: DarkColors.accent,
              ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.chip,
      ),
      side: BorderSide.none,
    ),

    // Navigation Bar Theme
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: DarkColors.surface,
      indicatorColor: DarkColors.accent.withValues(alpha: 0.2),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return buildAppTextTheme(brightness: Brightness.dark)
              .labelMedium!
              .copyWith(
                color: DarkColors.accent,
                fontWeight: FontWeight.w600,
              );
        }
        return buildAppTextTheme(brightness: Brightness.dark)
            .labelMedium!
            .copyWith(
              color: DarkColors.onSurfaceVariant,
            );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: DarkColors.accent);
        }
        return IconThemeData(color: DarkColors.onSurfaceVariant);
      }),
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: DarkColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.dialog,
      ),
      titleTextStyle: buildAppTextTheme(brightness: Brightness.dark)
          .headlineSmall
          ?.copyWith(
            color: DarkColors.onSurface,
          ),
      contentTextStyle:
          buildAppTextTheme(brightness: Brightness.dark).bodyMedium?.copyWith(
                color: DarkColors.onSurfaceVariant,
              ),
    ),

    // SnackBar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: DarkColors.surface,
      contentTextStyle:
          buildAppTextTheme(brightness: Brightness.dark).bodyMedium?.copyWith(
                color: DarkColors.onSurface,
              ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lgR,
      ),
      behavior: SnackBarBehavior.floating,
    ),

    // Bottom Sheet Theme
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: DarkColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.bottomSheet,
      ),
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: DarkColors.outline,
      thickness: AppDivider.height,
      space: AppSpacing.lg,
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: DarkColors.accent,
      linearTrackColor: DarkColors.surfaceVariant,
      circularTrackColor: DarkColors.surfaceVariant,
    ),

    // List Tile Theme
    listTileTheme: ListTileThemeData(
      contentPadding: AppSpacing.listItem,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lgR,
      ),
    ),
  );
}

/// Convenience getter for light theme
ThemeData get lightTheme => buildLightTheme();

/// Convenience getter for dark theme
ThemeData get darkTheme => buildDarkTheme();
