import 'package:dio/dio.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/services/auth_interceptor.dart';
import '../data/services/device_info_service.dart';
import '../data/services/notification_service.dart';
import '../data/services/secure_storage_service.dart';
import '../data/services/token_manager.dart';
import '../domain/repositories/auth_repository.dart';
import '../presentation/auth_cubit.dart';

/// Setup authentication dependency injection
/// 
/// This function registers all authentication-related dependencies
/// with GetIt service locator.
void setupAuthDependencies(GetIt getIt) {
  // ==================== External Dependencies ====================
  
  // Flutter Secure Storage
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // Device Info Plugin
  getIt.registerLazySingleton<DeviceInfoPlugin>(
    () => DeviceInfoPlugin(),
  );

  // Firebase Messaging
  getIt.registerLazySingleton<FirebaseMessaging>(
    () => FirebaseMessaging.instance,
  );

  // ==================== Services ====================
  
  // Secure Storage Service
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(getIt<FlutterSecureStorage>()),
  );

  // Device Info Service
  getIt.registerLazySingleton<DeviceInfoService>(
    () => DeviceInfoService(getIt<DeviceInfoPlugin>()),
  );

  // Notification Service
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService(getIt<FirebaseMessaging>()),
  );

  // ==================== Repository ====================
  
  // Auth Repository (registered as singleton to share state)
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<Dio>(),
      getIt<SecureStorageService>(),
    ),
  );

  // Token Manager (must be singleton for single-flight to work)
  getIt.registerLazySingleton<TokenManager>(
    () => TokenManager(getIt<AuthRepository>()),
  );

  // ==================== Dio Setup ====================
  
  // Dio instance with auth interceptor
  // NOTE: This should be called AFTER TokenManager is registered
  if (!getIt.isRegistered<Dio>()) {
    getIt.registerLazySingleton<Dio>(() {
      final dio = Dio(
        BaseOptions(
          baseUrl: const String.fromEnvironment(
            'API_BASE_URL',
            defaultValue: 'https://api.example.com',
          ),
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      // Add auth interceptor
      dio.interceptors.add(
        AuthInterceptor(
          tokenManager: getIt<TokenManager>(),
          dio: dio,
        ),
      );

      // Add logging interceptor in debug mode
      if (const bool.fromEnvironment('dart.vm.product') == false) {
        dio.interceptors.add(
          LogInterceptor(
            requestBody: true,
            responseBody: true,
            error: true,
            requestHeader: false, // Don't log headers (may contain tokens)
          ),
        );
      }

      return dio;
    });
  }

  // ==================== BLoC ====================
  
  // Auth Cubit (factory - new instance each time)
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      getIt<AuthRepository>(),
      getIt<TokenManager>(),
    ),
  );
}

/// Initialize notification service
/// 
/// This should be called early in app initialization
Future<void> initializeNotifications(GetIt getIt) async {
  final notificationService = getIt<NotificationService>();
  await notificationService.initialize();
}
