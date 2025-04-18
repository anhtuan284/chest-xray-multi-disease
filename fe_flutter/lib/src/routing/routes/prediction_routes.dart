import 'package:go_router/go_router.dart';

import '../../features/prediction/presentation/prediction_screen.dart';
import '../route_paths.dart';

List<RouteBase> predictionRoutes = [
  GoRoute(
    path: RoutePaths.prediction,
    builder: (context, state) => const PredictionScreen(),
  ),
];
