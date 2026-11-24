import 'package:codit/features/auth/presentation/auth_cubit.dart';
import 'package:codit/features/auth/presentation/screens/login_screen.dart';
import 'package:codit/features/auth/presentation/screens/otp_screen.dart';
import 'package:codit/features/auth/presentation/screens/device_verification_screen.dart';
import 'package:codit/features/gold_sales/presentation/gold_sale_page.dart';
import 'package:codit/features/notifications/presentation/pages/notifications_page.dart';
import 'package:codit/features/approvals/presentation/approvals_page.dart';
import 'package:codit/features/approvals/presentation/approval_details_screen.dart';
import 'package:codit/features/installments/presentation/installments_simple_page.dart';
import 'package:codit/features/branches/presentation/branches_simple_page.dart';
import 'package:codit/core/widgets/font_test_widget.dart';
import 'package:codit/mocks/scenario_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Router - opens directly to login
///
/// No splash screen - instant access to login
GoRouter buildRouter(AuthCubit authCubit) {
  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    refreshListenable: _AuthRefresh(authCubit),
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Navigation Error: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    ),
    redirect: (context, state) {
      final authState = authCubit.state;
      final loc = state.matchedLocation;

      final isAuthRoute =
          loc.startsWith('/login') ||
          loc.startsWith('/otp') ||
          loc.startsWith('/device');

      // If there's an error and not on auth route, go to login
      if (authState is AuthError && !isAuthRoute) return '/login';

      // Handle different auth states
      if (authState is AuthOtpRequired && loc != '/otp') {
        return '/otp';
      }

      if (authState is AuthDeviceVerificationRequired && loc != '/device') {
        return '/device';
      }

      // If not authenticated and not on auth route, go to login
      if (authState is! AuthAuthenticated && !isAuthRoute) {
        return '/login';
      }

      // If authenticated and on auth route, go to home
      if (authState is AuthAuthenticated && isAuthRoute) {
        return '/home';
      }

      return null;
    },
    routes: [
      // Auth Routes - Direct to login
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(
        path: '/otp',
        builder: (_, state) {
          final authState = authCubit.state;
          if (authState is AuthOtpRequired) {
            return OtpScreen(
              sessionId: authState.sessionId,
              phone: authState.phone,
            );
          }
          // Fallback if accessed directly
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/device',
        builder: (_, state) {
          final authState = authCubit.state;
          if (authState is AuthDeviceVerificationRequired) {
            return DeviceVerificationScreen(
              verificationId: authState.deviceVerificationId,
            );
          }
          // Fallback if accessed directly
          return const LoginScreen();
        },
      ),

      // Main Routes
      GoRoute(path: '/home', builder: (_, __) => const _HomePage()),
      GoRoute(
        path: '/notifications',
        builder: (_, __) => const NotificationsPage(),
      ),

      // Gold Sales
      GoRoute(path: '/gold', builder: (_, __) => const GoldSalePage()),

      // Approvals
      GoRoute(
        path: '/approvals',
        builder: (_, __) => const ApprovalsPage(),
      ),
      GoRoute(
        path: '/approvals/:id',
        builder: (_, state) {
          final id = state.pathParameters['id'];
          // في الواقع، يجب جلب التفاصيل من API
          // لكن للتبسيط، سنمرر placeholder
          return ApprovalDetailsScreen(
            request: {
              'id': id,
              'title': 'Loading...',
              'description': 'Loading details...',
              'type': 'discount',
              'status': 'pending',
              'priority': 'medium',
              'requester_name': 'Loading...',
              'created_at': DateTime.now().toIso8601String(),
              'version': 1,
              'metadata': {},
              'approvers': [],
            },
          );
        },
      ),

      // Installments
      GoRoute(
        path: '/installments',
        builder: (_, __) => const InstallmentsSimplePage(),
      ),

      // Branch Monitoring
      GoRoute(
        path: '/branches',
        builder: (_, __) => const BranchesSimplePage(),
      ),

      // Dev Tools
      GoRoute(
        path: '/dev/scenarios',
        builder: (_, __) => const ScenarioPanelPage(),
      ),
      GoRoute(path: '/dev/fonts', builder: (_, __) => const FontTestWidget()),
    ],
  );
}

class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(this._cubit) {
    _cubit.stream.listen((_) => notifyListeners());
  }
  final AuthCubit _cubit;
}

/// Simple home page placeholder
class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CODIT Gold Shop'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => context.go('/notifications'),
            tooltip: 'الإشعارات',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to CODIT Gold Shop',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.go('/gold'),
              child: const Text('Gold POS'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/approvals'),
              child: const Text('Approvals'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/installments'),
              child: const Text('Installments'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/branches'),
              child: const Text('Branch Monitoring'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/notifications'),
              child: const Text('Notifications'),
            ),
          ],
        ),
      ),
    );
  }
}
