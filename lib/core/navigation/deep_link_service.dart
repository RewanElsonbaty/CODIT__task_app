import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

/// خدمة Deep Linking - فتح شاشات من الإشعارات
/// 
/// **المتطلبات:**
/// 1. عدم تكرار فتح نفس الشاشة
/// 2. عدم الاعتماد على بيانات اللينك (نجلب من السيرفر)
/// 3. منع فتح شاشة أثناء الخروج
/// 
class DeepLinkService {
  DeepLinkService(this._router);

  final GoRouter _router;
  
  String? _lastProcessedLink;
  bool _isProcessing = false;
  bool _isLoggedOut = false;

  /// معالجة deep link من إشعار
  Future<bool> handleNotificationLink(String link) async {
    debugPrint('[DeepLink] Received: $link');

    // منع معالجة أثناء الخروج
    if (_isLoggedOut) {
      debugPrint('[DeepLink] Rejected: user logged out');
      return false;
    }

    // منع تكرار نفس اللينك
    if (_lastProcessedLink == link) {
      debugPrint('[DeepLink] Rejected: duplicate link');
      return false;
    }

    // منع معالجة متزامنة
    if (_isProcessing) {
      debugPrint('[DeepLink] Rejected: already processing');
      return false;
    }

    _isProcessing = true;
    _lastProcessedLink = link;

    try {
      final parsed = _parseLink(link);
      if (parsed == null) {
        debugPrint('[DeepLink] Invalid format');
        return false;
      }

      // نستخرج فقط الـ type والـ ID، البيانات نجلبها من السيرفر
      final type = parsed['type'] as String;
      final id = parsed['id'] as String;

      return await _navigateToScreen(type, id);
    } catch (e) {
      debugPrint('[DeepLink] Error: $e');
      return false;
    } finally {
      _isProcessing = false;
    }
  }

  /// تحليل الرابط
  Map<String, String>? _parseLink(String link) {
    // صيغة اللينك: codit://notification?type=approval&id=APR-123
    final uri = Uri.tryParse(link);
    if (uri == null || uri.scheme != 'codit') return null;

    final type = uri.queryParameters['type'];
    final id = uri.queryParameters['id'];

    if (type == null || id == null) return null;

    return {'type': type, 'id': id};
  }

  /// التوجيه للشاشة المناسبة
  Future<bool> _navigateToScreen(String type, String id) async {
    switch (type) {
      case 'approval':
        // فتح صفحة تفاصيل الموافقة
        // نجلب البيانات من السيرفر بالـ ID
        _router.push('/approvals/details/$id');
        return true;

      case 'installment':
        // فتح صفحة العميل
        _router.push('/installments/customer/$id');
        return true;

      case 'gold_sale':
        // فتح الفاتورة (للمراجعة فقط)
        _router.push('/gold-sales/invoice/$id');
        return true;

      case 'branch_alert':
        // فتح الـ monitoring للفرع المحدد
        _router.push('/branch-monitoring?branch=$id');
        return true;

      default:
        debugPrint('[DeepLink] Unknown type: $type');
        return false;
    }
  }

  /// منع Deep Links عند الخروج
  void onLogout() {
    debugPrint('[DeepLink] Session ended, disabling deep links');
    _isLoggedOut = true;
    _lastProcessedLink = null;
  }

  /// تفعيل Deep Links عند تسجيل الدخول
  void onLogin() {
    debugPrint('[DeepLink] Session started, enabling deep links');
    _isLoggedOut = false;
    _lastProcessedLink = null;
  }

  /// مسح الحالة (للتستات)
  void reset() {
    _lastProcessedLink = null;
    _isProcessing = false;
    _isLoggedOut = false;
  }
}
