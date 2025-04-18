// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_models.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SearchRequest> _$searchRequestSerializer =
    new _$SearchRequestSerializer();
Serializer<SearchPreferences> _$searchPreferencesSerializer =
    new _$SearchPreferencesSerializer();
Serializer<SearchResponse> _$searchResponseSerializer =
    new _$SearchResponseSerializer();
Serializer<DocumentFile> _$documentFileSerializer =
    new _$DocumentFileSerializer();
Serializer<UploadResponse> _$uploadResponseSerializer =
    new _$UploadResponseSerializer();

class _$SearchRequestSerializer implements StructuredSerializer<SearchRequest> {
  @override
  final Iterable<Type> types = const [SearchRequest, _$SearchRequest];
  @override
  final String wireName = 'SearchRequest';

  @override
  Iterable<Object?> serialize(Serializers serializers, SearchRequest object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'query',
      serializers.serialize(object.query,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.tags;
    if (value != null) {
      result
        ..add('tags')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    value = object.preferences;
    if (value != null) {
      result
        ..add('preferences')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(SearchPreferences)));
    }
    return result;
  }

  @override
  SearchRequest deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SearchRequestBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'query':
          result.query = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'tags':
          result.tags.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'preferences':
          result.preferences.replace(serializers.deserialize(value,
                  specifiedType: const FullType(SearchPreferences))!
              as SearchPreferences);
          break;
      }
    }

    return result.build();
  }
}

class _$SearchPreferencesSerializer
    implements StructuredSerializer<SearchPreferences> {
  @override
  final Iterable<Type> types = const [SearchPreferences, _$SearchPreferences];
  @override
  final String wireName = 'SearchPreferences';

  @override
  Iterable<Object?> serialize(Serializers serializers, SearchPreferences object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'recents',
      serializers.serialize(object.recents,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
    ];

    return result;
  }

  @override
  SearchPreferences deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SearchPreferencesBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'recents':
          result.recents.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$SearchResponseSerializer
    implements StructuredSerializer<SearchResponse> {
  @override
  final Iterable<Type> types = const [SearchResponse, _$SearchResponse];
  @override
  final String wireName = 'SearchResponse';

  @override
  Iterable<Object?> serialize(Serializers serializers, SearchResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'answer',
      serializers.serialize(object.answer,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  SearchResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SearchResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'answer':
          result.answer = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$DocumentFileSerializer implements StructuredSerializer<DocumentFile> {
  @override
  final Iterable<Type> types = const [DocumentFile, _$DocumentFile];
  @override
  final String wireName = 'DocumentFile';

  @override
  Iterable<Object?> serialize(Serializers serializers, DocumentFile object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'filename',
      serializers.serialize(object.filename,
          specifiedType: const FullType(String)),
      'path',
      serializers.serialize(object.path, specifiedType: const FullType(String)),
      'size',
      serializers.serialize(object.size, specifiedType: const FullType(int)),
      'created',
      serializers.serialize(object.created,
          specifiedType: const FullType(double)),
    ];

    return result;
  }

  @override
  DocumentFile deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DocumentFileBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'filename':
          result.filename = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'path':
          result.path = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'size':
          result.size = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'created':
          result.created = serializers.deserialize(value,
              specifiedType: const FullType(double))! as double;
          break;
      }
    }

    return result.build();
  }
}

class _$UploadResponseSerializer
    implements StructuredSerializer<UploadResponse> {
  @override
  final Iterable<Type> types = const [UploadResponse, _$UploadResponse];
  @override
  final String wireName = 'UploadResponse';

  @override
  Iterable<Object?> serialize(Serializers serializers, UploadResponse object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'message',
      serializers.serialize(object.message,
          specifiedType: const FullType(String)),
      'path',
      serializers.serialize(object.path, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  UploadResponse deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UploadResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'message':
          result.message = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'path':
          result.path = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$SearchRequest extends SearchRequest {
  @override
  final String query;
  @override
  final BuiltList<String>? tags;
  @override
  final SearchPreferences? preferences;

  factory _$SearchRequest([void Function(SearchRequestBuilder)? updates]) =>
      (new SearchRequestBuilder()..update(updates))._build();

  _$SearchRequest._({required this.query, this.tags, this.preferences})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(query, r'SearchRequest', 'query');
  }

  @override
  SearchRequest rebuild(void Function(SearchRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchRequestBuilder toBuilder() => new SearchRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchRequest &&
        query == other.query &&
        tags == other.tags &&
        preferences == other.preferences;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, query.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jc(_$hash, preferences.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SearchRequest')
          ..add('query', query)
          ..add('tags', tags)
          ..add('preferences', preferences))
        .toString();
  }
}

class SearchRequestBuilder
    implements Builder<SearchRequest, SearchRequestBuilder> {
  _$SearchRequest? _$v;

  String? _query;
  String? get query => _$this._query;
  set query(String? query) => _$this._query = query;

  ListBuilder<String>? _tags;
  ListBuilder<String> get tags => _$this._tags ??= new ListBuilder<String>();
  set tags(ListBuilder<String>? tags) => _$this._tags = tags;

  SearchPreferencesBuilder? _preferences;
  SearchPreferencesBuilder get preferences =>
      _$this._preferences ??= new SearchPreferencesBuilder();
  set preferences(SearchPreferencesBuilder? preferences) =>
      _$this._preferences = preferences;

  SearchRequestBuilder();

  SearchRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _query = $v.query;
      _tags = $v.tags?.toBuilder();
      _preferences = $v.preferences?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SearchRequest;
  }

  @override
  void update(void Function(SearchRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchRequest build() => _build();

  _$SearchRequest _build() {
    _$SearchRequest _$result;
    try {
      _$result = _$v ??
          new _$SearchRequest._(
            query: BuiltValueNullFieldError.checkNotNull(
                query, r'SearchRequest', 'query'),
            tags: _tags?.build(),
            preferences: _preferences?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tags';
        _tags?.build();
        _$failedField = 'preferences';
        _preferences?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'SearchRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$SearchPreferences extends SearchPreferences {
  @override
  final BuiltList<String> recents;

  factory _$SearchPreferences(
          [void Function(SearchPreferencesBuilder)? updates]) =>
      (new SearchPreferencesBuilder()..update(updates))._build();

  _$SearchPreferences._({required this.recents}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        recents, r'SearchPreferences', 'recents');
  }

  @override
  SearchPreferences rebuild(void Function(SearchPreferencesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchPreferencesBuilder toBuilder() =>
      new SearchPreferencesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchPreferences && recents == other.recents;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, recents.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SearchPreferences')
          ..add('recents', recents))
        .toString();
  }
}

class SearchPreferencesBuilder
    implements Builder<SearchPreferences, SearchPreferencesBuilder> {
  _$SearchPreferences? _$v;

  ListBuilder<String>? _recents;
  ListBuilder<String> get recents =>
      _$this._recents ??= new ListBuilder<String>();
  set recents(ListBuilder<String>? recents) => _$this._recents = recents;

  SearchPreferencesBuilder();

  SearchPreferencesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _recents = $v.recents.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchPreferences other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SearchPreferences;
  }

  @override
  void update(void Function(SearchPreferencesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchPreferences build() => _build();

  _$SearchPreferences _build() {
    _$SearchPreferences _$result;
    try {
      _$result = _$v ??
          new _$SearchPreferences._(
            recents: recents.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'recents';
        recents.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'SearchPreferences', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$SearchResponse extends SearchResponse {
  @override
  final String answer;

  factory _$SearchResponse([void Function(SearchResponseBuilder)? updates]) =>
      (new SearchResponseBuilder()..update(updates))._build();

  _$SearchResponse._({required this.answer}) : super._() {
    BuiltValueNullFieldError.checkNotNull(answer, r'SearchResponse', 'answer');
  }

  @override
  SearchResponse rebuild(void Function(SearchResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchResponseBuilder toBuilder() =>
      new SearchResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchResponse && answer == other.answer;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, answer.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SearchResponse')
          ..add('answer', answer))
        .toString();
  }
}

class SearchResponseBuilder
    implements Builder<SearchResponse, SearchResponseBuilder> {
  _$SearchResponse? _$v;

  String? _answer;
  String? get answer => _$this._answer;
  set answer(String? answer) => _$this._answer = answer;

  SearchResponseBuilder();

  SearchResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _answer = $v.answer;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SearchResponse;
  }

  @override
  void update(void Function(SearchResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchResponse build() => _build();

  _$SearchResponse _build() {
    final _$result = _$v ??
        new _$SearchResponse._(
          answer: BuiltValueNullFieldError.checkNotNull(
              answer, r'SearchResponse', 'answer'),
        );
    replace(_$result);
    return _$result;
  }
}

class _$DocumentFile extends DocumentFile {
  @override
  final String filename;
  @override
  final String path;
  @override
  final int size;
  @override
  final double created;

  factory _$DocumentFile([void Function(DocumentFileBuilder)? updates]) =>
      (new DocumentFileBuilder()..update(updates))._build();

  _$DocumentFile._(
      {required this.filename,
      required this.path,
      required this.size,
      required this.created})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        filename, r'DocumentFile', 'filename');
    BuiltValueNullFieldError.checkNotNull(path, r'DocumentFile', 'path');
    BuiltValueNullFieldError.checkNotNull(size, r'DocumentFile', 'size');
    BuiltValueNullFieldError.checkNotNull(created, r'DocumentFile', 'created');
  }

  @override
  DocumentFile rebuild(void Function(DocumentFileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DocumentFileBuilder toBuilder() => new DocumentFileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DocumentFile &&
        filename == other.filename &&
        path == other.path &&
        size == other.size &&
        created == other.created;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, filename.hashCode);
    _$hash = $jc(_$hash, path.hashCode);
    _$hash = $jc(_$hash, size.hashCode);
    _$hash = $jc(_$hash, created.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DocumentFile')
          ..add('filename', filename)
          ..add('path', path)
          ..add('size', size)
          ..add('created', created))
        .toString();
  }
}

class DocumentFileBuilder
    implements Builder<DocumentFile, DocumentFileBuilder> {
  _$DocumentFile? _$v;

  String? _filename;
  String? get filename => _$this._filename;
  set filename(String? filename) => _$this._filename = filename;

  String? _path;
  String? get path => _$this._path;
  set path(String? path) => _$this._path = path;

  int? _size;
  int? get size => _$this._size;
  set size(int? size) => _$this._size = size;

  double? _created;
  double? get created => _$this._created;
  set created(double? created) => _$this._created = created;

  DocumentFileBuilder();

  DocumentFileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _filename = $v.filename;
      _path = $v.path;
      _size = $v.size;
      _created = $v.created;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DocumentFile other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DocumentFile;
  }

  @override
  void update(void Function(DocumentFileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DocumentFile build() => _build();

  _$DocumentFile _build() {
    final _$result = _$v ??
        new _$DocumentFile._(
          filename: BuiltValueNullFieldError.checkNotNull(
              filename, r'DocumentFile', 'filename'),
          path: BuiltValueNullFieldError.checkNotNull(
              path, r'DocumentFile', 'path'),
          size: BuiltValueNullFieldError.checkNotNull(
              size, r'DocumentFile', 'size'),
          created: BuiltValueNullFieldError.checkNotNull(
              created, r'DocumentFile', 'created'),
        );
    replace(_$result);
    return _$result;
  }
}

class _$UploadResponse extends UploadResponse {
  @override
  final String message;
  @override
  final String path;

  factory _$UploadResponse([void Function(UploadResponseBuilder)? updates]) =>
      (new UploadResponseBuilder()..update(updates))._build();

  _$UploadResponse._({required this.message, required this.path}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        message, r'UploadResponse', 'message');
    BuiltValueNullFieldError.checkNotNull(path, r'UploadResponse', 'path');
  }

  @override
  UploadResponse rebuild(void Function(UploadResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UploadResponseBuilder toBuilder() =>
      new UploadResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UploadResponse &&
        message == other.message &&
        path == other.path;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, path.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UploadResponse')
          ..add('message', message)
          ..add('path', path))
        .toString();
  }
}

class UploadResponseBuilder
    implements Builder<UploadResponse, UploadResponseBuilder> {
  _$UploadResponse? _$v;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  String? _path;
  String? get path => _$this._path;
  set path(String? path) => _$this._path = path;

  UploadResponseBuilder();

  UploadResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _message = $v.message;
      _path = $v.path;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UploadResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UploadResponse;
  }

  @override
  void update(void Function(UploadResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UploadResponse build() => _build();

  _$UploadResponse _build() {
    final _$result = _$v ??
        new _$UploadResponse._(
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'UploadResponse', 'message'),
          path: BuiltValueNullFieldError.checkNotNull(
              path, r'UploadResponse', 'path'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
