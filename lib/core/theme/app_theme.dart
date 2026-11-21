import 'package:codit/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Ø¨Ù†Ø§Ø¡ Ø«ÙŠÙ… Ø§Ù„ØªØ·Ø¨ÙŠÙ‚ Ø§Ù„Ø±Ø¦ÙŠØ³ÙŠ
/// 
/// Ù†Ø¸Ø§Ù… Ø§Ù„Ø£Ù„ÙˆØ§Ù†: Dark/Elegant Ù…Ø¹ Ù„Ù…Ø³Ø§Øª Ø°Ù‡Ø¨ÙŠØ© Ù…Ø¹Ø¯Ù†ÙŠØ©
/// Ø§Ù„Ø®Ø·: Cairo Ù„Ù„Ø¹Ø±Ø¨ÙŠØ© Ù…Ø¹ Ø¯Ø¹Ù… ÙƒØ§Ù…Ù„ Ù„Ù€ RTL
ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    
    // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    // Ù†Ø¸Ø§Ù… Ø§Ù„Ø£Ù„ÙˆØ§Ù† (Color Scheme)
    // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    colorScheme: ColorScheme.dark(
      // Ø§Ù„Ø£Ù„ÙˆØ§Ù† Ø§Ù„Ø£Ø³Ø§Ø³ÙŠØ©
      primary: AppColors.primary,
      onPrimary: AppColors.background,
      primaryContainer: AppColors.secondary,
      onPrimaryContainer: AppColors.textPrimary,
      
      // Ø§Ù„Ø£Ù„ÙˆØ§Ù† Ø§Ù„Ø«Ø§Ù†ÙˆÙŠØ©
      secondary: AppColors.secondary,
      onSecondary: AppColors.background,
      secondaryContainer: AppColors.border,
      onSecondaryContainer: AppColors.textPrimary,
      
      // Ø§Ù„Ø®Ù„ÙÙŠØ§Øª
      surface: AppColors.background,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.card,
      
      // Ø§Ù„Ø­Ø§Ù„Ø§Øª
      error: AppColors.error,
      onError: AppColors.textPrimary,
      
      // Ø§Ù„Ø­Ø¯ÙˆØ¯ ÙˆØ§Ù„ÙÙˆØ§ØµÙ„
      outline: AppColors.border,
      outlineVariant: AppColors.textSecondary,
    ),
    
    // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    // Ø§Ù„Ø®Ù„ÙÙŠØ§Øª
    // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    scaffoldBackgroundColor: AppColors.background,
    canvasColor: AppColors.backgroundSecondary,
    cardColor: AppColors.card,
    dialogBackgroundColor: AppColors.card,
    
    // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    // Ø§Ù„Ø·Ø¨Ø§Ø¹Ø© ÙˆØ§Ù„Ø®Ø·ÙˆØ· (Typography)
    // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    // Ù…Ù„Ø§Ø­Ø¸Ø©: Ø§Ø³ØªØ®Ø¯Ù… Ø®Ø· Cairo Ø¨Ø¹Ø¯ ØªØ­Ù…ÙŠÙ„Ù‡ Ù…Ù† fonts/DOWNLOAD_FONTS.md
    // fontFamily: 'Cairo',
    
    textTheme: const TextTheme(
      // Ø§Ù„Ø¹Ù†Ø§ÙˆÙŠÙ† Ø§Ù„ÙƒØ¨ÙŠØ±Ø©
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      
      // Ø§Ù„Ø¹Ù†Ø§ÙˆÙŠÙ† Ø§Ù„ÙØ±Ø¹ÙŠØ©
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      
      // Ø§Ù„Ø¹Ù†Ø§ÙˆÙŠÙ† Ø§Ù„Ø£ØµØºØ±
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      
      // Ø§Ù„Ù†ØµÙˆØµ Ø§Ù„Ø£Ø³Ø§Ø³ÙŠØ©
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.4,
      ),
      
      // Ø§Ù„ØªØ³Ù…ÙŠØ§Øª ÙˆØ§Ù„Ù†ØµÙˆØµ Ø§Ù„ØµØºÙŠØ±Ø©
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      ),
    ),
    
    // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    // AppBar
    // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 2,
      backgroundColor: AppColors.card,
      foregroundColor: AppColors.textPrimary,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      titleTextStyle: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: 24,
      ),
    ),
    
    // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    // Ø§Ù„ÙƒØ±ÙˆØª (Cards)
    // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      shadowColor: Colors.black45,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.border.withOpacity(0.2),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.all(0),
    ),
    
    // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    // Ø­Ù‚ÙˆÙ„ Ø§Ù„Ø¥Ø¯Ø®Ø§Ù„ (Input Fields)
    // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.backgroundSecondary,
      
      // Ø§Ù„Ø­Ø¯ÙˆØ¯
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.border.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.border.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      
      // Ø§Ù„Ù†ØµÙˆØµ
      labelStyle: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: TextStyle(
        color: AppColors.textSecondary.withOpacity(0.7),
        fontSize: 14,
      ),
      errorStyle: const TextStyle(
        color: AppColors.error,
        fontSize: 12,
      ),
      
      // Ø§Ù„Ø­Ø´Ùˆ
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      
      // Ø§Ù„Ø£ÙŠÙ‚ÙˆÙ†Ø§Øª
      prefixIconColor: AppColors.textSecondary,
      suffixIconColor: AppColors.textSecondary,
    ),
    
    // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    // Ø§Ù„Ø£Ø²Ø±Ø§Ø± (Buttons)
    // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    
    // FilledButton (Ø§Ù„Ø²Ø± Ø§Ù„Ø£Ø³Ø§Ø³ÙŠ)
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        disabledBackgroundColor: AppColors.border.withOpacity(0.3),
        disabledForegroundColor: AppColors.textSecondary.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(100, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),
    
    // OutlinedButton (Ø§Ù„Ø²Ø± Ø§Ù„Ø«Ø§Ù†ÙˆÙŠ)
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.textSecondary.withOpacity(0.5),
        side: const BorderSide(color: AppColors.primary, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(100, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),
    
    // TextButton
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.textSecondary.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // ElevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.background,
        disabledBackgroundColor: AppColors.border.withOpacity(0.3),
        disabledForegroundColor: AppColors.textSecondary.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(100, 48),
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),
    
    // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    // Ø£Ø®Ø±Ù‰ (Miscellaneous)
    // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    
    // Ø§Ù„Ù€ Divider
    dividerTheme: DividerThemeData(
      color: AppColors.border.withOpacity(0.3),
      thickness: 1,
      space: 1,
    ),
    
    // Ø§Ù„Ù€ Switch
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary;
        return AppColors.textSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary.withOpacity(0.5);
        }
        return AppColors.border.withOpacity(0.3);
      }),
    ),
    
    // Ø§Ù„Ù€ Checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.background),
      side: BorderSide(color: AppColors.border.withOpacity(0.5), width: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    
    // Ø§Ù„Ù€ Radio
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary;
        return AppColors.textSecondary;
      }),
    ),
    
    // Ø§Ù„Ù€ SnackBar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.card,
      contentTextStyle: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 4,
    ),
    
    // Ø§Ù„Ù€ Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.card,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titleTextStyle: const TextStyle(
        // fontFamily: 'Cairo',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      contentTextStyle: const TextStyle(
        // fontFamily: 'Cairo',
        fontSize: 14,
        color: AppColors.textSecondary,
        height: 1.5,
      ),
    ),
    
    // Ø§Ù„Ù€ BottomSheet
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.card,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: AppColors.card,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    
    // Ø§Ù„Ù€ ProgressIndicator
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      circularTrackColor: AppColors.border,
      linearTrackColor: AppColors.border,
    ),
    
    // Ø§Ù„Ù€ FloatingActionButton
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.background,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    
    // Ø§Ù„Ù€ Icon
    iconTheme: const IconThemeData(
      color: AppColors.textPrimary,
      size: 24,
    ),
    
    // Ø§Ù„Ù€ ListTile
    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.textSecondary,
      textColor: AppColors.textPrimary,
      tileColor: Colors.transparent,
      selectedColor: AppColors.primary,
      selectedTileColor: AppColors.backgroundSecondary,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  );
}


