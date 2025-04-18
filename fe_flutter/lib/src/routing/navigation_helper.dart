import 'route_paths.dart';

class NavigationHelper {
  static int getSelectedIndex(String path) {
    switch (path) {
      case RoutePaths.home:
        return 0;
      case RoutePaths.patients:
        return 1;
      case RoutePaths.chat:
        return 3;
      case RoutePaths.documents:
        return 4;
      default:
        return 0;
    }
  }
}
