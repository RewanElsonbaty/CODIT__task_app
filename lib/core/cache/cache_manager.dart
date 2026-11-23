import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Cache Manager للتخزين المؤقت
/// يستخدم Secure Storage لحفظ البيانات
class CacheManager {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Keys
  static const String _approvalsKey = 'cached_approvals';
  static const String _installmentsKey = 'cached_installments';
  static const String _branchesKey = 'cached_branches';
  static const String _notificationsKey = 'cached_notifications';
  static const String _goldProductsKey = 'cached_gold_products';
  
  // Timestamps
  static const String _approvalsTimestampKey = 'cached_approvals_timestamp';
  static const String _installmentsTimestampKey = 'cached_installments_timestamp';
  static const String _branchesTimestampKey = 'cached_branches_timestamp';
  static const String _notificationsTimestampKey = 'cached_notifications_timestamp';
  static const String _goldProductsTimestampKey = 'cached_gold_products_timestamp';
  
  // Cache expiration (1 hour)
  static const Duration _cacheExpiration = Duration(hours: 1);

  /// حفظ الموافقات في الكاش
  Future<void> cacheApprovals(List<Map<String, dynamic>> approvals) async {
    await _storage.write(
      key: _approvalsKey,
      value: jsonEncode(approvals),
    );
    await _storage.write(
      key: _approvalsTimestampKey,
      value: DateTime.now().toIso8601String(),
    );
  }

  /// جلب الموافقات من الكاش
  Future<List<Map<String, dynamic>>?> getCachedApprovals() async {
    if (!await _isCacheValid(_approvalsTimestampKey)) {
      return null;
    }

    final cached = await _storage.read(key: _approvalsKey);
    if (cached == null) return null;

    try {
      final List<dynamic> decoded = jsonDecode(cached);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return null;
    }
  }

  /// حفظ الأقساط في الكاش
  Future<void> cacheInstallments(List<Map<String, dynamic>> installments) async {
    await _storage.write(
      key: _installmentsKey,
      value: jsonEncode(installments),
    );
    await _storage.write(
      key: _installmentsTimestampKey,
      value: DateTime.now().toIso8601String(),
    );
  }

  /// جلب الأقساط من الكاش
  Future<List<Map<String, dynamic>>?> getCachedInstallments() async {
    if (!await _isCacheValid(_installmentsTimestampKey)) {
      return null;
    }

    final cached = await _storage.read(key: _installmentsKey);
    if (cached == null) return null;

    try {
      final List<dynamic> decoded = jsonDecode(cached);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return null;
    }
  }

  /// حفظ الفروع في الكاش
  Future<void> cacheBranches(List<Map<String, dynamic>> branches) async {
    await _storage.write(
      key: _branchesKey,
      value: jsonEncode(branches),
    );
    await _storage.write(
      key: _branchesTimestampKey,
      value: DateTime.now().toIso8601String(),
    );
  }

  /// جلب الفروع من الكاش
  Future<List<Map<String, dynamic>>?> getCachedBranches() async {
    if (!await _isCacheValid(_branchesTimestampKey)) {
      return null;
    }

    final cached = await _storage.read(key: _branchesKey);
    if (cached == null) return null;

    try {
      final List<dynamic> decoded = jsonDecode(cached);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return null;
    }
  }

  /// حفظ الإشعارات في الكاش
  Future<void> cacheNotifications(List<Map<String, dynamic>> notifications) async {
    await _storage.write(
      key: _notificationsKey,
      value: jsonEncode(notifications),
    );
    await _storage.write(
      key: _notificationsTimestampKey,
      value: DateTime.now().toIso8601String(),
    );
  }

  /// جلب الإشعارات من الكاش
  Future<List<Map<String, dynamic>>?> getCachedNotifications() async {
    if (!await _isCacheValid(_notificationsTimestampKey)) {
      return null;
    }

    final cached = await _storage.read(key: _notificationsKey);
    if (cached == null) return null;

    try {
      final List<dynamic> decoded = jsonDecode(cached);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return null;
    }
  }

  /// حفظ منتجات الذهب في الكاش
  Future<void> cacheGoldProducts(List<Map<String, dynamic>> products) async {
    await _storage.write(
      key: _goldProductsKey,
      value: jsonEncode(products),
    );
    await _storage.write(
      key: _goldProductsTimestampKey,
      value: DateTime.now().toIso8601String(),
    );
  }

  /// جلب منتجات الذهب من الكاش
  Future<List<Map<String, dynamic>>?> getCachedGoldProducts() async {
    if (!await _isCacheValid(_goldProductsTimestampKey)) {
      return null;
    }

    final cached = await _storage.read(key: _goldProductsKey);
    if (cached == null) return null;

    try {
      final List<dynamic> decoded = jsonDecode(cached);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return null;
    }
  }

  /// التحقق من صلاحية الكاش
  Future<bool> _isCacheValid(String timestampKey) async {
    final timestamp = await _storage.read(key: timestampKey);
    if (timestamp == null) return false;

    try {
      final cachedTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      return now.difference(cachedTime) < _cacheExpiration;
    } catch (e) {
      return false;
    }
  }

  /// مسح كل الكاش
  Future<void> clearAllCache() async {
    await _storage.delete(key: _approvalsKey);
    await _storage.delete(key: _approvalsTimestampKey);
    await _storage.delete(key: _installmentsKey);
    await _storage.delete(key: _installmentsTimestampKey);
    await _storage.delete(key: _branchesKey);
    await _storage.delete(key: _branchesTimestampKey);
    await _storage.delete(key: _notificationsKey);
    await _storage.delete(key: _notificationsTimestampKey);
    await _storage.delete(key: _goldProductsKey);
    await _storage.delete(key: _goldProductsTimestampKey);
  }

  /// مسح كاش محدد
  Future<void> clearCache(String key) async {
    await _storage.delete(key: key);
    await _storage.delete(key: '${key}_timestamp');
  }

  /// التحقق من وجود كاش
  Future<bool> hasCache(String key) async {
    final cached = await _storage.read(key: key);
    return cached != null;
  }
}
