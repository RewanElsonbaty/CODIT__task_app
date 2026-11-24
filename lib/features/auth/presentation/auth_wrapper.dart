import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_cubit.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/device_verification_screen.dart';

/// Authentication wrapper that handles navigation based on auth state
/// 
/// This widget listens to AuthCubit and displays the appropriate screen
/// based on the current authentication state.
class AuthWrapper extends StatelessWidget {
  /// The home widget to display when user is authenticated
  final Widget home;

  const AuthWrapper({
    super.key,
    required this.home,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        _handleStateChanges(context, state);
      },
      builder: (context, state) {
        if (state is AuthInitial || state is AuthChecking) {
          return const SplashScreen();
        } else if (state is AuthLoading) {
          return _buildLoadingScreen();
        } else if (state is AuthUnauthenticated) {
          return const LoginScreen();
        } else if (state is AuthOtpRequired) {
          return OtpScreen(
            sessionId: state.sessionId,
            phone: state.phone,
          );
        } else if (state is AuthDeviceVerificationRequired) {
          return DeviceVerificationScreen(
            verificationId: state.deviceVerificationId,
          );
        } else if (state is AuthAuthenticated) {
          // Handle pending navigation from deep link
          if (state.pendingNavigation != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _handleDeepLink(context, state.pendingNavigation!);
            });
          }
          return home;
        } else if (state is AuthError) {
          return _buildErrorScreen(context, state.message);
        }
        return const SplashScreen();
      },
    );
  }

  /// Handle state changes (errors, success messages, etc.)
  void _handleStateChanges(BuildContext context, AuthState state) {
    if (state is AuthError) {
      _showErrorSnackBar(context, state.message);
    } else if (state is AuthAuthenticated) {
      _showSuccessSnackBar(context, 'تم تسجيل الدخول بنجاح');
    }
  }

  /// Handle deep link navigation from notifications
  void _handleDeepLink(BuildContext context, payload) {
    // Clear pending navigation first
    context.read<AuthCubit>().clearPendingNavigation();

    // Navigate based on notification type
    switch (payload.type) {
      case 'approval_request':
        _navigateToApproval(context, payload.id);
        break;
      case 'sale':
        _navigateToSale(context, payload.id);
        break;
      case 'installment':
        _navigateToInstallment(context, payload.id);
        break;
      case 'return':
        _navigateToReturn(context, payload.id);
        break;
      default:
        debugPrint('Unknown notification type: ${payload.type}');
    }
  }

  /// Navigate to approval details
  void _navigateToApproval(BuildContext context, String approvalId) {
    Navigator.pushNamed(
      context,
      '/approvals/$approvalId',
      arguments: {'id': approvalId},
    );
  }

  /// Navigate to sale details
  void _navigateToSale(BuildContext context, String saleId) {
    Navigator.pushNamed(
      context,
      '/sales/$saleId',
      arguments: {'id': saleId},
    );
  }

  /// Navigate to installment details
  void _navigateToInstallment(BuildContext context, String installmentId) {
    Navigator.pushNamed(
      context,
      '/installments/$installmentId',
      arguments: {'id': installmentId},
    );
  }

  /// Navigate to return details
  void _navigateToReturn(BuildContext context, String returnId) {
    Navigator.pushNamed(
      context,
      '/returns/$returnId',
      arguments: {'id': returnId},
    );
  }

  /// Show error snack bar
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFE53935),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Show success snack bar
  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Build loading screen
  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              const Color(0xFF1A1A1A),
              const Color(0xFF000000),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFD4AF37),
                      const Color(0xFFB8941E),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4AF37).withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'جاري التحميل...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build error screen
  Widget _buildErrorScreen(BuildContext context, String message) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              const Color(0xFF1A1A1A),
              const Color(0xFF000000),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Error icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE53935).withOpacity(0.2),
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Color(0xFFE53935),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Error title
                  const Text(
                    'حدث خطأ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Error message
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Retry button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<AuthCubit>().checkAuthStatus();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                        shadowColor:
                            const Color(0xFFD4AF37).withOpacity(0.5),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh, size: 24),
                          SizedBox(width: 12),
                          Text(
                            'إعادة المحاولة',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
