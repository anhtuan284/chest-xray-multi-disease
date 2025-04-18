import 'package:fe_flutter/src/features/auth/controllers/auth_state_controller.dart';
import 'package:fe_flutter/src/features/auth/presentation/login_screen.dart';
import 'package:fe_flutter/src/features/tutorial/controllers/tutorial_controller.dart';
import 'package:fe_flutter/src/features/tutorial/presentation/tutorial_screen.dart';
import 'package:fe_flutter/src/routing/navigation_helper.dart';
import 'package:fe_flutter/src/routing/routes/home_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/shell/presentation/shell_screen.dart';
import 'route_paths.dart';
import 'routes/chat_routes.dart';
import 'routes/documents_routes.dart';
import 'routes/patients_routes.dart';
import 'routes/prediction_routes.dart';

part 'router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: RoutePaths.home,
    redirect: (context, state) async {
      final authState = ref.read(authStateProvider);

      if (authState.isAuthenticating) return null;
      final isAuthenticated = authState.isAuthenticated;
      final isLoginRoute = state.matchedLocation == RoutePaths.login;

      if (!isAuthenticated && !isLoginRoute) {
        return RoutePaths.login;
      }

      final tutorialController = ref.read(tutorialControllerProvider);
      final isFirstTimeUser = await tutorialController.isFirstTimeUser();
      if (isFirstTimeUser &&
          state.fullPath != RoutePaths.tutorial &&
          isAuthenticated) {
        return RoutePaths.tutorial;
      }

      return null;
    },
    routes: [
      // Login route
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // Tutorial route
      GoRoute(
        path: RoutePaths.tutorial,
        builder: (context, state) => const TutorialScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final index = NavigationHelper.getSelectedIndex(state.fullPath!);
          return ShellScreen(currentIndex: index, child: child);
        },
        routes: [
          // Home route
          ...homeRoutes,
          ...patientRoutes,
          ...predictionRoutes,
          ...chatRoutes,
          ...documentRoutes,
        ],
      ),
    ],
  );
}
