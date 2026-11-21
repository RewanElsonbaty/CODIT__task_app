import 'package:codit/core/config/app_config.dart';
import 'package:codit/core/database/app_database.dart';
import 'package:codit/core/network/api_client.dart';
import 'package:codit/core/network/network_info.dart';
import 'package:codit/core/network/session_controller.dart';
import 'package:codit/core/security/secure_storage_service.dart';
import 'package:codit/core/utils/id_generator.dart';
import 'package:codit/features/authentication/data/auth_repository.dart';
import 'package:codit/features/authentication/presentation/authentication_cubit.dart';
import 'package:codit/features/installments/data/sync_worker.dart';
import 'package:codit/mocks/mock_api_server.dart';
import 'package:codit/mocks/mock_scenario_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

const _defaultAccount = 'shop-a';

/// Configure core dependencies
///
/// This simplified version removes deprecated cubits
/// and only registers core services
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
  getIt.registerSingleton<SessionController>(
    SessionController(getIt<SecureStorageService>()),
  );

  // Database
  getIt.registerSingleton<AppDatabase>(AppDatabase());

  // Network
  getIt.registerSingleton<NetworkInfo>(NetworkInfoImpl(Connectivity()));
  getIt.registerSingleton<IdGenerator>(IdGenerator());

  late AuthenticationCubit authCubit;

  // API Client
  getIt.registerSingleton<ApiClient>(
    ApiClient(
      config: getIt<AppConfig>(),
      mockServer: getIt<MockApiServer>(),
      storage: getIt<SecureStorageService>(),
      session: getIt<SessionController>(),
      onRefreshFailed: () => authCubit.handleRefreshFailed(),
    ),
  );

  // Auth Repository
  getIt.registerSingleton<AuthRepository>(
    AuthRepository(
      getIt<ApiClient>().dio,
      getIt<SecureStorageService>(),
      getIt<SessionController>(),
    ),
  );

  // Auth Cubit
  authCubit = AuthenticationCubit(getIt<AuthRepository>());
  getIt.registerSingleton<AuthenticationCubit>(authCubit);

  // Sync Worker (for installments background sync)
  // Note: This requires InstallmentRepository to be registered first
  // For now, we skip it to avoid errors. Enable it when InstallmentRepository is ready.

  // try {
  //   final installmentRepo = getIt.get<InstallmentRepository>();
  //   getIt.registerLazySingleton<SyncWorker>(
  //     () => SyncWorker(installmentRepo, getIt<NetworkInfo>()),
  //   );
  // } catch (e) {
  //   // InstallmentRepository not registered yet, skip sync worker
  // }
}

/// Setup module-specific dependencies
///
/// Call this to register cubits for specific modules
/// This allows lazy loading of features
Future<void> setupModuleDependencies() async {
  // Module-specific dependencies should be registered here
  // or in their respective module DI files

  // For now, core dependencies are enough to run the app
  // with the new simplified screens
}
