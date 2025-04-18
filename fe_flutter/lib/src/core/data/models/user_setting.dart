import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:fe_flutter/src/core/serializers.dart';

part 'user_setting.g.dart';

abstract class UserSetting implements Built<UserSetting, UserSettingBuilder> {
  String? get themeName;
  bool? get isDarkMode;
  String? get language;
  int? get fontSize;
  String? get avatarPackName;

  UserSetting._();
  factory UserSetting([void Function(UserSettingBuilder) updates]) =
      _$UserSetting;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(UserSetting.serializer, this)
        as Map<String, dynamic>;
  }

  static UserSetting fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(UserSetting.serializer, json)!;
  }

  static Serializer<UserSetting> get serializer => _$userSettingSerializer;

  factory UserSetting.initial() => UserSetting((b) => b
    ..themeName = null
    ..isDarkMode = false
    ..language = 'en'
    ..fontSize = 14
    ..avatarPackName = null);
}
