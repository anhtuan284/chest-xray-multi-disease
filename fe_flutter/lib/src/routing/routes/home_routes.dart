import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_screen.dart';
import '../route_paths.dart';

List<RouteBase> homeRoutes = [
  GoRoute(
    path: RoutePaths.home,
    builder: (context, state) => const HomeScreen(),
  ),
];
