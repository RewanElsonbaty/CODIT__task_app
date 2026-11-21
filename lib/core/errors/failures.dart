import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

final class ServerFailure extends Failure {
  const ServerFailure({super.message = 'خطأ في الخادم'});
}

final class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'لا يوجد اتصال بالإنترنت'});
}

final class CacheFailure extends Failure {
  const CacheFailure({super.message = 'خطأ محلي'});
}

final class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

final class ConflictFailure extends Failure {
  const ConflictFailure({required super.message});
}

final class AuthFailure extends Failure {
  const AuthFailure({super.message = 'انتهت الجلسة'});
}

final class VersionConflictFailure extends Failure {
  const VersionConflictFailure({
    super.message = 'تم تحديث الطلب — راجع النسخة الجديدة',
  });
}