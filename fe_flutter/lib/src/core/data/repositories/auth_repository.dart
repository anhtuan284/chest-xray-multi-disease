import '../../services/auth_service.dart';
import '../../utils/app_logger.dart';

class AuthRepository {
  final AuthService _authService;
  final _logger = AppLogger.getLogger('AuthRepository');

  AuthRepository(this._authService);

  Future<String> signIn(String email) async {
    try {
      final authenticatedEmail = await _authService.authenticateUser(email);
      return authenticatedEmail;
    } catch (e, stackTrace) {
      _logger.severe('Repository: Sign in failed', e, stackTrace);
      rethrow;
    }
  }

  Future<void> signInAsGuest() async {
    try {
      await _authService.authenticateGuest();
    } catch (e, stackTrace) {
      _logger.severe('Repository: Guest sign in failed', e, stackTrace);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOutUser();
    } catch (e, stackTrace) {
      _logger.severe('Repository: Sign out failed', e, stackTrace);
      rethrow;
    }
  }
}
