import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/models/auth_models.dart';
import '../domain/repositories/auth_repository.dart';
import '../data/services/token_manager.dart';

/// Authentication cubit managing the entire auth flow
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  final TokenManager _tokenManager;

  AuthCubit(this._repository, this._tokenManager)
      : super(AuthInitial());

  /// Check if user is already authenticated
  Future<void> checkAuthStatus() async {
    emit(AuthChecking());

    final tokens = await _repository.getStoredTokens();
    final user = await _repository.getStoredUser();

    if (tokens != null && user != null && tokens.isValid) {
      emit(AuthAuthenticated(user: user, tokens: tokens));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  /// Login with phone and password
  Future<void> login({
    required String phone,
    required String password,
    String? deviceId,
    String? deviceName,
  }) async {
    emit(AuthLoading());

    final request = LoginRequest(
      phone: phone,
      password: password,
      deviceId: deviceId,
      deviceName: deviceName,
    );

    final result = await _repository.login(request);

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (response) {
        if (response.requiresOtp) {
          // OTP required
          emit(AuthOtpRequired(
            sessionId: response.sessionId!,
            phone: phone,
          ));
        } else if (response.requiresDeviceVerification) {
          // Device verification required
          emit(AuthDeviceVerificationRequired(
            deviceVerificationId: '', // TODO: Get from response
          ));
        } else {
          // Direct login successful
          _handleSuccessfulAuth(response.tokens!, response.user!);
        }
      },
    );
  }

  /// Verify OTP code
  Future<void> verifyOtp({
    required String sessionId,
    required String otp,
    String? deviceId,
  }) async {
    emit(AuthLoading());

    final request = OtpVerificationRequest(
      sessionId: sessionId,
      otp: otp,
      deviceId: deviceId,
    );

    final result = await _repository.verifyOtp(request);

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (response) {
        if (response.requiresDeviceVerification) {
          // Device verification required
          emit(AuthDeviceVerificationRequired(
            deviceVerificationId: response.deviceVerificationId!,
          ));
        } else {
          // OTP verification successful
          _handleSuccessfulAuth(response.tokens!, response.user!);
        }
      },
    );
  }

  /// Resend OTP code
  Future<void> resendOtp(String sessionId) async {
    final request = ResendOtpRequest(sessionId: sessionId);
    
    final result = await _repository.resendOtp(request);

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) {
        // OTP resent successfully
        // Keep current state (otpRequired) but show success message
        final currentState = state;
        if (currentState is AuthOtpRequired) {
          emit(AuthOtpRequired(
            sessionId: currentState.sessionId,
            phone: currentState.phone,
            otpResentAt: DateTime.now(),
          ));
        }
      },
    );
  }

  /// Verify device
  Future<void> verifyDevice({
    required String deviceVerificationId,
    required String deviceId,
    required String deviceName,
  }) async {
    emit(AuthLoading());

    final request = DeviceVerificationRequest(
      deviceVerificationId: deviceVerificationId,
      deviceId: deviceId,
      deviceName: deviceName,
    );

    final result = await _repository.verifyDevice(request);

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (response) {
        if (response.verified) {
          _handleSuccessfulAuth(response.tokens!, response.user!);
        } else {
          emit(AuthError(
            message: 'فشل التحقق من الجهاز',
          ));
        }
      },
    );
  }

  /// Logout
  Future<void> logout() async {
    // Mark logout in progress to prevent token refresh
    _tokenManager.markLoggingOut();

    // Call logout endpoint
    await _repository.logout();

    // Clear tokens and user
    await _repository.clearTokens();
    await _repository.clearUser();

    // Reset logout flag
    _tokenManager.resetLogoutFlag();

    emit(AuthUnauthenticated());
  }

  /// Handle successful authentication
  Future<void> _handleSuccessfulAuth(AuthTokens tokens, AuthUser user) async {
    // Save tokens and user
    await _repository.saveTokens(tokens);
    await _repository.saveUser(user);

    emit(AuthAuthenticated(user: user, tokens: tokens));
  }

  /// Handle notification deep link
  /// 
  /// If user is authenticated, navigate to the target.
  /// If not authenticated, store the pending navigation and show login.
  Future<void> handleNotificationDeepLink(NotificationPayload payload) async {
    final currentState = state;

    if (currentState is AuthAuthenticated) {
      // User is authenticated, navigate immediately
      emit(AuthAuthenticated(
        user: currentState.user,
        tokens: currentState.tokens,
        pendingNavigation: payload,
      ));
    } else {
      // User not authenticated, show login with pending navigation
      emit(AuthUnauthenticated(pendingNavigation: payload));
    }
  }

  /// Clear pending navigation after it's handled
  void clearPendingNavigation() {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      emit(AuthAuthenticated(
        user: currentState.user,
        tokens: currentState.tokens,
      ));
    }
  }
}

/// Authentication state
abstract class AuthState {}

/// Initial state
class AuthInitial extends AuthState {}

/// Checking authentication status
class AuthChecking extends AuthState {}

/// Loading (login/verification in progress)
class AuthLoading extends AuthState {}

/// Unauthenticated - show login
class AuthUnauthenticated extends AuthState {
  final NotificationPayload? pendingNavigation;
  AuthUnauthenticated({this.pendingNavigation});
}

/// OTP required
class AuthOtpRequired extends AuthState {
  final String sessionId;
  final String phone;
  final DateTime? otpResentAt;
  AuthOtpRequired({
    required this.sessionId,
    required this.phone,
    this.otpResentAt,
  });
}

/// Device verification required
class AuthDeviceVerificationRequired extends AuthState {
  final String deviceVerificationId;
  AuthDeviceVerificationRequired({required this.deviceVerificationId});
}

/// Authenticated successfully
class AuthAuthenticated extends AuthState {
  final AuthUser user;
  final AuthTokens tokens;
  final NotificationPayload? pendingNavigation;
  AuthAuthenticated({
    required this.user,
    required this.tokens,
    this.pendingNavigation,
  });
}

/// Error
class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}
