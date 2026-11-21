import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _accessToken = 'access_token';
  static const _refreshToken = 'refresh_token';
  static const _sessionGen = 'session_generation';

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required int sessionGeneration,
  }) async {
    await _storage.write(key: _accessToken, value: accessToken);
    await _storage.write(key: _refreshToken, value: refreshToken);
    await _storage.write(
      key: _sessionGen,
      value: sessionGeneration.toString(),
    );
  }

  Future<String?> get accessToken => _storage.read(key: _accessToken);

  Future<String?> get refreshToken => _storage.read(key: _refreshToken);

  Future<int> get sessionGeneration async {
    final v = await _storage.read(key: _sessionGen);
    return int.tryParse(v ?? '0') ?? 0;
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}