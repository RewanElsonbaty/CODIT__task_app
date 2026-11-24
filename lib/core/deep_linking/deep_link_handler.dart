import 'package:codit/features/auth/presentation/auth_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class DeepLinkHandler {
  DeepLinkHandler(this._authCubit);

  final AuthCubit _authCubit;
  String? _pendingRoute;

  /// Handle incoming deep link
  Future<void> handleLink(String link, GoRouter router) async {
    debugPrint('[DeepLink] Received: $link');

    final uri = Uri.parse(link);

    // Parse approval deep link: codit://approval/{id}
    if (uri.host == 'approval' && uri.pathSegments.isNotEmpty) {
      final approvalId = uri.pathSegments.first;
      await _handleApprovalLink(approvalId, router);
      return;
    }

    debugPrint('[DeepLink] Unknown format: $link');
  }

  Future<void> _handleApprovalLink(String approvalId, GoRouter router) async {
    final authState = _authCubit.state;

    // If not authenticated, save pending route and wait for login
    if (authState is! AuthAuthenticated) {
      debugPrint('[DeepLink] Not authenticated, saving pending route');
      _pendingRoute = '/approvals/$approvalId';
      // User needs to log in first
      return;
    }

    // Check if already on the same route (prevent duplicates)
    final currentLocation = router.routeInformationProvider.value.uri.toString();
    if (currentLocation == '/approvals/$approvalId') {
      debugPrint('[DeepLink] Already on target route, ignoring');
      return;
    }

    // Navigate to approval details
    debugPrint('[DeepLink] Navigating to /approvals/$approvalId');
    router.go('/approvals/$approvalId');
  }

  /// Called after successful authentication to handle pending deep link
  void handlePendingLink(GoRouter router) {
    if (_pendingRoute != null) {
      debugPrint('[DeepLink] Handling pending route: $_pendingRoute');
      final route = _pendingRoute!;
      _pendingRoute = null;
      router.go(route);
    }
  }

  /// Clear pending link (e.g., on logout)
  void clearPending() {
    _pendingRoute = null;
  }
}
