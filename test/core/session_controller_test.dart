import 'package:codit/core/network/session_controller.dart';
import 'package:codit/core/security/secure_storage_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  final memory = <String, String>{};

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      switch (call.method) {
        case 'write':
          final args = call.arguments as Map;
          memory[args['key'] as String] = args['value'] as String;
          return null;
        case 'read':
          return memory[(call.arguments as Map)['key'] as String];
        case 'deleteAll':
          memory.clear();
          return null;
        default:
          return null;
      }
    });
  });

  test('only one refresh runs for concurrent waiters', () async {
    final storage = SecureStorageService();
    await storage.saveSession(
      accessToken: 'a',
      refreshToken: 'r',
      sessionGeneration: 1,
    );
    final session = SessionController(storage);
    await session.loadGeneration();

    var refreshCalls = 0;
    Future<bool> refresh(String _) async {
      refreshCalls++;
      await Future<void>.delayed(const Duration(milliseconds: 30));
      return true;
    }

    final results = await Future.wait([
      session.refreshOnce(refresh),
      session.refreshOnce(refresh),
      session.refreshOnce(refresh),
    ]);

    expect(refreshCalls, 1);
    expect(results.every((r) => r), isTrue);
  });
}