// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_setting.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<UserSetting> _$userSettingSerializer = new _$UserSettingSerializer();

class _$UserSettingSerializer implements StructuredSerializer<UserSetting> {
  @override
  final Iterable<Type> types = const [UserSetting, _$UserSetting];
  @override
  final String wireName = 'UserSetting';

  @override
  Iterable<Object?> serialize(Serializers serializers, UserSetting object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.themeName;
    if (value != null) {
      result
        ..add('themeName')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.isDarkMode;
    if (value != null) {
      result
        ..add('isDarkMode')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.language;
    if (value != null) {
      result
        ..add('language')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.fontSize;
    if (value != null) {
      result
        ..add('fontSize')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.avatarPackName;
    if (value != null) {
      result
        ..add('avatarPackName')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  UserSetting deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UserSettingBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'themeName':
          result.themeName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'isDarkMode':
          result.isDarkMode = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'language':
          result.language = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'fontSize':
          result.fontSize = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'avatarPackName':
          result.avatarPackName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$UserSetting extends UserSetting {
  @override
  final String? themeName;
  @override
  final bool? isDarkMode;
  @override
  final String? language;
  @override
  final int? fontSize;
  @override
  final String? avatarPackName;

  factory _$UserSetting([void Function(UserSettingBuilder)? updates]) =>
      (new UserSettingBuilder()..update(updates))._build();

  _$UserSetting._(
      {this.themeName,
      this.isDarkMode,
      this.language,
      this.fontSize,
      this.avatarPackName})
      : super._();

  @override
  UserSetting rebuild(void Function(UserSettingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserSettingBuilder toBuilder() => new UserSettingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserSetting &&
        themeName == other.themeName &&
        isDarkMode == other.isDarkMode &&
        language == other.language &&
        fontSize == other.fontSize &&
        avatarPackName == other.avatarPackName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, themeName.hashCode);
    _$hash = $jc(_$hash, isDarkMode.hashCode);
    _$hash = $jc(_$hash, language.hashCode);
    _$hash = $jc(_$hash, fontSize.hashCode);
    _$hash = $jc(_$hash, avatarPackName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserSetting')
          ..add('themeName', themeName)
          ..add('isDarkMode', isDarkMode)
          ..add('language', language)
          ..add('fontSize', fontSize)
          ..add('avatarPackName', avatarPackName))
        .toString();
  }
}

class UserSettingBuilder implements Builder<UserSetting, UserSettingBuilder> {
  _$UserSetting? _$v;

  String? _themeName;
  String? get themeName => _$this._themeName;
  set themeName(String? themeName) => _$this._themeName = themeName;

  bool? _isDarkMode;
  bool? get isDarkMode => _$this._isDarkMode;
  set isDarkMode(bool? isDarkMode) => _$this._isDarkMode = isDarkMode;

  String? _language;
  String? get language => _$this._language;
  set language(String? language) => _$this._language = language;

  int? _fontSize;
  int? get fontSize => _$this._fontSize;
  set fontSize(int? fontSize) => _$this._fontSize = fontSize;

  String? _avatarPackName;
  String? get avatarPackName => _$this._avatarPackName;
  set avatarPackName(String? avatarPackName) =>
      _$this._avatarPackName = avatarPackName;

  UserSettingBuilder();

  UserSettingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _themeName = $v.themeName;
      _isDarkMode = $v.isDarkMode;
      _language = $v.language;
      _fontSize = $v.fontSize;
      _avatarPackName = $v.avatarPackName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserSetting other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserSetting;
  }

  @override
  void update(void Function(UserSettingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserSetting build() => _build();

  _$UserSetting _build() {
    final _$result = _$v ??
        new _$UserSetting._(
          themeName: themeName,
          isDarkMode: isDarkMode,
          language: language,
          fontSize: fontSize,
          avatarPackName: avatarPackName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
