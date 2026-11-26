import 'package:flutter/material.dart';
import 'package:codit/core/deep_linking/deep_link_handler.dart';
import 'package:codit/core/di/injection.dart';
import 'package:codit/core/localization/app_localizations.dart';
import 'package:codit/core/localization/locale_cubit.dart';
import 'package:codit/core/routing/app_router.dart';
import 'package:codit/core/theme/luxury_theme.dart';
import 'package:codit/features/auth/presentation/auth_cubit.dart';
import 'package:codit/features/notifications/services/notification_scheduler_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:app_links/app_links.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await configureDependencies();
    
    // تفعيل جدولة الإشعارات التلقائية للأقساط
    // يتم فحص الأقساط المستحقة والمتأخرة تلقائياً
    NotificationSchedulerConfig.initialize();
    
    runApp(const CoditApp());
  } catch (e) {
    print('Error initializing app: $e');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error: $e'),
          ),
        ),
      ),
    );
  }
}

class CoditApp extends StatefulWidget {
  const CoditApp({super.key});

  @override
  State<CoditApp> createState() => _CoditAppState();
}

class _CoditAppState extends State<CoditApp> {
  late final GoRouter _router;
  late final DeepLinkHandler _deepLinkHandler;
  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    final authCubit = getIt<AuthCubit>();
    _deepLinkHandler = DeepLinkHandler(authCubit);
    _router = buildRouter(authCubit);
    _appLinks = AppLinks();

    // Listen to deep links
    _appLinks.uriLinkStream.listen((uri) {
      _deepLinkHandler.handleLink(uri.toString(), _router);
    });

    // Handle initial link (app opened from notification)
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        _deepLinkHandler.handleLink(uri.toString(), _router);
      }
    });

    // Listen to auth state changes to handle pending links
    authCubit.stream.listen((state) {
      if (state is AuthAuthenticated) {
        _deepLinkHandler.handlePendingLink(_router);
      } else if (state is AuthUnauthenticated) {
        _deepLinkHandler.clearPending();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = getIt<AuthCubit>();
    
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authCubit),
        BlocProvider(create: (_) => LocaleCubit()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'CODIT',
            theme: LuxuryTheme.darkTheme,
            locale: locale,
            supportedLocales: const [
              Locale('ar', ''),
              Locale('en', ''),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: _router,
            builder: (context, child) {
              // ✅ تحديد الاتجاه حسب اللغة
              final isArabic = locale.languageCode == 'ar';
              
              return Directionality(
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
