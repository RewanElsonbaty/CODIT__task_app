import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage للبيانات الحساسة (tokens, etc.)
class SecureStorage {
  SecureStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  /// Get access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Save both tokens
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }

  /// Clear all secure data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Set pending route (for deep linking)
  Future<void> setPendingRoute(String route) async {
    await _storage.write(key: 'pending_route', value: route);
  }

  /// Get pending route
  Future<String?> getPendingRoute() async {
    return await _storage.read(key: 'pending_route');
  }

  /// Clear pending route
  Future<void> clearPendingRoute() async {
    await _storage.delete(key: 'pending_route');
  }
}
