import 'dart:convert';

import 'package:fe_flutter/src/core/serializers.dart';
import 'package:fe_flutter/src/core/utils/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/user_setting.dart';

class UserSettingService {
  static const String _userSettingKey = 'user_settings';
  final _logger = AppLogger.getLogger('UserSettingService');

  Future<void> saveUserSetting(UserSetting settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson =
          serializers.serializeWith(UserSetting.serializer, settings);
      await prefs.setString(_userSettingKey, json.encode(settingsJson));
      _logger.info('User settings saved successfully: $settings');
    } catch (e, stackTrace) {
      _logger.severe('Failed to save user settings', e, stackTrace);
      rethrow;
    }
  }

  /// Generic method to update any user setting
  Future<UserSetting> updateSetting<T>({
    required String settingName,
    required T value,
  }) async {
    _logger.info('Updating $settingName to: $value');
    try {
      final currentSettings = await getUserSetting();
      late UserSetting updatedSettings;

      // Update the appropriate field based on settingName
      switch (settingName) {
        case 'themeName':
          updatedSettings =
              currentSettings.rebuild((b) => b..themeName = value as String?);
          break;
        case 'isDarkMode':
          updatedSettings =
              currentSettings.rebuild((b) => b..isDarkMode = value as bool?);
          break;
        case 'language':
          updatedSettings =
              currentSettings.rebuild((b) => b..language = value as String?);
          break;
        case 'fontSize':
          updatedSettings =
              currentSettings.rebuild((b) => b..fontSize = value as int?);
          break;
        case 'avatarPackName':
          updatedSettings = currentSettings
              .rebuild((b) => b..avatarPackName = value as String?);
          break;
        default:
          _logger.warning('Unknown setting name: $settingName');
          throw ArgumentError('Unknown setting name: $settingName');
      }

      await saveUserSetting(updatedSettings);
      _logger.info('Setting $settingName updated successfully to: $value');
      return updatedSettings;
    } catch (e, stackTrace) {
      _logger.severe(
          'Failed to update setting: $settingName to $value', e, stackTrace);
      rethrow;
    }
  }

  Future<UserSetting> getUserSetting() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_userSettingKey);

      if (settingsJson == null) {
        _logger
            .info('No saved user settings found, returning default settings');
        return UserSetting.initial();
      }

      try {
        final map = json.decode(settingsJson) as Map<String, dynamic>;
        final settings = UserSetting.fromJson(map);
        _logger.fine('Retrieved user settings: $settings');
        return settings;
      } catch (e, stackTrace) {
        _logger.warning(
            'Error deserializing user settings, returning default settings',
            e,
            stackTrace);
        return UserSetting.initial();
      }
    } catch (e, stackTrace) {
      _logger.severe('Failed to get user settings', e, stackTrace);
      return UserSetting.initial();
    }
  }
}
