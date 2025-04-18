// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutorial_step.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<TutorialStep> _$tutorialStepSerializer =
    new _$TutorialStepSerializer();

class _$TutorialStepSerializer implements StructuredSerializer<TutorialStep> {
  @override
  final Iterable<Type> types = const [TutorialStep, _$TutorialStep];
  @override
  final String wireName = 'TutorialStep';

  @override
  Iterable<Object?> serialize(Serializers serializers, TutorialStep object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
      'position',
      serializers.serialize(object.position,
          specifiedType: const FullType(Offset)),
      'size',
      serializers.serialize(object.size, specifiedType: const FullType(Size)),
    ];

    return result;
  }

  @override
  TutorialStep deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TutorialStepBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'position':
          result.position = serializers.deserialize(value,
              specifiedType: const FullType(Offset))! as Offset;
          break;
        case 'size':
          result.size = serializers.deserialize(value,
              specifiedType: const FullType(Size))! as Size;
          break;
      }
    }

    return result.build();
  }
}

class _$TutorialStep extends TutorialStep {
  @override
  final String title;
  @override
  final String description;
  @override
  final Offset position;
  @override
  final Size size;

  factory _$TutorialStep([void Function(TutorialStepBuilder)? updates]) =>
      (new TutorialStepBuilder()..update(updates))._build();

  _$TutorialStep._(
      {required this.title,
      required this.description,
      required this.position,
      required this.size})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(title, r'TutorialStep', 'title');
    BuiltValueNullFieldError.checkNotNull(
        description, r'TutorialStep', 'description');
    BuiltValueNullFieldError.checkNotNull(
        position, r'TutorialStep', 'position');
    BuiltValueNullFieldError.checkNotNull(size, r'TutorialStep', 'size');
  }

  @override
  TutorialStep rebuild(void Function(TutorialStepBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TutorialStepBuilder toBuilder() => new TutorialStepBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TutorialStep &&
        title == other.title &&
        description == other.description &&
        position == other.position &&
        size == other.size;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, size.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TutorialStep')
          ..add('title', title)
          ..add('description', description)
          ..add('position', position)
          ..add('size', size))
        .toString();
  }
}

class TutorialStepBuilder
    implements Builder<TutorialStep, TutorialStepBuilder> {
  _$TutorialStep? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  Offset? _position;
  Offset? get position => _$this._position;
  set position(Offset? position) => _$this._position = position;

  Size? _size;
  Size? get size => _$this._size;
  set size(Size? size) => _$this._size = size;

  TutorialStepBuilder();

  TutorialStepBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _description = $v.description;
      _position = $v.position;
      _size = $v.size;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TutorialStep other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$TutorialStep;
  }

  @override
  void update(void Function(TutorialStepBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TutorialStep build() => _build();

  _$TutorialStep _build() {
    final _$result = _$v ??
        new _$TutorialStep._(
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'TutorialStep', 'title'),
          description: BuiltValueNullFieldError.checkNotNull(
              description, r'TutorialStep', 'description'),
          position: BuiltValueNullFieldError.checkNotNull(
              position, r'TutorialStep', 'position'),
          size: BuiltValueNullFieldError.checkNotNull(
              size, r'TutorialStep', 'size'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
