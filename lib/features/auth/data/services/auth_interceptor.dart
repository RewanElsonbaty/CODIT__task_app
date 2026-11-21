import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'token_manager.dart';

/// Authentication interceptor for automatic token refresh
/// 
/// Intercepts requests to add authentication headers.
/// Automatically refreshes tokens on 401 responses.
/// Retries failed requests once with new tokens.
class AuthInterceptor extends Interceptor {
  final TokenManager _tokenManager;
  final Dio _dio;

  // Track retried requests to prevent infinite loops
  final Set<String> _retriedRequests = {};

  AuthInterceptor({
    required TokenManager tokenManager,
    required Dio dio,
  })  : _tokenManager = tokenManager,
        _dio = dio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for certain endpoints
    if (_shouldSkipAuth(options.path)) {
      return handler.next(options);
    }

    // Get valid tokens (will refresh if needed)
    final tokens = await _tokenManager.getValidTokens();

    if (tokens != null) {
      // Add authorization header
      options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
      
      // NEVER log the token
      debugPrint('[AuthInterceptor] Added auth header to: ${options.path}');
    } else {
      debugPrint('[AuthInterceptor] No valid tokens for: ${options.path}');
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Check if this is a 401 Unauthorized error
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    debugPrint('[AuthInterceptor] 401 Unauthorized: ${err.requestOptions.path}');

    // Generate request ID for tracking retries
    final requestId = _generateRequestId(err.requestOptions);

    // Check if this request was already retried
    if (_retriedRequests.contains(requestId)) {
      debugPrint('[AuthInterceptor] Request already retried: $requestId');
      _retriedRequests.remove(requestId);
      return handler.next(err);
    }

    // Try to refresh tokens and retry
    debugPrint('[AuthInterceptor] Attempting token refresh for retry...');

    // Get new tokens
    final tokens = await _tokenManager.getValidTokens();

    if (tokens == null) {
      debugPrint('[AuthInterceptor] Token refresh failed, cannot retry');
      return handler.next(err);
    }

    debugPrint('[AuthInterceptor] Token refresh successful, retrying request');

    // Mark this request as retried
    _retriedRequests.add(requestId);

    try {
      // Clone the request with new token
      final options = err.requestOptions;
      options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';

      // Retry the request
      final response = await _dio.fetch(options);

      // Remove from retried set
      _retriedRequests.remove(requestId);

      // Return successful response
      return handler.resolve(response);
    } catch (e) {
      // Remove from retried set
      _retriedRequests.remove(requestId);

      debugPrint('[AuthInterceptor] Retry failed: $e');
      
      // If retry fails, pass the original error
      return handler.next(err);
    }
  }

  /// Check if authentication should be skipped for this endpoint
  bool _shouldSkipAuth(String path) {
    final skipPaths = [
      '/auth/login',
      '/auth/verify-otp',
      '/auth/refresh-token',
      '/auth/resend-otp',
    ];

    return skipPaths.any((skip) => path.contains(skip));
  }

  /// Generate unique request ID for tracking retries
  String _generateRequestId(RequestOptions options) {
    return '${options.method}_${options.path}_${options.queryParameters}';
  }

  /// Clear retry tracking
  void clearRetryTracking() {
    _retriedRequests.clear();
  }
}
