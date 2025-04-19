import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import '../serializers.dart';

part 'prediction_models.g.dart';

enum PredictionModel { yolo, denseNet121 }

class PredictionImageResult {
  final String id;
  final dynamic imageSource; // This can be File or Uint8List
  final String? description;

  PredictionImageResult({
    required this.id,
    required this.imageSource,
    this.description,
  });
}

abstract class YoloPredictionResponse
    implements Built<YoloPredictionResponse, YoloPredictionResponseBuilder> {
  // For YOLO the response will be an image that we'll display directly

  YoloPredictionResponse._();
  factory YoloPredictionResponse(
          [void Function(YoloPredictionResponseBuilder) updates]) =
      _$YoloPredictionResponse;

  static Serializer<YoloPredictionResponse> get serializer =>
      _$yoloPredictionResponseSerializer;

  static YoloPredictionResponse? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(YoloPredictionResponse.serializer, json);
  }
}

abstract class DenseNetPrediction
    implements Built<DenseNetPrediction, DenseNetPredictionBuilder> {
  // For DenseNet the response will be a zip containing multiple images

  DenseNetPrediction._();
  factory DenseNetPrediction(
          [void Function(DenseNetPredictionBuilder) updates]) =
      _$DenseNetPrediction;

  static Serializer<DenseNetPrediction> get serializer =>
      _$denseNetPredictionSerializer;

  static DenseNetPrediction? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(DenseNetPrediction.serializer, json);
  }
}
