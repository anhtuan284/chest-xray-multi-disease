import 'package:built_value/built_value.dart';

part 'navigation_state.g.dart';

abstract class NavigationState
    implements Built<NavigationState, NavigationStateBuilder> {
  int get currentIndex;

  NavigationState._();
  factory NavigationState([void Function(NavigationStateBuilder) updates]) =
      _$NavigationState;

  static NavigationState initial() {
    return NavigationState((b) => b..currentIndex = 0);
  }
}
