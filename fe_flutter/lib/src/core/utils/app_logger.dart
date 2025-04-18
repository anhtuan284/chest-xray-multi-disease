import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';

/// Centralized logger setup for the application.
/// Call [configureLogging] early in the app startup.
class AppLogger {
  // ANSI color codes for terminal output
  static const String _reset = '\x1B[0m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _magenta = '\x1B[35m';
  static const String _cyan = '\x1B[36m';
  static const String _boldRed = '\x1B[1;31m';
  
  /// Configure the root logger with appropriate settings.
  static void configureLogging() {
    // Set the log level based on build mode
    Logger.root.level = kDebugMode ? Level.ALL : Level.INFO;

    // Add a listener for log records
    Logger.root.onRecord.listen((record) {
      // Format time with milliseconds precision
      final timeStr = '${record.time.toIso8601String().split('.')[0]}.${record.time.millisecond.toString().padLeft(3, '0')}';
      
      // Color based on log level
      final colorCode = _getColorForLevel(record.level);
      final levelColor = kDebugMode ? colorCode : '';
      const resetCode = kDebugMode ? _reset : '';
      
      // Build the message with appropriate formatting
      final message = '$levelColor$timeStr$resetCode '
          '$levelColor${record.level.name.padRight(7)}$resetCode '
          '$levelColor[${record.loggerName}]$resetCode '
          '${record.message}';

      // Use debugPrint to avoid log truncation in large logs
      debugPrint(message);

      // Log errors with stack traces
      if (record.error != null) {
        final errorMsg = '${kDebugMode ? _boldRed : ''}Error: ${record.error}$resetCode';
        debugPrint(errorMsg);
      }

      if (record.stackTrace != null) {
        final stackMsg = '${kDebugMode ? _cyan : ''}Stack trace: ${record.stackTrace}$resetCode';
        debugPrint(stackMsg);
      }
    });
  }

  /// Maps logging levels to appropriate colors
  static String _getColorForLevel(Level level) {
    if (level == Level.SEVERE || level == Level.SHOUT) {
      return _boldRed;
    } else if (level == Level.WARNING) {
      return _yellow;
    } else if (level == Level.INFO) {
      return _green;
    } else if (level == Level.CONFIG) {
      return _magenta;
    } else if (level == Level.FINE || level == Level.FINER || level == Level.FINEST) {
      return _cyan;
    } else {
      return _blue;
    }
  }

  /// Get a logger instance for the specified name.
  static Logger getLogger(String name) {
    return Logger(name);
  }
}