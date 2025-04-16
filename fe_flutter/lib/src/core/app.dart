import 'package:fe_flutter/src/core/theme/app_text_scaling.dart';
import 'package:fe_flutter/src/core/utils/app_logger.dart';
import 'package:fe_flutter/src/core/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../routing/router.dart';
import 'providers.dart';
import 'services/app_lifecycle_service.dart';
import 'theme/app_theme.dart';

/// Main application widget
class fe_flutterApp extends ConsumerStatefulWidget {
  const fe_flutterApp({super.key});

  @override
  ConsumerState<fe_flutterApp> createState() => _fe_flutterAppState();
}

class _fe_flutterAppState extends ConsumerState<fe_flutterApp>
    with WidgetsBindingObserver {
  bool _isReady = false;
  late final Future<void> _initFuture;
  final _log = AppLogger.getLogger('fe_flutterApp');

  @override
  void initState() {
    super.initState();
    _log.info('Initializing fe_flutterApp');
    WidgetsBinding.instance.addObserver(this);
    _initFuture = _initializeApp();
  }

  @override
  void dispose() {
    _log.info('Disposing fe_flutterApp');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _initializeApp() async {
    _log.info('Starting app initialization');

    try {
      // Perform initialization tasks here
      _log.fine('Loading app data...');

      // Simulate loading time - replace with actual initialization
      await Future.delayed(const Duration(seconds: 2));

      _log.info('App initialization complete');

      if (mounted) {
        setState(() {
          _isReady = true;
        });
      }
    } catch (e, stackTrace) {
      _log.severe('Failed to initialize app: $e', e, stackTrace);
      // Handle initialization errors
      rethrow;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Update the app lifecycle state in our service
    ref.read(appLifecycleServiceProvider.notifier).updateLifecycleState(state);

    // Log lifecycle state changes
    _log.info(
        'App lifecycle state changed to: ${state.toString().split('.').last}');

    // Handle specific lifecycle events if needed
    switch (state) {
      case AppLifecycleState.resumed:
        _handleAppResumed();
        break;
      case AppLifecycleState.inactive:
        _handleAppInactive();
        break;
      case AppLifecycleState.paused:
        _handleAppPaused();
        break;
      case AppLifecycleState.detached:
        _handleAppDetached();
        break;
      default:
        // Handle future lifecycle states that might be added
        _log.warning('Unknown lifecycle state: $state');
        break;
    }
  }

  // Lifecycle event handlers
  void _handleAppResumed() {
    // App is visible and responding to user input
    _log.fine('App resumed - application is now active and visible');
  }

  void _handleAppInactive() {
    // App is not currently receiving user input
    _log.fine('App inactive - application is not receiving user input');
  }

  void _handleAppPaused() {
    // App not visible to user, running in background
    _log.fine('App paused - application is in background');
  }

  void _handleAppDetached() {
    // App hosted in flutter engine with no view
    _log.fine('App detached - application is detached from Flutter engine');
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    // Handle locale changes
    super.didChangeLocales(locales);
    if (locales != null && locales.isNotEmpty) {
      _log.fine('Locale changed to: ${locales.first.languageCode}');
      // Here you could update app locale if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        // Show error if initialization failed
        if (snapshot.hasError) {
          _log.severe('Initialization error: ${snapshot.error}');
          return MaterialApp(
            theme: AppTheme.light,
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text('Failed to initialize app'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => setState(() {
                        _initFuture = _initializeApp();
                      }),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (!_isReady) {
          _log.info('Rendering loading screen');
          return MaterialApp(
            theme: AppTheme.light,
            home: const FullScreenLoader(title: "Loading fe_flutter..."),
          );
        }

        _log.info('Rendering main application');
        final router = ref.watch(routerProvider);
        final theme = ref.watch(themeProvider);

        return MaterialApp.router(
          title: 'fe_flutter',
          theme: AppTheme.light.copyWith(
            textTheme: scaleTextTheme(
              AppTheme.light.textTheme,
              ref.watch(userSettingRepositoryProvider).fontSize?.toDouble() ??
                  14,
            ),
          ),
          darkTheme: AppTheme.dark.copyWith(
            textTheme: scaleTextTheme(
              AppTheme.dark.textTheme,
              ref.watch(userSettingRepositoryProvider).fontSize?.toDouble() ??
                  14,
            ),
          ),
          themeMode: theme == AppTheme.dark ? ThemeMode.dark : ThemeMode.light,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
