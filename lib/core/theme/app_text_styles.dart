import 'package:flutter/material.dart';
import 'package:codit/core/theme/app_colors.dart';

/// Ø£Ù†Ù…Ø§Ø· Ø§Ù„Ù†ØµÙˆØµ Ø§Ù„Ù…Ø®ØµØµØ© Ù„Ù„ØªØ·Ø¨ÙŠÙ‚
/// 
/// ØªÙˆÙØ± Ø£Ù†Ù…Ø§Ø· Ù†ØµÙˆØµ Ù…Ø¹Ø¯Ø© Ù…Ø³Ø¨Ù‚Ø§Ù‹ Ù„Ø¬Ù…ÙŠØ¹ Ø­Ø§Ù„Ø§Øª Ø§Ù„Ø§Ø³ØªØ®Ø¯Ø§Ù…
abstract final class AppTextStyles {
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  // Ø§Ù„Ø¹Ù†Ø§ÙˆÙŠÙ† Ø§Ù„Ø±Ø¦ÙŠØ³ÙŠØ© (Headings)
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    fontFamily: 'Cairo',
    letterSpacing: -0.5,
    height: 1.2,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: 'Cairo',
    height: 1.3,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: 'Cairo',
    height: 1.3,
  );
  
  static const TextStyle heading4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Cairo',
    height: 1.4,
  );
  
  static const TextStyle heading5 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Cairo',
    height: 1.4,
  );
  
  static const TextStyle heading6 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Cairo',
    height: 1.5,
  );
  
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  // Ø§Ù„Ù†ØµÙˆØµ Ø§Ù„Ø£Ø³Ø§Ø³ÙŠØ© (Body Text)
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    fontFamily: 'Cairo',
    height: 1.6,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    fontFamily: 'Cairo',
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    fontFamily: 'Cairo',
    height: 1.4,
  );
  
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  // Ø§Ù„ØªØ³Ù…ÙŠØ§Øª (Labels)
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Cairo',
    letterSpacing: 0.1,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    fontFamily: 'Cairo',
    letterSpacing: 0.5,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    fontFamily: 'Cairo',
    letterSpacing: 0.5,
  );
  
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  // Ø§Ù„Ø£Ø²Ø±Ø§Ø± (Buttons)
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'Cairo',
    letterSpacing: 0.2,
  );
  
  static const TextStyle buttonSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: 'Cairo',
    letterSpacing: 0.1,
  );
  
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  // Ø§Ù„Ø£Ø±Ù‚Ø§Ù… ÙˆØ§Ù„Ù…Ø¨Ø§Ù„Øº Ø§Ù„Ù…Ø§Ù„ÙŠØ© (Numbers & Currency)
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  
  /// Ù„Ù„Ù…Ø¨Ø§Ù„Øº Ø§Ù„Ù…Ø§Ù„ÙŠØ© Ø§Ù„ÙƒØ¨ÙŠØ±Ø©
  static const TextStyle currencyLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    fontFamily: 'Cairo',
    letterSpacing: 0.5,
  );
  
  /// Ù„Ù„Ù…Ø¨Ø§Ù„Øº Ø§Ù„Ù…Ø§Ù„ÙŠØ© Ø§Ù„Ù…ØªÙˆØ³Ø·Ø©
  static const TextStyle currencyMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    fontFamily: 'Cairo',
    letterSpacing: 0.3,
  );
  
  /// Ù„Ù„Ù…Ø¨Ø§Ù„Øº Ø§Ù„Ù…Ø§Ù„ÙŠØ© Ø§Ù„ØµØºÙŠØ±Ø©
  static const TextStyle currencySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Cairo',
    letterSpacing: 0.2,
  );
  
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  // Ø§Ù„Ø­Ø§Ù„Ø§Øª Ø§Ù„Ø®Ø§ØµØ© (Special States)
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  
  static const TextStyle success = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.success,
    fontFamily: 'Cairo',
  );
  
  static const TextStyle error = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.error,
    fontFamily: 'Cairo',
  );
  
  static const TextStyle warning = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.warning,
    fontFamily: 'Cairo',
  );
  
  static const TextStyle info = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.info,
    fontFamily: 'Cairo',
  );
  
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  // Badges & Tags
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  
  static const TextStyle badge = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    fontFamily: 'Cairo',
    letterSpacing: 0.5,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    fontFamily: 'Cairo',
    letterSpacing: 0.3,
  );
}


