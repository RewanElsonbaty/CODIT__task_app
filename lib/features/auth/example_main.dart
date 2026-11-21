import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'di/auth_di.dart';
import 'presentation/auth_cubit.dart';
import 'presentation/auth_wrapper.dart';
import 'data/services/notification_service.dart';

/// Example main.dart showing how to integrate the auth system
/// 
/// This file demonstrates:
/// 1. Firebase initialization
/// 2. Dependency injection setup
/// 3. Notification service initialization
/// 4. Auth BLoC provider setup
/// 5. Auth wrapper integration
void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Setup dependency injection
  await setupDependencies();

  // Initialize notification service
  await initializeNotifications(GetIt.instance);

  // Listen to notifications
  _setupNotificationListener();

  // Run app
  runApp(const MyApp());
}

/// Setup all dependencies
Future<void> setupDependencies() async {
  final getIt = GetIt.instance;

  // Setup auth dependencies
  setupAuthDependencies(getIt);

  // TODO: Setup other feature dependencies here
  // setupGoldSalesDependencies(getIt);
  // setupBranchDashboardDependencies(getIt);
  // etc.
}

/// Setup notification listener
void _setupNotificationListener() {
  final notificationService = GetIt.instance<NotificationService>();
  final authCubit = GetIt.instance<AuthCubit>();

  notificationService.onNotificationTap.listen((payload) {
    debugPrint('[Main] Notification tapped: ${payload.type} - ${payload.id}');
    authCubit.handleNotificationDeepLink(payload);
  });
}

/// Main app widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<AuthCubit>(),
      child: MaterialApp(
        title: 'Luxury Gold',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'Cairo', // TODO: Add font
          primaryColor: const Color(0xFFD4AF37),
          scaffoldBackgroundColor: const Color(0xFF000000),
          colorScheme: ColorScheme.dark(
            primary: const Color(0xFFD4AF37),
            secondary: const Color(0xFFB8941E),
            surface: const Color(0xFF1A1A1A),
            background: const Color(0xFF000000),
            error: const Color(0xFFE53935),
            onPrimary: Colors.black,
            onSecondary: Colors.white,
            onSurface: Colors.white,
            onBackground: Colors.white,
            onError: Colors.white,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1A1A1A),
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: Color(0xFFD4AF37)),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              foregroundColor: Colors.black,
              elevation: 8,
              shadowColor: const Color(0xFFD4AF37).withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          cardTheme: CardThemeData(
            color: const Color(0xFF1A1A1A),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: const Color(0xFFD4AF37).withOpacity(0.2),
              ),
            ),
          ),
        ),
        home: AuthWrapper(
          home: const HomePage(),
        ),
      ),
    );
  }
}

/// Placeholder home page
/// 
/// Replace this with your actual home page
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Luxury Gold'),
        actions: [
          IconButton(
            onPressed: () {
              // Logout
              context.read<AuthCubit>().logout();
            },
            icon: const Icon(Icons.logout),
            tooltip: 'تسجيل الخروج',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFD4AF37),
                    const Color(0xFFB8941E),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.diamond,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'مرحباً بك في',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  const Color(0xFFFFD700),
                  const Color(0xFFD4AF37),
                  const Color(0xFFB8941E),
                ],
              ).createShader(bounds),
              child: const Text(
                'LUXURY GOLD',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 48),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return state.maybeWhen(
                  authenticated: (user, _, __) => Column(
                    children: [
                      Text(
                        'مرحباً ${user.name}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user.phone,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                  orElse: () => const SizedBox.shrink(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
