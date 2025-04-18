import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../serializers.dart';

part 'api_models.g.dart';

abstract class SearchRequest
    implements Built<SearchRequest, SearchRequestBuilder> {
  String get query;
  BuiltList<String>? get tags;
  SearchPreferences? get preferences;

  SearchRequest._();
  factory SearchRequest([void Function(SearchRequestBuilder) updates]) =
      _$SearchRequest;

  static Serializer<SearchRequest> get serializer => _$searchRequestSerializer;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(SearchRequest.serializer, this)
        as Map<String, dynamic>;
  }

  static SearchRequest? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(SearchRequest.serializer, json);
  }
}

abstract class SearchPreferences
    implements Built<SearchPreferences, SearchPreferencesBuilder> {
  BuiltList<String> get recents;

  SearchPreferences._();
  factory SearchPreferences([void Function(SearchPreferencesBuilder) updates]) =
      _$SearchPreferences;

  static Serializer<SearchPreferences> get serializer =>
      _$searchPreferencesSerializer;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(SearchPreferences.serializer, this)
        as Map<String, dynamic>;
  }

  static SearchPreferences? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(SearchPreferences.serializer, json);
  }
}

abstract class SearchResponse
    implements Built<SearchResponse, SearchResponseBuilder> {
  String get answer;

  SearchResponse._();
  factory SearchResponse([void Function(SearchResponseBuilder) updates]) =
      _$SearchResponse;

  static Serializer<SearchResponse> get serializer =>
      _$searchResponseSerializer;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(SearchResponse.serializer, this)
        as Map<String, dynamic>;
  }

  static SearchResponse? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(SearchResponse.serializer, json);
  }
}

abstract class DocumentFile
    implements Built<DocumentFile, DocumentFileBuilder> {
  String get filename;
  String get path;
  int get size;
  double get created;

  DocumentFile._();
  factory DocumentFile([void Function(DocumentFileBuilder) updates]) =
      _$DocumentFile;

  static Serializer<DocumentFile> get serializer => _$documentFileSerializer;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(DocumentFile.serializer, this)
        as Map<String, dynamic>;
  }

  static DocumentFile? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(DocumentFile.serializer, json);
  }
}

abstract class UploadResponse
    implements Built<UploadResponse, UploadResponseBuilder> {
  String get message;
  String get path;

  UploadResponse._();
  factory UploadResponse([void Function(UploadResponseBuilder) updates]) =
      _$UploadResponse;

  static Serializer<UploadResponse> get serializer =>
      _$uploadResponseSerializer;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(UploadResponse.serializer, this)
        as Map<String, dynamic>;
  }

  static UploadResponse? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(UploadResponse.serializer, json);
  }
}
