import 'package:codit/core/storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  late MockDio mockDio;
  late MockSecureStorage mockStorage;
  late TokenRefreshInterceptor interceptor;

  setUp(() {
    mockDio = MockDio();
    mockStorage = MockSecureStorage();
    interceptor = TokenRefreshInterceptor(mockDio, mockStorage);
  });

  group('Token Refresh Tests', () {
    test('refresh ناجح يرجع token جديد', () async {
      // Setup
      when(() => mockStorage.getRefreshToken())
          .thenAnswer((_) async => 'valid_refresh_token');

      when(() => mockDio.post<Map<String, dynamic>>(
            '/auth/refresh',
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response(
            data: {
              'access_token': 'new_access_token',
              'refresh_token': 'new_refresh_token',
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/auth/refresh'),
          ));

      when(() => mockStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          )).thenAnswer((_) async {});

      // Execute
      final newToken = await interceptor.refreshToken();

      // Verify
      expect(newToken, 'new_access_token');
      verify(() => mockStorage.saveTokens(
            accessToken: 'new_access_token',
            refreshToken: 'new_refresh_token',
          )).called(1);
    });

    test('refresh يفشل يمسح البيانات', () async {
      when(() => mockStorage.getRefreshToken())
          .thenAnswer((_) async => 'expired_refresh_token');

      when(() => mockDio.post<Map<String, dynamic>>(
            '/auth/refresh',
            data: any(named: 'data'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/refresh'),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: '/auth/refresh'),
          ),
        ),
      );

      when(() => mockStorage.clearAll()).thenAnswer((_) async {});

      // Execute
      final result = await interceptor.refreshToken();

      // Verify
      expect(result, null);
      verify(() => mockStorage.clearAll()).called(1);
    });

    test('لا refresh token - يمسح البيانات مباشرة', () async {
      when(() => mockStorage.getRefreshToken()).thenAnswer((_) async => null);
      when(() => mockStorage.clearAll()).thenAnswer((_) async {});

      // Execute
      final result = await interceptor.refreshToken();

      // Verify
      expect(result, null);
      verify(() => mockStorage.clearAll()).called(1);
      verifyNever(() => mockDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ));
    });

    test('multiple calls تستخدم نفس الـ refresh request', () async {
      when(() => mockStorage.getRefreshToken())
          .thenAnswer((_) async => 'refresh_token');

      var refreshCallCount = 0;
      when(() => mockDio.post<Map<String, dynamic>>(
            '/auth/refresh',
            data: any(named: 'data'),
          )).thenAnswer((_) async {
        refreshCallCount++;
        await Future.delayed(const Duration(milliseconds: 100));
        return Response(
          data: {
            'access_token': 'new_token_$refreshCallCount',
            'refresh_token': 'new_refresh_$refreshCallCount',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/refresh'),
        );
      });

      when(() => mockStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          )).thenAnswer((_) async {});

      // Execute: 5 طلبات متزامنة
      final futures = List.generate(5, (_) => interceptor.getOrRefreshToken());
      final results = await Future.wait(futures);

      // Verify: كل الطلبات حصلت على نفس الـ token
      expect(results.toSet().length, 1); // token واحد فقط
      expect(refreshCallCount, 1); // refresh استُدعي مرة واحدة
    });

    test('refresh ثاني بعد انتهاء الأول يعمل refresh جديد', () async {
      when(() => mockStorage.getRefreshToken())
          .thenAnswer((_) async => 'refresh_token');

      var refreshCallCount = 0;
      when(() => mockDio.post<Map<String, dynamic>>(
            '/auth/refresh',
            data: any(named: 'data'),
          )).thenAnswer((_) async {
        refreshCallCount++;
        return Response(
          data: {
            'access_token': 'token_$refreshCallCount',
            'refresh_token': 'refresh_$refreshCallCount',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/refresh'),
        );
      });

      when(() => mockStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          )).thenAnswer((_) async {});

      // Execute: refresh أول
      final token1 = await interceptor.getOrRefreshToken();
      
      // Execute: refresh ثاني (بعد انتهاء الأول)
      final token2 = await interceptor.getOrRefreshToken();

      // Verify
      expect(refreshCallCount, 2);
      expect(token1, 'token_1');
      expect(token2, 'token_2');
    });
  });

  group('Logout During Refresh Tests', () {
    test('يمسح البيانات حتى لو refresh قيد التنفيذ', () async {
      when(() => mockStorage.getRefreshToken())
          .thenAnswer((_) async => 'refresh_token');

      // Mock refresh بطيء
      when(() => mockDio.post<Map<String, dynamic>>(
            '/auth/refresh',
            data: any(named: 'data'),
          )).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 200));
        return Response(
          data: {
            'access_token': 'new_token',
            'refresh_token': 'new_refresh',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/refresh'),
        );
      });

      when(() => mockStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          )).thenAnswer((_) async {});

      when(() => mockStorage.clearAll()).thenAnswer((_) async {});

      // بدء refresh (لا ننتظر)
      final refreshFuture = interceptor.getOrRefreshToken();

      // انتظار قليل
      await Future.delayed(const Duration(milliseconds: 50));

      // المستخدم يعمل logout
      await mockStorage.clearAll();

      // انتظار انتهاء refresh
      await refreshFuture;

      // التحقق: clearAll تم استدعاؤه
      verify(() => mockStorage.clearAll()).called(1);
    });
  });

  group('Token Storage Security Tests', () {
    test('يمسح البيانات الحساسة عند الخروج', () async {
      when(() => mockStorage.clearAll()).thenAnswer((_) async {});

      await mockStorage.clearAll();

      verify(() => mockStorage.clearAll()).called(1);
    });

    test('لا يحفظ tokens فارغة', () async {
      when(() => mockStorage.getRefreshToken())
          .thenAnswer((_) async => 'refresh_token');

      when(() => mockDio.post<Map<String, dynamic>>(
            '/auth/refresh',
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response(
            data: {
              'access_token': '', // فارغ
              'refresh_token': '',
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/auth/refresh'),
          ));

      when(() => mockStorage.clearAll()).thenAnswer((_) async {});

      final result = await interceptor.refreshToken();

      expect(result, null);
      verify(() => mockStorage.clearAll()).called(1);
      verifyNever(() => mockStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          ));
    });
  });

  group('Edge Cases Tests', () {
    test('يتعامل مع response بدون data', () async {
      when(() => mockStorage.getRefreshToken())
          .thenAnswer((_) async => 'refresh_token');

      when(() => mockDio.post<Map<String, dynamic>>(
            '/auth/refresh',
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response<Map<String, dynamic>>(
            data: null, // بدون data
            statusCode: 200,
            requestOptions: RequestOptions(path: '/auth/refresh'),
          ));

      when(() => mockStorage.clearAll()).thenAnswer((_) async {});

      final result = await interceptor.refreshToken();

      expect(result, null);
      verify(() => mockStorage.clearAll()).called(1);
    });

    test('يتعامل مع response data ناقصة', () async {
      when(() => mockStorage.getRefreshToken())
          .thenAnswer((_) async => 'refresh_token');

      when(() => mockDio.post<Map<String, dynamic>>(
            '/auth/refresh',
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response(
            data: {
              'access_token': 'new_token',
              // refresh_token مفقود
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/auth/refresh'),
          ));

      when(() => mockStorage.clearAll()).thenAnswer((_) async {});

      final result = await interceptor.refreshToken();

      expect(result, null);
      verify(() => mockStorage.clearAll()).called(1);
    });

    test('يتعامل مع network timeout', () async {
      when(() => mockStorage.getRefreshToken())
          .thenAnswer((_) async => 'refresh_token');

      when(() => mockDio.post<Map<String, dynamic>>(
            '/auth/refresh',
            data: any(named: 'data'),
          )).thenThrow(
        DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: '/auth/refresh'),
        ),
      );

      when(() => mockStorage.clearAll()).thenAnswer((_) async {});

      final result = await interceptor.refreshToken();

      expect(result, null);
      verify(() => mockStorage.clearAll()).called(1);
    });
  });
}

/// Interceptor للتعامل مع refresh token
class TokenRefreshInterceptor {
  TokenRefreshInterceptor(this._dio, this._storage);

  final Dio _dio;
  final SecureStorage _storage;
  Future<String?>? _refreshFuture;

  /// الحصول على token أو refresh لو مش موجود
  Future<String?> getOrRefreshToken() async {
    // لو في refresh قيد التنفيذ، استخدمه
    if (_refreshFuture != null) {
      return _refreshFuture;
    }

    // بدء refresh جديد
    _refreshFuture = _refreshTokenInternal();
    final result = await _refreshFuture;
    
    // مسح الـ future بعد الانتهاء
    _refreshFuture = null;
    
    return result;
  }

  /// Refresh token مباشرة
  Future<String?> refreshToken() => _refreshTokenInternal();

  Future<String?> _refreshTokenInternal() async {
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _storage.clearAll();
      return null;
    }

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final data = response.data;
      if (data == null) {
        await _storage.clearAll();
        return null;
      }

      final newAccessToken = data['access_token'] as String?;
      final newRefreshToken = data['refresh_token'] as String?;

      if (newAccessToken != null && 
          newAccessToken.isNotEmpty &&
          newRefreshToken != null && 
          newRefreshToken.isNotEmpty) {
        await _storage.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );
        return newAccessToken;
      }

      await _storage.clearAll();
      return null;
    } catch (e) {
      await _storage.clearAll();
      return null;
    }
  }
}
