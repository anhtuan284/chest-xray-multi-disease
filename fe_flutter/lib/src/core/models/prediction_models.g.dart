// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prediction_models.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<YoloPredictionResponse> _$yoloPredictionResponseSerializer =
    new _$YoloPredictionResponseSerializer();
Serializer<DenseNetPrediction> _$denseNetPredictionSerializer =
    new _$DenseNetPredictionSerializer();

class _$YoloPredictionResponseSerializer
    implements StructuredSerializer<YoloPredictionResponse> {
  @override
  final Iterable<Type> types = const [
    YoloPredictionResponse,
    _$YoloPredictionResponse
  ];
  @override
  final String wireName = 'YoloPredictionResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, YoloPredictionResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    return <Object?>[];
  }

  @override
  YoloPredictionResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    return new YoloPredictionResponseBuilder().build();
  }
}

class _$DenseNetPredictionSerializer
    implements StructuredSerializer<DenseNetPrediction> {
  @override
  final Iterable<Type> types = const [DenseNetPrediction, _$DenseNetPrediction];
  @override
  final String wireName = 'DenseNetPrediction';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, DenseNetPrediction object,
      {FullType specifiedType = FullType.unspecified}) {
    return <Object?>[];
  }

  @override
  DenseNetPrediction deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    return new DenseNetPredictionBuilder().build();
  }
}

class _$YoloPredictionResponse extends YoloPredictionResponse {
  factory _$YoloPredictionResponse(
          [void Function(YoloPredictionResponseBuilder)? updates]) =>
      (new YoloPredictionResponseBuilder()..update(updates))._build();

  _$YoloPredictionResponse._() : super._();

  @override
  YoloPredictionResponse rebuild(
          void Function(YoloPredictionResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  YoloPredictionResponseBuilder toBuilder() =>
      new YoloPredictionResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is YoloPredictionResponse;
  }

  @override
  int get hashCode {
    return 978645117;
  }

  @override
  String toString() {
    return newBuiltValueToStringHelper(r'YoloPredictionResponse').toString();
  }
}

class YoloPredictionResponseBuilder
    implements Builder<YoloPredictionResponse, YoloPredictionResponseBuilder> {
  _$YoloPredictionResponse? _$v;

  YoloPredictionResponseBuilder();

  @override
  void replace(YoloPredictionResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$YoloPredictionResponse;
  }

  @override
  void update(void Function(YoloPredictionResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  YoloPredictionResponse build() => _build();

  _$YoloPredictionResponse _build() {
    final _$result = _$v ?? new _$YoloPredictionResponse._();
    replace(_$result);
    return _$result;
  }
}

class _$DenseNetPrediction extends DenseNetPrediction {
  factory _$DenseNetPrediction(
          [void Function(DenseNetPredictionBuilder)? updates]) =>
      (new DenseNetPredictionBuilder()..update(updates))._build();

  _$DenseNetPrediction._() : super._();

  @override
  DenseNetPrediction rebuild(
          void Function(DenseNetPredictionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DenseNetPredictionBuilder toBuilder() =>
      new DenseNetPredictionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DenseNetPrediction;
  }

  @override
  int get hashCode {
    return 567478014;
  }

  @override
  String toString() {
    return newBuiltValueToStringHelper(r'DenseNetPrediction').toString();
  }
}

class DenseNetPredictionBuilder
    implements Builder<DenseNetPrediction, DenseNetPredictionBuilder> {
  _$DenseNetPrediction? _$v;

  DenseNetPredictionBuilder();

  @override
  void replace(DenseNetPrediction other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DenseNetPrediction;
  }

  @override
  void update(void Function(DenseNetPredictionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DenseNetPrediction build() => _build();

  _$DenseNetPrediction _build() {
    final _$result = _$v ?? new _$DenseNetPrediction._();
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
