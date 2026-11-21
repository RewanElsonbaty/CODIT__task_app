import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/models/auth_models.dart';

/// Secure storage service for sensitive data
/// 
/// IMPORTANT: Never logs tokens or sensitive data
class SecureStorageService {
  final FlutterSecureStorage _storage;

  // Storage keys
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyExpiresAt = 'expires_at';
  static const String _keyDeviceId = 'device_id';
  static const String _keyUser = 'user';

  SecureStorageService(this._storage);

  /// Save authentication tokens
  /// 
  /// NEVER logs the actual token values
  Future<void> saveTokens(AuthTokens tokens) async {
    debugPrint('[SecureStorage] Saving tokens (values not logged)');
    
    await Future.wait([
      _storage.write(key: _keyAccessToken, value: tokens.accessToken),
      _storage.write(key: _keyRefreshToken, value: tokens.refreshToken),
      _storage.write(key: _keyExpiresAt, value: tokens.expiresAt.toIso8601String()),
      if (tokens.deviceId != null)
        _storage.write(key: _keyDeviceId, value: tokens.deviceId!),
    ]);
    
    debugPrint('[SecureStorage] Tokens saved successfully');
  }

  /// Get authentication tokens
  Future<AuthTokens?> getTokens() async {
    try {
      final accessToken = await _storage.read(key: _keyAccessToken);
      final refreshToken = await _storage.read(key: _keyRefreshToken);
      final expiresAtStr = await _storage.read(key: _keyExpiresAt);
      final deviceId = await _storage.read(key: _keyDeviceId);

      if (accessToken == null || refreshToken == null || expiresAtStr == null) {
        debugPrint('[SecureStorage] No tokens found');
        return null;
      }

      final expiresAt = DateTime.parse(expiresAtStr);

      debugPrint('[SecureStorage] Tokens retrieved (values not logged)');
      debugPrint('[SecureStorage] Token expires at: $expiresAt');

      return AuthTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresAt: expiresAt,
        deviceId: deviceId,
      );
    } catch (e) {
      debugPrint('[SecureStorage] Error reading tokens: $e');
      return null;
    }
  }

  /// Clear all tokens
  Future<void> clearTokens() async {
    debugPrint('[SecureStorage] Clearing tokens');
    
    await Future.wait([
      _storage.delete(key: _keyAccessToken),
      _storage.delete(key: _keyRefreshToken),
      _storage.delete(key: _keyExpiresAt),
      _storage.delete(key: _keyDeviceId),
    ]);
    
    debugPrint('[SecureStorage] Tokens cleared');
  }

  /// Save user data
  Future<void> saveUser(AuthUser user) async {
    debugPrint('[SecureStorage] Saving user: ${user.id}');
    
    final userJson = jsonEncode(user.toJson());
    await _storage.write(key: _keyUser, value: userJson);
    
    debugPrint('[SecureStorage] User saved successfully');
  }

  /// Get user data
  Future<AuthUser?> getUser() async {
    try {
      final userJson = await _storage.read(key: _keyUser);
      
      if (userJson == null) {
        debugPrint('[SecureStorage] No user found');
        return null;
      }

      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      final user = AuthUser.fromJson(userMap);
      
      debugPrint('[SecureStorage] User retrieved: ${user.id}');
      
      return user;
    } catch (e) {
      debugPrint('[SecureStorage] Error reading user: $e');
      return null;
    }
  }

  /// Clear user data
  Future<void> clearUser() async {
    debugPrint('[SecureStorage] Clearing user');
    await _storage.delete(key: _keyUser);
    debugPrint('[SecureStorage] User cleared');
  }

  /// Clear all secure storage
  Future<void> clearAll() async {
    debugPrint('[SecureStorage] Clearing all secure storage');
    await _storage.deleteAll();
    debugPrint('[SecureStorage] All secure storage cleared');
  }

  /// Get device ID
  Future<String?> getDeviceId() async {
    return await _storage.read(key: _keyDeviceId);
  }

  /// Save device ID
  Future<void> saveDeviceId(String deviceId) async {
    debugPrint('[SecureStorage] Saving device ID: $deviceId');
    await _storage.write(key: _keyDeviceId, value: deviceId);
  }
}
