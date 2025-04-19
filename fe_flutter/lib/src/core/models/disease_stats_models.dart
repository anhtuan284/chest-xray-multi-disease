import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../serializers.dart';

part 'disease_stats_models.g.dart';

/// Response model for weekly disease statistics
abstract class WeeklyStatsResponse
    implements Built<WeeklyStatsResponse, WeeklyStatsResponseBuilder> {
  String get status;
  WeeklyStatsData get data;

  WeeklyStatsResponse._();
  factory WeeklyStatsResponse(
          [void Function(WeeklyStatsResponseBuilder) updates]) =
      _$WeeklyStatsResponse;

  static Serializer<WeeklyStatsResponse> get serializer =>
      _$weeklyStatsResponseSerializer;

  static WeeklyStatsResponse? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(WeeklyStatsResponse.serializer, json);
  }

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(WeeklyStatsResponse.serializer, this)
        as Map<String, dynamic>;
  }
}

/// Data model for weekly stats
abstract class WeeklyStatsData
    implements Built<WeeklyStatsData, WeeklyStatsDataBuilder> {
  BuiltMap<String, BuiltMap<String, int>> get weekly_stats;
  BuiltMap<String, int> get total;

  WeeklyStatsData._();
  factory WeeklyStatsData([void Function(WeeklyStatsDataBuilder) updates]) =
      _$WeeklyStatsData;

  static Serializer<WeeklyStatsData> get serializer =>
      _$weeklyStatsDataSerializer;

  static WeeklyStatsData? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(WeeklyStatsData.serializer, json);
  }

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(WeeklyStatsData.serializer, this)
        as Map<String, dynamic>;
  }
}

/// Response model for disease summary
abstract class DiseaseSummaryResponse
    implements Built<DiseaseSummaryResponse, DiseaseSummaryResponseBuilder> {
  String get status;
  DiseaseSummaryData get data;

  DiseaseSummaryResponse._();
  factory DiseaseSummaryResponse(
          [void Function(DiseaseSummaryResponseBuilder) updates]) =
      _$DiseaseSummaryResponse;

  static Serializer<DiseaseSummaryResponse> get serializer =>
      _$diseaseSummaryResponseSerializer;

  static DiseaseSummaryResponse? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(DiseaseSummaryResponse.serializer, json);
  }

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(DiseaseSummaryResponse.serializer, this)
        as Map<String, dynamic>;
  }
}

/// Data model for disease summary
abstract class DiseaseSummaryData
    implements Built<DiseaseSummaryData, DiseaseSummaryDataBuilder> {
  BuiltMap<String, int> get summary;
  int get total_predictions;

  DiseaseSummaryData._();
  factory DiseaseSummaryData(
          [void Function(DiseaseSummaryDataBuilder) updates]) =
      _$DiseaseSummaryData;

  static Serializer<DiseaseSummaryData> get serializer =>
      _$diseaseSummaryDataSerializer;

  static DiseaseSummaryData? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(DiseaseSummaryData.serializer, json);
  }

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(DiseaseSummaryData.serializer, this)
        as Map<String, dynamic>;
  }
}
