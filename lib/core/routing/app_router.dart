import 'package:codit/features/authentication/domain/auth_session.dart';
import 'package:codit/features/authentication/presentation/authentication_cubit.dart';
import 'package:codit/features/authentication/presentation/device_verify_page.dart';
import 'package:codit/features/authentication/presentation/login_page.dart';
import 'package:codit/features/authentication/presentation/otp_page.dart';
import 'package:codit/features/authentication/presentation/splash_page.dart';
import 'package:codit/features/gold_sales/presentation/gold_sale_page.dart';
import 'package:codit/features/notifications/presentation/pages/notifications_page.dart';
import 'package:codit/core/widgets/font_test_widget.dart';
import 'package:codit/mocks/scenario_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Simplified router with 1-second splash screen
///
/// Shows splash for 1 second, then navigates to login
GoRouter buildRouter(AuthenticationCubit authCubit) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: _AuthRefresh(authCubit),
    redirect: (context, state) {
      final authState = authCubit.state;
      final session = authCubit.session;
      final loc = state.matchedLocation;

      final isAuthRoute =
          loc.startsWith('/login') ||
          loc.startsWith('/otp') ||
          loc.startsWith('/device') ||
          loc == '/';

      if (authState is AuthError && !isAuthRoute) return '/login';

      if (!session.isAuthenticated) {
        if (session.step == AuthStep.otp && loc != '/otp') return '/otp';
        if (session.step == AuthStep.device && loc != '/device')
          return '/device';
        if (!isAuthRoute) return '/login';
        return null;
      }

      if (isAuthRoute && loc != '/') return '/home';
      return null;
    },
    routes: [
      // Splash screen - shows for 1 second
      GoRoute(path: '/', builder: (_, _) => const SplashPage()),
      
      // Auth Routes
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

      // Approvals (placeholder for new screens)
      GoRoute(
        path: '/approvals',
        builder: (_, _) => const _PlaceholderPage(title: 'Approvals'),
      ),
      GoRoute(
        path: '/approvals/:id',
        builder: (_, state) => _PlaceholderPage(
          title: 'Approval Details',
          subtitle: 'ID: ${state.pathParameters['id']}',
        ),
      ),

      // Installments (placeholder for new screens)
      GoRoute(
        path: '/installments',
        builder: (_, _) => const _PlaceholderPage(title: 'Installments'),
      ),

      // Branch Monitoring (placeholder for new screens)
      GoRoute(
        path: '/branches',
        builder: (_, _) => const _PlaceholderPage(title: 'Branch Monitoring'),
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
