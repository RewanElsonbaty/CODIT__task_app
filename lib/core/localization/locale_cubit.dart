import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Cubit لإدارة اللغة والاتجاه
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('ar', '')) {
    _loadSavedLocale();
  }

  static const String _localeKey = 'app_locale';

  /// تحميل اللغة المحفوظة
  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString(_localeKey);
      
      if (savedLanguageCode != null) {
        emit(Locale(savedLanguageCode, ''));
      }
    } catch (e) {
      // إذا فشل التحميل، استخدم العربية كافتراضي
      emit(const Locale('ar', ''));
    }
  }

  /// تغيير اللغة
  Future<void> changeLocale(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, languageCode);
      emit(Locale(languageCode, ''));
    } catch (e) {
      // في حالة الفشل، لا تغير اللغة
      print('Error changing locale: $e');
    }
  }

  /// تبديل اللغة (عربي <-> إنجليزي)
  Future<void> toggleLocale() async {
    final newLanguageCode = state.languageCode == 'ar' ? 'en' : 'ar';
    await changeLocale(newLanguageCode);
  }

  /// الحصول على اللغة الحالية
  String get currentLanguageCode => state.languageCode;

  /// هل اللغة عربية؟
  bool get isArabic => state.languageCode == 'ar';

  /// هل اللغة إنجليزية؟
  bool get isEnglish => state.languageCode == 'en';

  /// الاتجاه الحالي
  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;
}
