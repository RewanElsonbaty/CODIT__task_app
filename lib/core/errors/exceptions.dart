class ServerException implements Exception {
  ServerException(this.message, {this.code});
  final String message;
  final int? code;
}

class NetworkException implements Exception {
  NetworkException([this.message = 'Network error']);
  final String message;
}

class CacheException implements Exception {
  CacheException([this.message = 'Cache error']);
  final String message;
}

class ValidationException implements Exception {
  ValidationException(this.message);
  final String message;
}

class ConflictException implements Exception {
  ConflictException(this.message);
  final String message;
}

class VersionConflictException implements Exception {
  VersionConflictException({this.message = 'version conflict', this.latestVersion});
  final String message;
  final int? latestVersion;
}

class AuthException implements Exception {
  AuthException([this.message = 'Unauthorized']);
  final String message;
}