import 'dart:async';

import 'package:codit/core/security/secure_storage_service.dart';

typedef RefreshCallback = Future<bool> Function(String refreshToken);

/// Single-flight token refresh with session generation invalidation on logout.
class SessionController {
  SessionController(this._secureStorage);

  final SecureStorageService _secureStorage;

  int _sessionGeneration = 0;
  Future<bool>? _refreshInFlight;

  int get sessionGeneration => _sessionGeneration;

  Future<void> loadGeneration() async {
    _sessionGeneration = await _secureStorage.sessionGeneration;
  }

  void bumpSessionOnLogin(int generation) {
    _sessionGeneration = generation;
  }

  Future<void> invalidateSession() async {
    _sessionGeneration++;
    await _secureStorage.clear();
    _refreshInFlight = null;
  }

  Future<bool> refreshOnce(RefreshCallback refresh) async {
    if (_refreshInFlight != null) {
      return _refreshInFlight!;
    }
    final genAtStart = _sessionGeneration;
    _refreshInFlight = () async {
      try {
        final token = await _secureStorage.refreshToken;
        if (token == null) return false;
        final ok = await refresh(token);
        if (genAtStart != _sessionGeneration) return false;
        return ok;
      } catch (_) {
        return false;
      } finally {
        _refreshInFlight = null;
      }
    }();
    return _refreshInFlight!;
  }
}