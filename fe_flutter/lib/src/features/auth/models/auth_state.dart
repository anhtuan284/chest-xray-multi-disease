import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_state.g.dart';

/// Authentication status enum
enum AuthStatus {
  unauthenticated,
  authenticating,
  authenticated,
  error,
}

/// Immutable authentication state using built_value
abstract class AuthState implements Built<AuthState, AuthStateBuilder> {
  /// Authentication status
  AuthStatus get status;

  /// User email (null if not authenticated or guest)
  String? get email;

  /// Error message (null if no error)
  String? get error;

  /// Whether the user is a guest
  @BuiltValueField(wireName: 'is_guest')
  bool get isGuest;

  /// Check if user is authenticated
  bool get isAuthenticated => status == AuthStatus.authenticated;

  /// Check if user is authenticating
  bool get isAuthenticating => status == AuthStatus.authenticating;

  /// Private constructor
  AuthState._();

  /// Factory constructor with default values
  factory AuthState([void Function(AuthStateBuilder) updates]) = _$AuthState;

  /// Factory constructor for unauthenticated state
  factory AuthState.unauthenticated() => AuthState((b) => b
    ..status = AuthStatus.unauthenticated
    ..isGuest = false);

  /// Factory constructor for authenticating state
  factory AuthState.authenticating() => AuthState((b) => b
    ..status = AuthStatus.authenticating
    ..isGuest = false);

  /// Factory constructor for authenticated state
  factory AuthState.authenticated({
    required String email,
    bool isGuest = false,
  }) =>
      AuthState((b) => b
        ..status = AuthStatus.authenticated
        ..email = email
        ..isGuest = isGuest);

  /// Factory constructor for guest state
  factory AuthState.guest() => AuthState((b) => b
    ..status = AuthStatus.authenticated
    ..isGuest = true);

  /// Factory constructor for error state
  factory AuthState.error(String errorMessage) => AuthState((b) => b
    ..status = AuthStatus.error
    ..error = errorMessage
    ..isGuest = false);

  /// Serializer
  static Serializer<AuthState> get serializer => _$authStateSerializer;
}
