// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disease_stats_models.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<WeeklyStatsResponse> _$weeklyStatsResponseSerializer =
    new _$WeeklyStatsResponseSerializer();
Serializer<WeeklyStatsData> _$weeklyStatsDataSerializer =
    new _$WeeklyStatsDataSerializer();
Serializer<DiseaseSummaryResponse> _$diseaseSummaryResponseSerializer =
    new _$DiseaseSummaryResponseSerializer();
Serializer<DiseaseSummaryData> _$diseaseSummaryDataSerializer =
    new _$DiseaseSummaryDataSerializer();

class _$WeeklyStatsResponseSerializer
    implements StructuredSerializer<WeeklyStatsResponse> {
  @override
  final Iterable<Type> types = const [
    WeeklyStatsResponse,
    _$WeeklyStatsResponse
  ];
  @override
  final String wireName = 'WeeklyStatsResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, WeeklyStatsResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'status',
      serializers.serialize(object.status,
          specifiedType: const FullType(String)),
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(WeeklyStatsData)),
    ];

    return result;
  }

  @override
  WeeklyStatsResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new WeeklyStatsResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'data':
          result.data.replace(serializers.deserialize(value,
                  specifiedType: const FullType(WeeklyStatsData))!
              as WeeklyStatsData);
          break;
      }
    }

    return result.build();
  }
}

class _$WeeklyStatsDataSerializer
    implements StructuredSerializer<WeeklyStatsData> {
  @override
  final Iterable<Type> types = const [WeeklyStatsData, _$WeeklyStatsData];
  @override
  final String wireName = 'WeeklyStatsData';

  @override
  Iterable<Object?> serialize(Serializers serializers, WeeklyStatsData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'weekly_stats',
      serializers.serialize(object.weekly_stats,
          specifiedType: const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(
                BuiltMap, const [const FullType(String), const FullType(int)])
          ])),
      'total',
      serializers.serialize(object.total,
          specifiedType: const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)])),
    ];

    return result;
  }

  @override
  WeeklyStatsData deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new WeeklyStatsDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'weekly_stats':
          result.weekly_stats.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(BuiltMap,
                    const [const FullType(String), const FullType(int)])
              ]))!);
          break;
        case 'total':
          result.total.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap,
                  const [const FullType(String), const FullType(int)]))!);
          break;
      }
    }

    return result.build();
  }
}

class _$DiseaseSummaryResponseSerializer
    implements StructuredSerializer<DiseaseSummaryResponse> {
  @override
  final Iterable<Type> types = const [
    DiseaseSummaryResponse,
    _$DiseaseSummaryResponse
  ];
  @override
  final String wireName = 'DiseaseSummaryResponse';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, DiseaseSummaryResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'status',
      serializers.serialize(object.status,
          specifiedType: const FullType(String)),
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(DiseaseSummaryData)),
    ];

    return result;
  }

  @override
  DiseaseSummaryResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DiseaseSummaryResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'data':
          result.data.replace(serializers.deserialize(value,
                  specifiedType: const FullType(DiseaseSummaryData))!
              as DiseaseSummaryData);
          break;
      }
    }

    return result.build();
  }
}

class _$DiseaseSummaryDataSerializer
    implements StructuredSerializer<DiseaseSummaryData> {
  @override
  final Iterable<Type> types = const [DiseaseSummaryData, _$DiseaseSummaryData];
  @override
  final String wireName = 'DiseaseSummaryData';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, DiseaseSummaryData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'summary',
      serializers.serialize(object.summary,
          specifiedType: const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)])),
      'total_predictions',
      serializers.serialize(object.total_predictions,
          specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  DiseaseSummaryData deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DiseaseSummaryDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'summary':
          result.summary.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap,
                  const [const FullType(String), const FullType(int)]))!);
          break;
        case 'total_predictions':
          result.total_predictions = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
      }
    }

    return result.build();
  }
}

class _$WeeklyStatsResponse extends WeeklyStatsResponse {
  @override
  final String status;
  @override
  final WeeklyStatsData data;

  factory _$WeeklyStatsResponse(
          [void Function(WeeklyStatsResponseBuilder)? updates]) =>
      (new WeeklyStatsResponseBuilder()..update(updates))._build();

  _$WeeklyStatsResponse._({required this.status, required this.data})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        status, r'WeeklyStatsResponse', 'status');
    BuiltValueNullFieldError.checkNotNull(data, r'WeeklyStatsResponse', 'data');
  }

  @override
  WeeklyStatsResponse rebuild(
          void Function(WeeklyStatsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WeeklyStatsResponseBuilder toBuilder() =>
      new WeeklyStatsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WeeklyStatsResponse &&
        status == other.status &&
        data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WeeklyStatsResponse')
          ..add('status', status)
          ..add('data', data))
        .toString();
  }
}

class WeeklyStatsResponseBuilder
    implements Builder<WeeklyStatsResponse, WeeklyStatsResponseBuilder> {
  _$WeeklyStatsResponse? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  WeeklyStatsDataBuilder? _data;
  WeeklyStatsDataBuilder get data =>
      _$this._data ??= new WeeklyStatsDataBuilder();
  set data(WeeklyStatsDataBuilder? data) => _$this._data = data;

  WeeklyStatsResponseBuilder();

  WeeklyStatsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WeeklyStatsResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$WeeklyStatsResponse;
  }

  @override
  void update(void Function(WeeklyStatsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WeeklyStatsResponse build() => _build();

  _$WeeklyStatsResponse _build() {
    _$WeeklyStatsResponse _$result;
    try {
      _$result = _$v ??
          new _$WeeklyStatsResponse._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'WeeklyStatsResponse', 'status'),
            data: data.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'WeeklyStatsResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$WeeklyStatsData extends WeeklyStatsData {
  @override
  final BuiltMap<String, BuiltMap<String, int>> weekly_stats;
  @override
  final BuiltMap<String, int> total;

  factory _$WeeklyStatsData([void Function(WeeklyStatsDataBuilder)? updates]) =>
      (new WeeklyStatsDataBuilder()..update(updates))._build();

  _$WeeklyStatsData._({required this.weekly_stats, required this.total})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        weekly_stats, r'WeeklyStatsData', 'weekly_stats');
    BuiltValueNullFieldError.checkNotNull(total, r'WeeklyStatsData', 'total');
  }

  @override
  WeeklyStatsData rebuild(void Function(WeeklyStatsDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WeeklyStatsDataBuilder toBuilder() =>
      new WeeklyStatsDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WeeklyStatsData &&
        weekly_stats == other.weekly_stats &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, weekly_stats.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WeeklyStatsData')
          ..add('weekly_stats', weekly_stats)
          ..add('total', total))
        .toString();
  }
}

class WeeklyStatsDataBuilder
    implements Builder<WeeklyStatsData, WeeklyStatsDataBuilder> {
  _$WeeklyStatsData? _$v;

  MapBuilder<String, BuiltMap<String, int>>? _weekly_stats;
  MapBuilder<String, BuiltMap<String, int>> get weekly_stats =>
      _$this._weekly_stats ??= new MapBuilder<String, BuiltMap<String, int>>();
  set weekly_stats(MapBuilder<String, BuiltMap<String, int>>? weekly_stats) =>
      _$this._weekly_stats = weekly_stats;

  MapBuilder<String, int>? _total;
  MapBuilder<String, int> get total =>
      _$this._total ??= new MapBuilder<String, int>();
  set total(MapBuilder<String, int>? total) => _$this._total = total;

  WeeklyStatsDataBuilder();

  WeeklyStatsDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _weekly_stats = $v.weekly_stats.toBuilder();
      _total = $v.total.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WeeklyStatsData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$WeeklyStatsData;
  }

  @override
  void update(void Function(WeeklyStatsDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WeeklyStatsData build() => _build();

  _$WeeklyStatsData _build() {
    _$WeeklyStatsData _$result;
    try {
      _$result = _$v ??
          new _$WeeklyStatsData._(
            weekly_stats: weekly_stats.build(),
            total: total.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'weekly_stats';
        weekly_stats.build();
        _$failedField = 'total';
        total.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'WeeklyStatsData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$DiseaseSummaryResponse extends DiseaseSummaryResponse {
  @override
  final String status;
  @override
  final DiseaseSummaryData data;

  factory _$DiseaseSummaryResponse(
          [void Function(DiseaseSummaryResponseBuilder)? updates]) =>
      (new DiseaseSummaryResponseBuilder()..update(updates))._build();

  _$DiseaseSummaryResponse._({required this.status, required this.data})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        status, r'DiseaseSummaryResponse', 'status');
    BuiltValueNullFieldError.checkNotNull(
        data, r'DiseaseSummaryResponse', 'data');
  }

  @override
  DiseaseSummaryResponse rebuild(
          void Function(DiseaseSummaryResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DiseaseSummaryResponseBuilder toBuilder() =>
      new DiseaseSummaryResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DiseaseSummaryResponse &&
        status == other.status &&
        data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DiseaseSummaryResponse')
          ..add('status', status)
          ..add('data', data))
        .toString();
  }
}

class DiseaseSummaryResponseBuilder
    implements Builder<DiseaseSummaryResponse, DiseaseSummaryResponseBuilder> {
  _$DiseaseSummaryResponse? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  DiseaseSummaryDataBuilder? _data;
  DiseaseSummaryDataBuilder get data =>
      _$this._data ??= new DiseaseSummaryDataBuilder();
  set data(DiseaseSummaryDataBuilder? data) => _$this._data = data;

  DiseaseSummaryResponseBuilder();

  DiseaseSummaryResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DiseaseSummaryResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DiseaseSummaryResponse;
  }

  @override
  void update(void Function(DiseaseSummaryResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DiseaseSummaryResponse build() => _build();

  _$DiseaseSummaryResponse _build() {
    _$DiseaseSummaryResponse _$result;
    try {
      _$result = _$v ??
          new _$DiseaseSummaryResponse._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'DiseaseSummaryResponse', 'status'),
            data: data.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'DiseaseSummaryResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$DiseaseSummaryData extends DiseaseSummaryData {
  @override
  final BuiltMap<String, int> summary;
  @override
  final int total_predictions;

  factory _$DiseaseSummaryData(
          [void Function(DiseaseSummaryDataBuilder)? updates]) =>
      (new DiseaseSummaryDataBuilder()..update(updates))._build();

  _$DiseaseSummaryData._(
      {required this.summary, required this.total_predictions})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        summary, r'DiseaseSummaryData', 'summary');
    BuiltValueNullFieldError.checkNotNull(
        total_predictions, r'DiseaseSummaryData', 'total_predictions');
  }

  @override
  DiseaseSummaryData rebuild(
          void Function(DiseaseSummaryDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DiseaseSummaryDataBuilder toBuilder() =>
      new DiseaseSummaryDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DiseaseSummaryData &&
        summary == other.summary &&
        total_predictions == other.total_predictions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, summary.hashCode);
    _$hash = $jc(_$hash, total_predictions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DiseaseSummaryData')
          ..add('summary', summary)
          ..add('total_predictions', total_predictions))
        .toString();
  }
}

class DiseaseSummaryDataBuilder
    implements Builder<DiseaseSummaryData, DiseaseSummaryDataBuilder> {
  _$DiseaseSummaryData? _$v;

  MapBuilder<String, int>? _summary;
  MapBuilder<String, int> get summary =>
      _$this._summary ??= new MapBuilder<String, int>();
  set summary(MapBuilder<String, int>? summary) => _$this._summary = summary;

  int? _total_predictions;
  int? get total_predictions => _$this._total_predictions;
  set total_predictions(int? total_predictions) =>
      _$this._total_predictions = total_predictions;

  DiseaseSummaryDataBuilder();

  DiseaseSummaryDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _summary = $v.summary.toBuilder();
      _total_predictions = $v.total_predictions;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DiseaseSummaryData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DiseaseSummaryData;
  }

  @override
  void update(void Function(DiseaseSummaryDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DiseaseSummaryData build() => _build();

  _$DiseaseSummaryData _build() {
    _$DiseaseSummaryData _$result;
    try {
      _$result = _$v ??
          new _$DiseaseSummaryData._(
            summary: summary.build(),
            total_predictions: BuiltValueNullFieldError.checkNotNull(
                total_predictions, r'DiseaseSummaryData', 'total_predictions'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'summary';
        summary.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'DiseaseSummaryData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
