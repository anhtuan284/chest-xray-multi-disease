import 'package:logging/logging.dart';

import '../utils/app_logger.dart';

/// Base class for all API services providing common functionality like logging
abstract class ApiServiceBase {
  final Logger _logger;

  /// Creates an API service with a logger named after the implementing class
  ApiServiceBase() : _logger = AppLogger.getLogger("API");

  /// Creates an API service with a custom logger name
  ApiServiceBase.withLoggerName(String loggerName)
      : _logger = AppLogger.getLogger(loggerName);

  /// Get the logger for this service
  Logger get logger => _logger;

  /// Log an API request before it's sent
  void logRequest(String method, String endpoint,
      {Map<String, dynamic>? queryParams, dynamic body}) {
    final queryString = queryParams != null && queryParams.isNotEmpty
        ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
        : '';

    final fullEndpoint = '$endpoint$queryString';

    _logger.info('🔷 $method REQUEST: $fullEndpoint');

    if (body != null) {
      _logger.fine('Request body: $body');
    }
  }

  /// Log an API response after it's received
  void logResponse(String method, String endpoint, int statusCode,
      {dynamic responseBody, String? errorMessage}) {
    final isSuccess = statusCode >= 200 && statusCode < 300;

    if (isSuccess) {
      _logger.info('✅ $method RESPONSE: $endpoint - Status: $statusCode');
      _logger.fine('Response body: $responseBody');
    } else {
      _logger.warning(
          '❌ $method RESPONSE: $endpoint - Status: $statusCode - Error: $errorMessage');
      _logger.fine('Response body: $responseBody');
    }
  }

  /// Log an API error
  void logError(String method, String endpoint, dynamic error,
      {StackTrace? stackTrace}) {
    _logger.severe(
        '❌ $method ERROR: $endpoint - ${error.toString()}', error, stackTrace);
  }
}
