// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_slide.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<FeatureSlide> _$featureSlideSerializer =
    new _$FeatureSlideSerializer();

class _$FeatureSlideSerializer implements StructuredSerializer<FeatureSlide> {
  @override
  final Iterable<Type> types = const [FeatureSlide, _$FeatureSlide];
  @override
  final String wireName = 'FeatureSlide';

  @override
  Iterable<Object?> serialize(Serializers serializers, FeatureSlide object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
      'icon',
      serializers.serialize(object.icon,
          specifiedType: const FullType(IconData)),
      'color',
      serializers.serialize(object.color, specifiedType: const FullType(Color)),
    ];
    Object? value;
    value = object.imagePath;
    if (value != null) {
      result
        ..add('imagePath')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.customWidget;
    if (value != null) {
      result
        ..add('customWidget')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(Widget)));
    }
    return result;
  }

  @override
  FeatureSlide deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FeatureSlideBuilder();

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
        case 'icon':
          result.icon = serializers.deserialize(value,
              specifiedType: const FullType(IconData))! as IconData;
          break;
        case 'color':
          result.color = serializers.deserialize(value,
              specifiedType: const FullType(Color))! as Color;
          break;
        case 'imagePath':
          result.imagePath = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'customWidget':
          result.customWidget = serializers.deserialize(value,
              specifiedType: const FullType(Widget)) as Widget?;
          break;
      }
    }

    return result.build();
  }
}

class _$FeatureSlide extends FeatureSlide {
  @override
  final String title;
  @override
  final String description;
  @override
  final IconData icon;
  @override
  final Color color;
  @override
  final String? imagePath;
  @override
  final Widget? customWidget;
  @override
  final Map<String, dynamic>? customAnimation;

  factory _$FeatureSlide([void Function(FeatureSlideBuilder)? updates]) =>
      (new FeatureSlideBuilder()..update(updates))._build();

  _$FeatureSlide._(
      {required this.title,
      required this.description,
      required this.icon,
      required this.color,
      this.imagePath,
      this.customWidget,
      this.customAnimation})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(title, r'FeatureSlide', 'title');
    BuiltValueNullFieldError.checkNotNull(
        description, r'FeatureSlide', 'description');
    BuiltValueNullFieldError.checkNotNull(icon, r'FeatureSlide', 'icon');
    BuiltValueNullFieldError.checkNotNull(color, r'FeatureSlide', 'color');
  }

  @override
  FeatureSlide rebuild(void Function(FeatureSlideBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FeatureSlideBuilder toBuilder() => new FeatureSlideBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FeatureSlide &&
        title == other.title &&
        description == other.description &&
        icon == other.icon &&
        color == other.color &&
        imagePath == other.imagePath &&
        customWidget == other.customWidget &&
        customAnimation == other.customAnimation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, icon.hashCode);
    _$hash = $jc(_$hash, color.hashCode);
    _$hash = $jc(_$hash, imagePath.hashCode);
    _$hash = $jc(_$hash, customWidget.hashCode);
    _$hash = $jc(_$hash, customAnimation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FeatureSlide')
          ..add('title', title)
          ..add('description', description)
          ..add('icon', icon)
          ..add('color', color)
          ..add('imagePath', imagePath)
          ..add('customWidget', customWidget)
          ..add('customAnimation', customAnimation))
        .toString();
  }
}

class FeatureSlideBuilder
    implements Builder<FeatureSlide, FeatureSlideBuilder> {
  _$FeatureSlide? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  IconData? _icon;
  IconData? get icon => _$this._icon;
  set icon(IconData? icon) => _$this._icon = icon;

  Color? _color;
  Color? get color => _$this._color;
  set color(Color? color) => _$this._color = color;

  String? _imagePath;
  String? get imagePath => _$this._imagePath;
  set imagePath(String? imagePath) => _$this._imagePath = imagePath;

  Widget? _customWidget;
  Widget? get customWidget => _$this._customWidget;
  set customWidget(Widget? customWidget) => _$this._customWidget = customWidget;

  Map<String, dynamic>? _customAnimation;
  Map<String, dynamic>? get customAnimation => _$this._customAnimation;
  set customAnimation(Map<String, dynamic>? customAnimation) =>
      _$this._customAnimation = customAnimation;

  FeatureSlideBuilder();

  FeatureSlideBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _description = $v.description;
      _icon = $v.icon;
      _color = $v.color;
      _imagePath = $v.imagePath;
      _customWidget = $v.customWidget;
      _customAnimation = $v.customAnimation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FeatureSlide other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$FeatureSlide;
  }

  @override
  void update(void Function(FeatureSlideBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FeatureSlide build() => _build();

  _$FeatureSlide _build() {
    final _$result = _$v ??
        new _$FeatureSlide._(
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'FeatureSlide', 'title'),
          description: BuiltValueNullFieldError.checkNotNull(
              description, r'FeatureSlide', 'description'),
          icon: BuiltValueNullFieldError.checkNotNull(
              icon, r'FeatureSlide', 'icon'),
          color: BuiltValueNullFieldError.checkNotNull(
              color, r'FeatureSlide', 'color'),
          imagePath: imagePath,
          customWidget: customWidget,
          customAnimation: customAnimation,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
