import 'package:codit/core/config/app_config.dart';
import 'package:codit/core/cache/cache_manager.dart';
import 'package:codit/core/data/mock_gold_sales_api.dart';
import 'package:codit/core/database/app_database.dart';
import 'package:codit/core/network/network_info.dart';
import 'package:codit/core/security/secure_storage_service.dart';
import 'package:codit/core/utils/id_generator.dart';
import 'package:codit/features/authentication/data/mock_auth_api.dart';
import 'package:codit/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:codit/features/auth/domain/repositories/auth_repository.dart';
import 'package:codit/features/auth/presentation/auth_cubit.dart';
import 'package:codit/features/auth/data/services/token_manager.dart';
import 'package:codit/mocks/mock_api_server.dart';
import 'package:codit/mocks/mock_scenario_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

/// Configure core dependencies
Future<void> configureDependencies() async {
  if (getIt.isRegistered<AppConfig>()) return;

  // Core Config
  getIt.registerSingleton<AppConfig>(const AppConfig());
  getIt.registerSingleton<MockScenarioController>(MockScenarioController());
  getIt.registerSingleton<MockApiServer>(
    MockApiServer(getIt<MockScenarioController>(), getIt<AppConfig>()),
  );

  // Security & Storage
  getIt.registerSingleton<SecureStorageService>(SecureStorageService());
  
  // Flutter Secure Storage (for new auth)
  getIt.registerSingleton<FlutterSecureStorage>(
    const FlutterSecureStorage(),
  );

  // Database
  getIt.registerSingleton<AppDatabase>(AppDatabase());

  // Network
  getIt.registerSingleton<NetworkInfo>(NetworkInfoImpl(Connectivity()));
  getIt.registerSingleton<IdGenerator>(IdGenerator());

  // Cache Manager
  getIt.registerSingleton<CacheManager>(CacheManager());

  // Mock APIs
  getIt.registerSingleton<MockGoldSalesApi>(MockGoldSalesApi());
  getIt.registerSingleton<MockAuthApi>(MockAuthApi());

  // Auth Repository (using MockAuthApi) - Register BEFORE TokenManager
  getIt.registerSingleton<AuthRepository>(
    MockAuthRepository(
      getIt<MockAuthApi>(),
      getIt<SecureStorageService>(),
    ),
  );

  // Token Manager (using AuthRepository, not FlutterSecureStorage)
  getIt.registerSingleton<TokenManager>(
    TokenManager(getIt<AuthRepository>()),
  );

  // Auth Cubit
  final authCubit = AuthCubit(
    getIt<AuthRepository>(),
    getIt<TokenManager>(),
  );
  getIt.registerSingleton<AuthCubit>(authCubit);

  // Initialize auth status
  await authCubit.checkAuthStatus();
}
