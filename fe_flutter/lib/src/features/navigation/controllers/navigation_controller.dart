import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/navigation_state.dart';

class NavigationController extends StateNotifier<NavigationState> {
  NavigationController() : super(NavigationState.initial());

  void setCurrentIndex(int index) {
    state = NavigationState((b) => b..currentIndex = index);
  }
}

final navigationController =
    StateNotifierProvider<NavigationController, NavigationState>((ref) {
  return NavigationController();
});
