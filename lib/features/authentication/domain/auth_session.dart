import 'package:equatable/equatable.dart';

enum AuthStep { unauthenticated, otp, device, authenticated }

class AuthSession extends Equatable {
  const AuthSession({
    this.step = AuthStep.unauthenticated,
    this.accessToken,
    this.accountId,
    this.shopName,
    this.userName,
    this.challengeId,
  });

  final AuthStep step;
  final String? accessToken;
  final String? accountId;
  final String? shopName;
  final String? userName;
  final String? challengeId;

  bool get isAuthenticated => step == AuthStep.authenticated;

  AuthSession copyWith({
    AuthStep? step,
    String? accessToken,
    String? accountId,
    String? shopName,
    String? userName,
    String? challengeId,
  }) {
    return AuthSession(
      step: step ?? this.step,
      accessToken: accessToken ?? this.accessToken,
      accountId: accountId ?? this.accountId,
      shopName: shopName ?? this.shopName,
      userName: userName ?? this.userName,
      challengeId: challengeId ?? this.challengeId,
    );
  }

  @override
  List<Object?> get props =>
      [step, accessToken, accountId, shopName, userName, challengeId];
}