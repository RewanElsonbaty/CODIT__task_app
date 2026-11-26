class ServerException implements Exception {
  ServerException(this.message, {this.code});
  final String message;
  final int? code;
  
  @override
  String toString() => 'ServerException: $message (code: $code)';
}

class NetworkException implements Exception {
  NetworkException([this.message = 'Network error']);
  final String message;
  
  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  CacheException([this.message = 'Cache error']);
  final String message;
  
  @override
  String toString() => 'CacheException: $message';
}

class ValidationException implements Exception {
  ValidationException(this.message);
  final String message;
  
  @override
  String toString() => 'ValidationException: $message';
}

class ConflictException implements Exception {
  ConflictException(this.message);
  final String message;
  
  @override
  String toString() => 'ConflictException: $message';
}

class VersionConflictException implements Exception {
  VersionConflictException({this.message = 'version conflict', this.latestVersion});
  final String message;
  final int? latestVersion;
  
  @override
  String toString() => 'VersionConflictException: $message (latest: $latestVersion)';
}

class AuthException implements Exception {
  AuthException([this.message = 'Unauthorized']);
  final String message;
  
  @override
  String toString() => 'AuthException: $message';
}

class MockNetworkException implements Exception {
  MockNetworkException(this.message);
  final String message;
  
  @override
  String toString() => 'MockNetworkException: $message';
}

class NotFoundException implements Exception {
  NotFoundException(this.message);
  final String message;
  
  @override
  String toString() => 'NotFoundException: $message';
}

class UnauthorizedException implements Exception {
  UnauthorizedException([this.message = 'Unauthorized access']);
  final String message;
  
  @override
  String toString() => 'UnauthorizedException: $message';
}

class TimeoutException implements Exception {
  TimeoutException([this.message = 'Request timeout']);
  final String message;
  
  @override
  String toString() => 'TimeoutException: $message';
}