import 'dart:io';

import 'package:dio/dio.dart';

import '../models/api_models.dart';
import '../serializers.dart';
import 'api_service.dart';

class DocumentsAPIService {
  final APIService _api = APIService.instance;

  Future<List<DocumentFile>> getAllDocuments() async {
    try {
      final response = await _api.get('/documents');
      final List<DocumentFile> documents = (response.data as List)
          .map((json) => DocumentFile.fromJson(json as Map<String, dynamic>))
          .where((doc) => doc != null) // Filter out null documents
          .cast<DocumentFile>() // Cast to non-nullable DocumentFile
          .toList();

      return documents..sort((a, b) => b.created.compareTo(a.created));
    } on DioException catch (e) {
      throw _handleDioError(e, 'Failed to get documents');
    }
  }

  Future<UploadResponse> uploadDocument(File file) async {
    try {
      // Validate file before upload
      if (!_isValidFileType(file.path)) {
        throw Exception('Invalid file type. Only PDF files are allowed.');
      }

      if (!await _isValidFileSize(file)) {
        throw Exception('File size exceeds maximum limit of 10MB.');
      }

      final response = await _api.uploadFile('/documents/upload', file.path);
      return serializers.deserializeWith(
          UploadResponse.serializer, response.data)!;
    } on DioException catch (e) {
      throw _handleDioError(e, 'Failed to upload document');
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  Future<void> deleteDocument(String filename) async {
    try {
      await _api.post('/documents/$filename/delete');
    } on DioException catch (e) {
      throw _handleDioError(e, 'Failed to delete document');
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  Future<String> getDocumentViewUrl(String filename) async {
    try {
      // Validate if document exists first
      await _api.get('/documents/$filename/view');
      return 'http://localhost:8033/documents/$filename/view';
    } on DioException catch (e) {
      throw _handleDioError(e, 'Document not found');
    } catch (e) {
      throw Exception('Failed to get document view URL: $e');
    }
  }

  Future<String> getDocumentDownloadUrl(String filename) async {
    try {
      // Validate if document exists first
      await _api.get('/documents/$filename');
      return 'http://localhost:8033/documents/$filename';
    } on DioException catch (e) {
      throw _handleDioError(e, 'Document not found');
    } catch (e) {
      throw Exception('Failed to get document download URL: $e');
    }
  }

  // Helper methods
  bool _isValidFileType(String filePath) {
    return filePath.toLowerCase().endsWith('.pdf');
  }

  Future<bool> _isValidFileSize(File file) async {
    final bytes = await file.length();
    const maxSize = 10 * 1024 * 1024; // 10MB in bytes
    return bytes <= maxSize;
  }

  Exception _handleDioError(DioException e, String defaultMessage) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please try again.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data['message'] ?? defaultMessage;
        return Exception('Server error ($statusCode): $message');
      case DioExceptionType.connectionError:
        return Exception('No internet connection');
      default:
        return Exception(defaultMessage);
    }
  }
}
