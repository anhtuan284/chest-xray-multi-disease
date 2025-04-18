import 'package:fe_flutter/src/core/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/repositories/auth_repository.dart';
import '../../../core/utils/app_logger.dart';
import '../models/auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final _logger = AppLogger.getLogger('AuthController');

  AuthController(this._authRepository) : super(AuthState.unauthenticated());

  Future<void> signIn(String email) async {
    state = AuthState.authenticating();

    try {
      final authenticatedEmail = await _authRepository.signIn(email);
      _logger.info('User signed in: $authenticatedEmail');
      state = AuthState.authenticated(email: authenticatedEmail);
    } catch (e, stackTrace) {
      _logger.severe('Controller: Sign in failed', e, stackTrace);
      state = AuthState.error('Authentication failed');
    }
  }

  Future<void> continueAsGuest() async {
    state = AuthState.authenticating();

    try {
      await _authRepository.signInAsGuest();
      _logger.info('User continuing as guest');
      state = AuthState.guest();
    } catch (e, stackTrace) {
      _logger.severe('Controller: Guest sign in failed', e, stackTrace);
      state = AuthState.error('Guest authentication failed');
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      _logger.info('User signed out');
      state = AuthState.unauthenticated();
    } catch (e, stackTrace) {
      _logger.severe('Controller: Sign out failed', e, stackTrace);
      // Even if sign out fails on the server, we'll force local sign out
      state = AuthState.unauthenticated();
    }
  }

  bool get isAuthenticated => state.isAuthenticated;
  bool get isGuest => state.isGuest;
}

final authStateProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository);
});
