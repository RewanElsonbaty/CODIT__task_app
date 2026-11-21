import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/models/auth_models.dart';
import '../../domain/repositories/auth_repository.dart';

/// Token manager with single-flight refresh mechanism
/// 
/// Ensures that only one token refresh is in progress at a time,
/// even if multiple requests need a refreshed token simultaneously.
class TokenManager {
  final AuthRepository _repository;

  // Single-flight refresh control
  Future<AuthTokens?>? _refreshFuture;
  bool _isRefreshing = false;
  
  // Logout flag to prevent re-authentication after logout
  bool _isLoggingOut = false;

  TokenManager(this._repository);

  /// Get current valid tokens
  /// 
  /// If tokens are expired, triggers a refresh.
  /// If refresh is already in progress, waits for it to complete.
  Future<AuthTokens?> getValidTokens() async {
    // Check if logout is in progress
    if (_isLoggingOut) {
      debugPrint('[TokenManager] Logout in progress, returning null');
      return null;
    }

    // Get stored tokens
    final tokens = await _repository.getStoredTokens();
    if (tokens == null) {
      debugPrint('[TokenManager] No tokens stored');
      return null;
    }

    // If tokens are valid, return them
    if (tokens.isValid) {
      return tokens;
    }

    debugPrint('[TokenManager] Tokens expired, refreshing...');

    // If refresh is already in progress, wait for it
    if (_isRefreshing && _refreshFuture != null) {
      debugPrint('[TokenManager] Refresh already in progress, waiting...');
      return await _refreshFuture;
    }

    // Start new refresh
    return await _refresh(tokens.refreshToken);
  }

  /// Refresh tokens with single-flight mechanism
  Future<AuthTokens?> _refresh(String refreshToken) async {
    // Mark refresh as in progress
    _isRefreshing = true;

    // Create refresh future
    _refreshFuture = _performRefresh(refreshToken);

    try {
      // Wait for refresh to complete
      final newTokens = await _refreshFuture;
      
      // Mark refresh as complete
      _isRefreshing = false;
      _refreshFuture = null;
      
      return newTokens;
    } catch (e) {
      // Mark refresh as complete even on error
      _isRefreshing = false;
      _refreshFuture = null;
      
      debugPrint('[TokenManager] Refresh failed: $e');
      return null;
    }
  }

  /// Perform the actual token refresh
  Future<AuthTokens?> _performRefresh(String refreshToken) async {
    debugPrint('[TokenManager] Performing token refresh...');

    // Check if logout happened during wait
    if (_isLoggingOut) {
      debugPrint('[TokenManager] Logout detected during refresh, aborting');
      return null;
    }

    // Call repository to refresh
    final result = await _repository.refreshToken(refreshToken);

    return result.fold(
      (failure) {
        debugPrint('[TokenManager] Refresh failed: ${failure.message}');
        // Clear tokens on refresh failure
        _repository.clearTokens();
        return null;
      },
      (newTokens) async {
        // Check again if logout happened
        if (_isLoggingOut) {
          debugPrint('[TokenManager] Logout detected after refresh, discarding tokens');
          return null;
        }

        debugPrint('[TokenManager] Refresh successful');
        
        // Save new tokens
        await _repository.saveTokens(newTokens);
        
        return newTokens;
      },
    );
  }

  /// Mark logout as in progress
  /// 
  /// This prevents token refresh from re-authenticating the user
  /// after they explicitly logged out.
  void markLoggingOut() {
    debugPrint('[TokenManager] Marking logout in progress');
    _isLoggingOut = true;
  }

  /// Reset logout flag
  /// 
  /// Should be called after logout is complete.
  void resetLogoutFlag() {
    debugPrint('[TokenManager] Resetting logout flag');
    _isLoggingOut = false;
  }

  /// Clear all state
  void clear() {
    _isRefreshing = false;
    _refreshFuture = null;
    _isLoggingOut = false;
  }
}
