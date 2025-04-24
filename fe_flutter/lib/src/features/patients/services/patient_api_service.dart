import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/services/api_service_base.dart';
import '../models/patient_models.dart';

class PatientApiService extends ApiServiceBase {
  PatientApiService({
    String? baseUrl,
    String? authToken,
  })  : _baseUrl = baseUrl ?? 'http://atuan-ubuntu2404:1337',
        _authToken = authToken ??
            '5553c557d9d6a766ce818d58ff380685a3c497084d2c3873882e668a5f5148cb381494a1e31f6a277e2d1b2a3c3a2bfcd41ec70fcb7f804c37a89a4805448e6b6b2dc921b54c6e06e32abcc2103367af3fc2b81bda013627163594596b90c370b86cc8be6d0621bf0f5b3e13711235387c7d98c38a4c24558161ca5a8bda38c6', // In a real app, you'd get this from secure storage
        super.withLoggerName('PatientApiService');

  final String _baseUrl;
  final String _authToken;

  // Method to fetch all patients
  Future<PatientResponse> getPatients({int page = 1, int pageSize = 25}) async {
    final endpoint = '$_baseUrl/api/patients';
    final queryParams = {
      'pagination[page]': page.toString(),
      'pagination[pageSize]': pageSize.toString(),
    };

    logRequest('GET', endpoint, queryParams: queryParams);

    try {
      final uri = Uri.parse(endpoint).replace(queryParameters: queryParams);
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      final responseBody = response.body;
      logResponse('GET', endpoint, response.statusCode,
          responseBody: responseBody);

      if (response.statusCode == 200) {
        final jsonData = json.decode(responseBody);
        return PatientResponse.fromJson(jsonData)!;
      } else {
        final error = 'Failed to load patients: ${response.statusCode}';
        logError('GET', endpoint, error);
        throw Exception(error);
      }
    } catch (e) {
      logError('GET', endpoint, e);
      throw Exception('Error fetching patients: $e');
    }
  }

  // Method to fetch a specific patient by ID
  Future<Patient> getPatientDetails(int id) async {
    final endpoint = '$_baseUrl/api/patients/$id';
    logRequest('GET', endpoint);

    try {
      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      final responseBody = response.body;
      logResponse('GET', endpoint, response.statusCode,
          responseBody: responseBody);

      if (response.statusCode == 200) {
        final jsonData = json.decode(responseBody);
        return Patient.fromJson(jsonData['data'])!;
      } else {
        final error = 'Failed to load patient details: ${response.statusCode}';
        logError('GET', endpoint, error);
        throw Exception(error);
      }
    } catch (e) {
      logError('GET', endpoint, e);
      throw Exception('Error fetching patient details: $e');
    }
  }

  // Method to fetch a specific patient by document ID with related data
  Future<Patient> getPatientDetailsByDocumentId(String documentId) async {
    final endpoint = '$_baseUrl/api/patients/$documentId';
    final queryParams = {
      'populate': '*',
    };

    logRequest('GET', endpoint, queryParams: queryParams);

    try {
      final uri = Uri.parse(endpoint).replace(queryParameters: queryParams);
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      final responseBody = response.body;
      logResponse('GET', endpoint, response.statusCode,
          responseBody: responseBody);

      if (response.statusCode == 200) {
        final jsonData = json.decode(responseBody);
        return Patient.fromJson(jsonData['data'])!;
      } else {
        final error = 'Failed to load patient details: ${response.statusCode}';
        logError('GET', endpoint, error);
        throw Exception(error);
      }
    } catch (e) {
      logError('GET', endpoint, e);
      throw Exception('Error fetching patient details: $e');
    }
  }
}
