// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (new Serializers().toBuilder()
      ..add(ChatMessage.serializer)
      ..add(DiseaseSummaryData.serializer)
      ..add(DiseaseSummaryResponse.serializer)
      ..add(DocumentFile.serializer)
      ..add(ImageAsset.serializer)
      ..add(MediaFile.serializer)
      ..add(MediaFormat.serializer)
      ..add(MetaData.serializer)
      ..add(Pagination.serializer)
      ..add(Patient.serializer)
      ..add(PatientResponse.serializer)
      ..add(SearchPreferences.serializer)
      ..add(SearchRequest.serializer)
      ..add(SearchResponse.serializer)
      ..add(UploadResponse.serializer)
      ..add(UserSetting.serializer)
      ..add(WeeklyStatsData.serializer)
      ..add(WeeklyStatsResponse.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MediaFile)]),
          () => new ListBuilder<MediaFile>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MediaFile)]),
          () => new ListBuilder<MediaFile>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Patient)]),
          () => new ListBuilder<Patient>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(
                BuiltMap, const [const FullType(String), const FullType(int)])
          ]),
          () => new MapBuilder<String, BuiltMap<String, int>>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)]),
          () => new MapBuilder<String, int>())
      ..addBuilderFactory(
          const FullType(BuiltMap,
              const [const FullType(String), const FullType(MediaFormat)]),
          () => new MapBuilder<String, MediaFormat>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)]),
          () => new MapBuilder<String, int>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
