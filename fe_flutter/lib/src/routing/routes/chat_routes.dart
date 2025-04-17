import 'package:go_router/go_router.dart';

import '../../features/chat/presentation/chat_screen.dart';
import '../route_paths.dart';

List<RouteBase> chatRoutes = [
  GoRoute(
    path: RoutePaths.chat,
    builder: (context, state) => const ChatScreen(),
  ),
];
