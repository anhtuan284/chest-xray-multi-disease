/// API-related constants for the application
class ApiConstants {
  // Private constructor to prevent instantiation
  ApiConstants._();

  /// Base URLs
  static const String baseApiUrl = 'https://api.fe_flutter.com';
  static const String baseAssetUrl = 'https://assets.fe_flutter.com';

  /// API timeouts
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration longOperationTimeout = Duration(minutes: 2);

  /// API endpoints
  static const String authEndpoint = '/auth';
  static const String usersEndpoint = '/users';
  static const String contentEndpoint = '/content';
}
