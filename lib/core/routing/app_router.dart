import 'package:codit/features/auth/presentation/auth_cubit.dart';
import 'package:codit/features/auth/presentation/screens/login_screen.dart';
import 'package:codit/features/auth/presentation/screens/otp_screen.dart';
import 'package:codit/features/auth/presentation/screens/device_verification_screen.dart';
import 'package:codit/features/gold_sales/presentation/gold_sale_page.dart';
import 'package:codit/features/notifications/presentation/pages/notifications_page.dart';
import 'package:codit/features/approvals/presentation/approvals_page.dart';
import 'package:codit/features/approvals/presentation/approval_details_screen.dart';
import 'package:codit/features/approvals/presentation/installment_requests_page.dart';
import 'package:codit/features/approvals/presentation/create_installment_request_page.dart';
import 'package:codit/features/installments/presentation/installments_simple_page.dart';
import 'package:codit/features/branches/presentation/branches_simple_page.dart';
import 'package:codit/features/branches/presentation/branch_details_page.dart';
import 'package:codit/features/branches/presentation/branch_installments_page.dart';
import 'package:codit/features/admin/presentation/admin_dashboard_page.dart';
import 'package:codit/features/admin/presentation/staff_reports_page.dart';
import 'package:codit/features/manager/presentation/manager_dashboard_page.dart';
import 'package:codit/features/home/presentation/home_page.dart';
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
      GoRoute(path: '/home', builder: (_, __) => const HomePage()),
      GoRoute(
        path: '/notifications',
        builder: (_, __) => const NotificationsPage(),
      ),

      // Gold Sales
      GoRoute(
        path: '/gold',
        redirect: (context, state) {
          final authState = authCubit.state;
          if (authState is AuthAuthenticated) {
            final permissions = authState.user.permissions;
            if (permissions.contains('all') || 
                permissions.contains('gold_sales') || 
                permissions.contains('gold_pos')) {
              return null; // Allow access
            }
          }
          return '/home'; // Redirect to home if no permission
        },
        builder: (_, __) => const GoldSalePage(),
      ),

      // Approvals
      GoRoute(
        path: '/approvals',
        redirect: (context, state) {
          final authState = authCubit.state;
          if (authState is AuthAuthenticated) {
            final permissions = authState.user.permissions;
            if (permissions.contains('all') || 
                permissions.contains('approvals') || 
                permissions.contains('approval_management')) {
              return null; // Allow access
            }
          }
          return '/home'; // Redirect to home if no permission
        },
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
        redirect: (context, state) {
          final authState = authCubit.state;
          if (authState is AuthAuthenticated) {
            final permissions = authState.user.permissions;
            if (permissions.contains('all') || 
                permissions.contains('installments') || 
                permissions.contains('payments') ||
                permissions.contains('installments_pos')) {
              return null; // Allow access
            }
          }
          return '/home'; // Redirect to home if no permission
        },
        builder: (_, __) => const InstallmentsSimplePage(),
      ),

      // Branch Monitoring
      GoRoute(
        path: '/branches',
        redirect: (context, state) {
          final authState = authCubit.state;
          if (authState is AuthAuthenticated) {
            final permissions = authState.user.permissions;
            if (permissions.contains('all') || 
                permissions.contains('branches') || 
                permissions.contains('monitoring')) {
              return null; // Allow access
            }
          }
          return '/home'; // Redirect to home if no permission
        },
        builder: (_, __) => const BranchesSimplePage(),
      ),
      // Branch Details
      GoRoute(
        path: '/branch-details/:branchId',
        redirect: (context, state) {
          final authState = authCubit.state;
          if (authState is AuthAuthenticated) {
            final permissions = authState.user.permissions;
            if (permissions.contains('all') || 
                permissions.contains('branches') || 
                permissions.contains('monitoring')) {
              return null;
            }
          }
          return '/home';
        },
        builder: (context, state) {
          final branchId = state.pathParameters['branchId']!;
          return BranchDetailsPage(branchId: branchId);
        },
      ),
      // Branch Installments
      GoRoute(
        path: '/branch-installments/:branchId',
        redirect: (context, state) {
          final authState = authCubit.state;
          if (authState is AuthAuthenticated) {
            final permissions = authState.user.permissions;
            if (permissions.contains('all') || 
                permissions.contains('branches') ||
                permissions.contains('installments') ||
                permissions.contains('monitoring')) {
              return null;
            }
          }
          return '/home';
        },
        builder: (context, state) {
          final branchId = state.pathParameters['branchId']!;
          final extra = state.extra as Map<String, dynamic>?;
          final branchName = extra?['branchName'] as String?;
          return BranchInstallmentsPage(
            branchId: branchId,
            branchName: branchName,
          );
        },
      ),

      // Admin Routes (للمالك فقط)
      GoRoute(
        path: '/admin',
        redirect: (context, state) {
          final authState = authCubit.state;
          if (authState is AuthAuthenticated) {
            final permissions = authState.user.permissions;
            if (permissions.contains('all')) {
              return null; // Allow access - owner only
            }
          }
          return '/home'; // Redirect if not owner
        },
        builder: (_, __) => const AdminDashboardPage(),
      ),
      
      // Staff Reports (للمالك فقط)
      GoRoute(
        path: '/admin/staff-reports',
        redirect: (context, state) {
          final authState = authCubit.state;
          if (authState is AuthAuthenticated) {
            final permissions = authState.user.permissions;
            if (permissions.contains('all')) {
              return null; // Allow access - owner only
            }
          }
          return '/home'; // Redirect if not owner
        },
        builder: (_, __) => const StaffReportsPage(),
      ),

      // Manager Routes (للمدير فقط - يرى الموافقات وإدارة الفريق فقط)
      GoRoute(
        path: '/manager',
        redirect: (context, state) {
          final authState = authCubit.state;
          if (authState is AuthAuthenticated) {
            final permissions = authState.user.permissions;
            if (permissions.contains('staff_management') || 
                permissions.contains('approvals')) {
              return null; // Allow access - manager only
            }
          }
          return '/home'; // Redirect if not manager
        },
        builder: (_, __) => const ManagerDashboardPage(),
      ),

      // Installment Requests (طلبات التقسيط)
      GoRoute(
        path: '/installment-requests',
        redirect: (context, state) {
          final authState = authCubit.state;
          if (authState is AuthAuthenticated) {
            final permissions = authState.user.permissions;
            if (permissions.contains('all') || 
                permissions.contains('installments') ||
                permissions.contains('approvals')) {
              return null;
            }
          }
          return '/home';
        },
        builder: (_, state) {
          final authState = authCubit.state;
          String userRole = 'manager';
          String? branchId;
          
          if (authState is AuthAuthenticated) {
            if (authState.user.permissions.contains('all')) {
              userRole = 'owner';
            } else {
              userRole = 'manager';
              branchId = authState.user.branchId;
            }
          }
          
          return InstallmentRequestsPage(
            userRole: userRole,
            branchId: branchId,
          );
        },
      ),
      
      GoRoute(
        path: '/create-installment-request',
        redirect: (context, state) {
          final authState = authCubit.state;
          if (authState is AuthAuthenticated) {
            final permissions = authState.user.permissions;
            if (permissions.contains('installments') ||
                permissions.contains('approvals')) {
              return null;
            }
          }
          return '/home';
        },
        builder: (_, __) => const CreateInstallmentRequestPage(),
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
