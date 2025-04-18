import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:fe_flutter/src/core/serializers.dart';

import '../models/api_models.dart';
import 'api_service.dart';

class ChatAPIService {
  final APIService _api = APIService.instance;

  Future<SearchResponse> sendMessage(String message,
      {List<String>? tags}) async {
    try {
      final request = SearchRequest((b) => b
        ..query = message
        ..tags = ListBuilder(tags ?? [])
        ..preferences =
            SearchPreferences((p) => p..recents = ListBuilder([])).toBuilder());

      final response = await _api.post(
        '/search',
        data: serializers.serializeWith(SearchRequest.serializer, request),
      );

      return serializers.deserializeWith(
        SearchResponse.serializer,
        response.data,
      )!;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw Exception(
            'Unable to connect to server. Please check your internet connection.');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout. Please try again.');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<SearchResponse> searchDocuments(
    String query, {
    List<String>? tags,
    List<String>? recentDocs,
  }) async {
    try {
      final request = SearchRequest((b) => b
        ..query = query
        ..tags = ListBuilder(tags ?? [])
        ..preferences =
            SearchPreferences((p) => p..recents = ListBuilder(recentDocs ?? []))
                .toBuilder());

      final response = await _api.post(
        '/search',
        data: serializers.serializeWith(SearchRequest.serializer, request),
      );

      return serializers.deserializeWith(
        SearchResponse.serializer,
        response.data,
      )!;
    } catch (e) {
      throw Exception('Failed to search documents: $e');
    }
  }
}
