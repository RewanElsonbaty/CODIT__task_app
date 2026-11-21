import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../domain/models/auth_models.dart';
import '../domain/repositories/auth_repository.dart';
import '../data/services/token_manager.dart';

part 'auth_cubit.freezed.dart';

/// Authentication cubit managing the entire auth flow
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  final TokenManager _tokenManager;

  AuthCubit(this._repository, this._tokenManager)
      : super(const AuthState.initial());

  /// Check if user is already authenticated
  Future<void> checkAuthStatus() async {
    emit(const AuthState.checking());

    final tokens = await _repository.getStoredTokens();
    final user = await _repository.getStoredUser();

    if (tokens != null && user != null && tokens.isValid) {
      emit(AuthState.authenticated(user: user, tokens: tokens));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  /// Login with phone and password
  Future<void> login({
    required String phone,
    required String password,
    String? deviceId,
    String? deviceName,
  }) async {
    emit(const AuthState.loading());

    final request = LoginRequest(
      phone: phone,
      password: password,
      deviceId: deviceId,
      deviceName: deviceName,
    );

    final result = await _repository.login(request);

    result.fold(
      (failure) => emit(AuthState.error(message: failure.message)),
      (response) {
        if (response.requiresOtp) {
          // OTP required
          emit(AuthState.otpRequired(
            sessionId: response.sessionId!,
            phone: phone,
          ));
        } else if (response.requiresDeviceVerification) {
          // Device verification required
          emit(const AuthState.deviceVerificationRequired(
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
    emit(const AuthState.loading());

    final request = OtpVerificationRequest(
      sessionId: sessionId,
      otp: otp,
      deviceId: deviceId,
    );

    final result = await _repository.verifyOtp(request);

    result.fold(
      (failure) => emit(AuthState.error(message: failure.message)),
      (response) {
        if (response.requiresDeviceVerification) {
          // Device verification required
          emit(AuthState.deviceVerificationRequired(
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
      (failure) => emit(AuthState.error(message: failure.message)),
      (_) {
        // OTP resent successfully
        // Keep current state (otpRequired) but show success message
        state.maybeWhen(
          otpRequired: (sessionId, phone, _) {
            emit(AuthState.otpRequired(
              sessionId: sessionId,
              phone: phone,
              otpResentAt: DateTime.now(),
            ));
          },
          orElse: () {},
        );
      },
    );
  }

  /// Verify device
  Future<void> verifyDevice({
    required String deviceVerificationId,
    required String deviceId,
    required String deviceName,
  }) async {
    emit(const AuthState.loading());

    final request = DeviceVerificationRequest(
      deviceVerificationId: deviceVerificationId,
      deviceId: deviceId,
      deviceName: deviceName,
    );

    final result = await _repository.verifyDevice(request);

    result.fold(
      (failure) => emit(AuthState.error(message: failure.message)),
      (response) {
        if (response.verified) {
          _handleSuccessfulAuth(response.tokens!, response.user!);
        } else {
          emit(const AuthState.error(
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

    emit(const AuthState.unauthenticated());
  }

  /// Handle successful authentication
  Future<void> _handleSuccessfulAuth(AuthTokens tokens, AuthUser user) async {
    // Save tokens and user
    await _repository.saveTokens(tokens);
    await _repository.saveUser(user);

    emit(AuthState.authenticated(user: user, tokens: tokens));
  }

  /// Handle notification deep link
  /// 
  /// If user is authenticated, navigate to the target.
  /// If not authenticated, store the pending navigation and show login.
  Future<void> handleNotificationDeepLink(NotificationPayload payload) async {
    final currentState = state;

    if (currentState is _Authenticated) {
      // User is authenticated, navigate immediately
      emit(AuthState.authenticated(
        user: currentState.user,
        tokens: currentState.tokens,
        pendingNavigation: payload,
      ));
    } else {
      // User not authenticated, show login with pending navigation
      emit(AuthState.unauthenticated(pendingNavigation: payload));
    }
  }

  /// Clear pending navigation after it's handled
  void clearPendingNavigation() {
    final currentState = state;
    if (currentState is _Authenticated) {
      emit(AuthState.authenticated(
        user: currentState.user,
        tokens: currentState.tokens,
      ));
    }
  }
}

/// Authentication state
@freezed
class AuthState with _$AuthState {
  /// Initial state
  const factory AuthState.initial() = _Initial;

  /// Checking authentication status
  const factory AuthState.checking() = _Checking;

  /// Loading (login/verification in progress)
  const factory AuthState.loading() = _Loading;

  /// Unauthenticated - show login
  const factory AuthState.unauthenticated({
    NotificationPayload? pendingNavigation,
  }) = _Unauthenticated;

  /// OTP required
  const factory AuthState.otpRequired({
    required String sessionId,
    required String phone,
    DateTime? otpResentAt,
  }) = _OtpRequired;

  /// Device verification required
  const factory AuthState.deviceVerificationRequired({
    required String deviceVerificationId,
  }) = _DeviceVerificationRequired;

  /// Authenticated successfully
  const factory AuthState.authenticated({
    required AuthUser user,
    required AuthTokens tokens,
    NotificationPayload? pendingNavigation,
  }) = _Authenticated;

  /// Error
  const factory AuthState.error({
    required String message,
  }) = _Error;
}
