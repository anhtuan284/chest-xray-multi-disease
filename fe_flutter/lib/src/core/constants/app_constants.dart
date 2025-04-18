/// Re-exports all specialized constants
export 'apis.dart';

/// Contains application-wide constants that don't fit into specialized categories
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  /// App metadata
  static const String appName = 'fe_flutter';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  /// Feature flags
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enablePushNotifications = true;

  /// Default values
  static const int maxLoginAttempts = 5;
  static const int sessionTimeoutMinutes = 60;
}
