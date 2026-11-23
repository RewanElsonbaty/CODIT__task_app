import 'package:flutter/material.dart';

/// نظام الألوان الاحترافي للتطبيق
/// Theme: Dark/Elegant with Metallic Gold accents
abstract final class AppColors {
  // ═══════════════════════════════════════════════════════
  // الألوان الأساسية (Brand Colors)
  // ═══════════════════════════════════════════════════════
  
  /// الخلفية الرئيسية - Deep Charcoal
  static const background = Color(0xFF171514);
  
  /// خلفية الكروت - Dark Charcoal
  static const card = Color(0xFF292421);
  
  /// خلفية الكروت عند Hover - Lighter Charcoal
  static const cardHover = Color(0xFF3A3532);
  
  /// الخلفية الثانوية - Dark Brown
  static const backgroundSecondary = Color(0xFF211D1B);
  
  /// اللون الأساسي - Metallic Gold
  static const primary = Color(0xFFD6A52B);
  
  /// اللون الثانوي - Champagne Gold
  static const secondary = Color(0xFFC9A45C);
  
  /// النص الأساسي - Warm White
  static const textPrimary = Color(0xFFF8F5EF);
  
  /// النص الثانوي - Soft Gray
  static const textSecondary = Color(0xFFA9A29B);
  
  /// الحدود - Muted Gold
  static const border = Color(0xFF66502E);

  // ═══════════════════════════════════════════════════════
  // ألوان الحالات الوظيفية (Semantic Colors)
  // ═══════════════════════════════════════════════════════
  
  /// نجاح / موافقة - أخضر
  static const success = Color(0xFF10B981);
  static const successLight = Color(0xFF34D399);
  static const successDark = Color(0xFF059669);
  static const successSurface = Color(0xFF1A3A2E);
  
  /// رفض / خطأ - أحمر
  static const error = Color(0xFFEF4444);
  static const errorLight = Color(0xFFF87171);
  static const errorDark = Color(0xFFDC2626);
  static const errorSurface = Color(0xFF3A1A1A);
  
  /// انتظار - برتقالي
  static const pending = Color(0xFFF97316);
  static const pendingLight = Color(0xFFFB923C);
  static const pendingDark = Color(0xFFEA580C);
  static const pendingSurface = Color(0xFF3A2A1A);
  
  /// تحذير - أصفر ذهبي
  static const warning = Color(0xFFFBBF24);
  static const warningLight = Color(0xFFFCD34D);
  static const warningDark = Color(0xFFF59E0B);
  static const warningSurface = Color(0xFF3A331A);
  
  /// معلومة - أزرق
  static const info = Color(0xFF3B82F6);
  static const infoLight = Color(0xFF60A5FA);
  static const infoDark = Color(0xFF2563EB);
  static const infoSurface = Color(0xFF1A2A3A);

  // ═══════════════════════════════════════════════════════
  // ألوان إضافية (Utility Colors)
  // ═══════════════════════════════════════════════════════
  
  /// للخلفيات الشفافة
  static const overlay = Color(0xCC171514);
  static const overlayLight = Color(0x80171514);
  
  /// للتباين العالي
  static const white = Color(0xFFFAFAFA);
  static const black = Color(0xFF0A0908);
  
  // ═══════════════════════════════════════════════════════
  // Golden Neon - للبوردرات والتفاصيل الفاخرة
  // ═══════════════════════════════════════════════════════
  
  /// ذهبي نيون - للبوردرات الرئيسية
  static const goldenNeon = Color(0xFFFFD700);
  
  /// ذهبي غامق - للبوردرات الثانوية
  static const goldenNeonDark = Color(0xFFB8860B);
  
  /// توهج ذهبي - للـ Shadows والـ Glows
  static const goldenGlow = Color(0xFFFFA500);
  
  /// ذهبي شفاف - للخلفيات المتدرجة
  static const goldenTransparent = Color(0x1AFFD700);
  
  /// Legacy compatibility (للكود القديم)
  @Deprecated('Use background instead')
  static const surface = background;
  
  @Deprecated('Use secondary instead')
  static const accent = secondary;
  
  @Deprecated('Use primary instead')
  static const primaryDark = Color(0xFFB8902A);
}