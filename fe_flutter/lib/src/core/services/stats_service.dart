import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/disease_stats_models.dart';
import 'api_service_base.dart';

class StatsService extends ApiServiceBase {
  StatsService({String? baseUrl})
      : _baseUrl = baseUrl ?? ('http://atuan-ubuntu2404:5000'),
        super.withLoggerName('StatsService');

  final String _baseUrl;

  /// Fetches the weekly disease statistics
  Future<WeeklyStatsResponse> fetchWeeklyDiseaseStats() async {
    final endpoint = '$_baseUrl/stats/diseases/weekly';
    logRequest('GET', endpoint);

    try {
      final response = await http.get(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
      );

      final responseBody = response.body;
      logResponse('GET', endpoint, response.statusCode,
          responseBody: responseBody);

      if (response.statusCode == 200) {
        final jsonData = json.decode(responseBody);
        return WeeklyStatsResponse.fromJson(jsonData)!;
      } else {
        final error =
            'Failed to load weekly disease statistics: ${response.statusCode}';
        logError('GET', endpoint, error);
        throw Exception(error);
      }
    } catch (e) {
      logError('GET', endpoint, e);
      throw Exception('Error fetching weekly disease stats: $e');
    }
  }

  /// Fetches the summary of all disease predictions
  Future<DiseaseSummaryResponse> fetchDiseaseSummary() async {
    final endpoint = '$_baseUrl/stats/diseases/summary';
    logRequest('GET', endpoint);

    try {
      final response = await http.get(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
      );

      final responseBody = response.body;
      logResponse('GET', endpoint, response.statusCode,
          responseBody: responseBody);

      if (response.statusCode == 200) {
        final jsonData = json.decode(responseBody);
        return DiseaseSummaryResponse.fromJson(jsonData)!;
      } else {
        final error = 'Failed to load disease summary: ${response.statusCode}';
        logError('GET', endpoint, error);
        throw Exception(error);
      }
    } catch (e) {
      logError('GET', endpoint, e);
      throw Exception('Error fetching disease summary: $e');
    }
  }

  /// Fetches daily disease statistics for a specified period
  Future<Map<String, dynamic>> fetchDailyDiseaseStats({int days = 30}) async {
    final endpoint = '$_baseUrl/stats/diseases/daily';
    final queryParams = {'days': days.toString()};
    logRequest('GET', endpoint, queryParams: queryParams);

    try {
      final uri = Uri.parse(endpoint).replace(queryParameters: queryParams);
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      final responseBody = response.body;
      logResponse('GET', endpoint, response.statusCode,
          responseBody: responseBody);

      if (response.statusCode == 200) {
        return json.decode(responseBody);
      } else {
        final error =
            'Failed to load daily disease statistics: ${response.statusCode}';
        logError('GET', endpoint, error);
        throw Exception(error);
      }
    } catch (e) {
      logError('GET', endpoint, e);
      throw Exception('Error fetching daily disease stats: $e');
    }
  }
}
