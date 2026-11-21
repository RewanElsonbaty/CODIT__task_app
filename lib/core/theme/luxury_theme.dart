import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

/// Luxury Gold Theme System
/// مستوحى من تطبيقات المجوهرات الفاخرة
class LuxuryTheme {
  /// Dark Luxury Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // ════════════════════════════════════════════════════
      // Color Scheme
      // ════════════════════════════════════════════════════
      colorScheme: const ColorScheme.dark(
        // Primary
        primary: AppColors.primary,
        onPrimary: AppColors.black,
        primaryContainer: AppColors.goldenTransparent,
        onPrimaryContainer: AppColors.goldenNeon,

        // Secondary
        secondary: AppColors.secondary,
        onSecondary: AppColors.black,
        secondaryContainer: AppColors.card,
        onSecondaryContainer: AppColors.textPrimary,

        // Surface
        surface: AppColors.card,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.background,
        onSurfaceVariant: AppColors.textSecondary,

        // Background
        background: AppColors.background,
        onBackground: AppColors.textPrimary,

        // Error
        error: AppColors.error,
        onError: AppColors.white,
        errorContainer: AppColors.errorSurface,
        onErrorContainer: AppColors.errorLight,

        // Outline
        outline: AppColors.border,
        outlineVariant: AppColors.goldenNeonDark,

        // Shadow & Overlay
        shadow: Colors.black54,
        scrim: AppColors.overlay,
      ),

      // ════════════════════════════════════════════════════
      // Scaffold
      // ════════════════════════════════════════════════════
      scaffoldBackgroundColor: AppColors.background,

      // ════════════════════════════════════════════════════
      // App Bar Theme
      // ════════════════════════════════════════════════════
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.card,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        iconTheme: IconThemeData(color: AppColors.goldenNeon),
        actionsIconTheme: IconThemeData(color: AppColors.goldenNeon),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
      ),

      // ════════════════════════════════════════════════════
      // Text Theme (Cairo Font)
      // ════════════════════════════════════════════════════
      textTheme: const TextTheme(
        // Display
        displayLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 57,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          height: 1.2,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 45,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.2,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 36,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.2,
        ),

        // Headline
        headlineLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.25,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.3,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.3,
        ),

        // Title
        titleLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.3,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.4,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          height: 1.4,
        ),

        // Body
        bodyLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          height: 1.5,
        ),

        // Label
        labelLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.4,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.4,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          height: 1.4,
          letterSpacing: 0.5,
        ),
      ),

      // ════════════════════════════════════════════════════
      // Card Theme
      // ════════════════════════════════════════════════════
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.goldenNeon, width: 1.5),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // ════════════════════════════════════════════════════
      // Elevated Button Theme (Primary Gold Button)
      // ════════════════════════════════════════════════════
      elevatedButtonTheme: ElevatedButtonThemeData(
        style:
            ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.black,
              disabledBackgroundColor: AppColors.primary.withOpacity(0.3),
              disabledForegroundColor: AppColors.textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return AppColors.goldenNeon.withOpacity(0.2);
                }
                if (states.contains(WidgetState.hovered)) {
                  return AppColors.goldenNeon.withOpacity(0.1);
                }
                return null;
              }),
            ),
      ),

      // ════════════════════════════════════════════════════
      // Outlined Button Theme
      // ════════════════════════════════════════════════════
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.textSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          side: const BorderSide(color: AppColors.primary, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // ════════════════════════════════════════════════════
      // Text Button Theme
      // ════════════════════════════════════════════════════
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.textSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ════════════════════════════════════════════════════
      // Input Decoration Theme
      // ════════════════════════════════════════════════════
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        // Borders
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.border.withOpacity(0.3),
            width: 1.5,
          ),
        ),

        // Labels & Hints
        labelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        floatingLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        helperStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        errorStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.error,
        ),

        // Icons
        prefixIconColor: AppColors.primary,
        suffixIconColor: AppColors.textSecondary,
      ),

      // ════════════════════════════════════════════════════
      // Bottom Navigation Bar Theme
      // ════════════════════════════════════════════════════
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.card,
        elevation: 8,
        selectedItemColor: AppColors.goldenNeon,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // ════════════════════════════════════════════════════
      // Floating Action Button Theme
      // ════════════════════════════════════════════════════
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // ════════════════════════════════════════════════════
      // Dialog Theme
      // ════════════════════════════════════════════════════
      dialogTheme: DialogThemeData(
        elevation: 8,
        backgroundColor: AppColors.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.goldenNeon, width: 2),
        ),
        titleTextStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        contentTextStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
      ),

      // ════════════════════════════════════════════════════
      // Snackbar Theme
      // ════════════════════════════════════════════════════
      snackBarTheme: SnackBarThemeData(
        elevation: 4,
        backgroundColor: AppColors.card,
        contentTextStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.goldenNeon, width: 1.5),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ════════════════════════════════════════════════════
      // Chip Theme
      // ════════════════════════════════════════════════════
      chipTheme: ChipThemeData(
        elevation: 0,
        backgroundColor: AppColors.card,
        selectedColor: AppColors.primary.withOpacity(0.2),
        disabledColor: AppColors.card.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        secondaryLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border, width: 1.5),
        ),
      ),

      // ════════════════════════════════════════════════════
      // Divider Theme
      // ════════════════════════════════════════════════════
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),

      // ════════════════════════════════════════════════════
      // Icon Theme
      // ════════════════════════════════════════════════════
      iconTheme: const IconThemeData(color: AppColors.primary, size: 24),

      // ════════════════════════════════════════════════════
      // Progress Indicator Theme
      // ════════════════════════════════════════════════════
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.border,
        circularTrackColor: AppColors.border,
      ),
    );
  }
}
