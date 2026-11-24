// ignore_for_file: unused_import, unused_element, unused_field, argument_type_not_assignable, type_argument_not_matching_bounds, extra_positional_arguments, undefined_named_parameter
// DEPRECATED: This file is not used anymore. Use lib/features/auth/ instead.
// @dart=2.19

import 'package:codit/core/errors/exceptions.dart';
import 'package:codit/features/authentication/data/auth_repository.dart';
import 'package:codit/features/authentication/domain/auth_session.dart';
import 'package:codit/features/authentication/domain/pending_deep_link.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class AuthenticationState {
  const AuthenticationState();
}

class AuthInitial extends AuthenticationState {}

class AuthLoading extends AuthenticationState {}

class AuthError extends AuthenticationState {
  const AuthError(this.message);
  final String message;
}

class AuthReady extends AuthenticationState {
  const AuthReady(this.session, {this.deepLinkTarget});
  final AuthSession session;
  final String? deepLinkTarget;
}

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit(this._repository) : super(AuthInitial());

  final AuthRepository _repository;
  AuthSession _session = const AuthSession();

  AuthSession get session => _session;

  Future<void> login(String phone, String password) async {
    emit(AuthLoading());
    try {
      _session = await _repository.login(phone, password);
      emit(AuthReady(_session));
    } on ServerException catch (e) {
      emit(AuthError(e.message));
    } catch (_) {
      emit(const AuthError('تعذر تسجيل الدخول'));
    }
  }

  Future<void> submitOtp(String otp) async {
    emit(AuthLoading());
    try {
      _session = await _repository.verifyOtp(otp, _session);
      emit(AuthReady(_session));
    } catch (_) {
      emit(const AuthError('رمز التحقق غير صحيح'));
    }
  }

  Future<void> verifyDevice() async {
    emit(AuthLoading());
    try {
      _session = await _repository.verifyDevice();
      String? target;
      if (PendingDeepLink.hasIntent &&
          PendingDeepLink.type == 'approval_request') {
        final allowed = await _repository.authorizeResource(
          PendingDeepLink.resourceId!,
        );
        if (allowed) target = PendingDeepLink.resourceId;
        PendingDeepLink.clear();
      }
      emit(AuthReady(_session, deepLinkTarget: target));
    } catch (_) {
      emit(const AuthError('فشل التحقق من الجهاز'));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    _session = const AuthSession();
    emit(AuthInitial());
  }

  void handleRefreshFailed() {
    _session = const AuthSession();
    emit(const AuthError('انتهت الجلسة'));
  }
}
