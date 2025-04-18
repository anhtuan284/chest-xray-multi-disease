import 'package:go_router/go_router.dart';

import '../../features/documents/presentation/documents_screen.dart';
import '../route_paths.dart';

List<RouteBase> documentRoutes = [
  GoRoute(
    path: RoutePaths.documents,
    builder: (context, state) => const DocumentsScreen(),
  ),
];
