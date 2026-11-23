import 'package:codit/features/authentication/domain/auth_session.dart';
import 'package:codit/features/authentication/presentation/authentication_cubit.dart';
import 'package:codit/features/authentication/presentation/device_verify_page.dart';
import 'package:codit/features/authentication/presentation/login_page.dart';
import 'package:codit/features/authentication/presentation/otp_page.dart';
import 'package:codit/features/gold_sales/presentation/gold_sale_page.dart';
import 'package:codit/features/notifications/presentation/pages/notifications_page.dart';
import 'package:codit/features/approvals/presentation/approvals_page.dart';
import 'package:codit/features/installments/presentation/installments_page.dart';
import 'package:codit/features/branches/presentation/branches_page.dart';
import 'package:codit/core/widgets/font_test_widget.dart';
import 'package:codit/mocks/scenario_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Router - opens directly to login
///
/// No splash screen - instant access to login
GoRouter buildRouter(AuthenticationCubit authCubit) {
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
      final session = authCubit.session;
      final loc = state.matchedLocation;

      final isAuthRoute =
          loc.startsWith('/login') ||
          loc.startsWith('/otp') ||
          loc.startsWith('/device');

      if (authState is AuthError && !isAuthRoute) return '/login';

      if (!session.isAuthenticated) {
        if (session.step == AuthStep.otp && loc != '/otp') return '/otp';
        if (session.step == AuthStep.device && loc != '/device')
          return '/device';
        if (!isAuthRoute) return '/login';
        return null;
      }

      if (isAuthRoute) return '/home';
      return null;
    },
    routes: [
      // Auth Routes - Direct to login
      GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
      GoRoute(path: '/otp', builder: (_, _) => const OtpPage()),
      GoRoute(path: '/device', builder: (_, _) => const DeviceVerifyPage()),

      // Main Routes
      GoRoute(path: '/home', builder: (_, _) => const _HomePage()),
      GoRoute(
        path: '/notifications',
        builder: (_, _) => const NotificationsPage(),
      ),

      // Gold Sales
      GoRoute(path: '/gold', builder: (_, _) => const GoldSalePage()),

      // Approvals
      GoRoute(
        path: '/approvals',
        builder: (_, _) => const ApprovalsPage(),
      ),
      GoRoute(
        path: '/approvals/:id',
        builder: (_, state) => _PlaceholderPage(
          title: 'Approval Details',
          subtitle: 'ID: ${state.pathParameters['id']}',
        ),
      ),

      // Installments
      GoRoute(
        path: '/installments',
        builder: (_, _) => const InstallmentsPage(),
      ),

      // Branch Monitoring
      GoRoute(
        path: '/branches',
        builder: (_, _) => const BranchesPage(),
      ),

      // Dev Tools
      GoRoute(
        path: '/dev/scenarios',
        builder: (_, _) => const ScenarioPanelPage(),
      ),
      GoRoute(path: '/dev/fonts', builder: (_, _) => const FontTestWidget()),
    ],
  );
}

class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(this._cubit) {
    _cubit.stream.listen((_) => notifyListeners());
  }
  final AuthenticationCubit _cubit;
}

/// Simple home page placeholder
class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CODIT Gold Shop')),
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
          ],
        ),
      ),
    );
  }
}

/// Placeholder page for modules under development
class _PlaceholderPage extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _PlaceholderPage({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 64),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(subtitle!),
            ],
            const SizedBox(height: 16),
            const Text('Screen under development'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
