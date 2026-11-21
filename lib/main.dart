import 'package:flutter/material.dart';
import 'package:codit/core/deep_linking/deep_link_handler.dart';
import 'package:codit/core/di/injection.dart';
import 'package:codit/core/localization/app_localizations.dart';
import 'package:codit/core/routing/app_router.dart';
import 'package:codit/core/theme/luxury_theme.dart';
import 'package:codit/features/authentication/presentation/authentication_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:app_links/app_links.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  runApp(const CoditApp());
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
    final authCubit = getIt<AuthenticationCubit>();
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
      if (state is AuthReady) {
        _deepLinkHandler.handlePendingLink(_router);
      } else if (state is AuthInitial) {
        _deepLinkHandler.clearPending();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = getIt<AuthenticationCubit>();
    return BlocProvider.value(
      value: authCubit,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
        theme: LuxuryTheme.darkTheme,
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: _router,
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
