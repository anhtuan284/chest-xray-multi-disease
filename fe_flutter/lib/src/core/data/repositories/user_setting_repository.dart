import 'package:fe_flutter/src/core/data/models/user_setting.dart';
import 'package:fe_flutter/src/core/utils/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/user_settings_service.dart';

class UserSettingRepository extends StateNotifier<UserSetting> {
  final UserSettingService _settingsService;
  final _logger = AppLogger.getLogger('UserSettingRepository');

  UserSettingRepository(this._settingsService) : super(UserSetting.initial()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _settingsService.getUserSetting();
    state = settings;
  }

  /// Update any setting using the generic updateSetting method
  Future<void> updateSetting<T>(
      {required String settingName, required T value}) async {
    _logger.info('Updating setting: $settingName to $value');
    try {
      final updatedSettings = await _settingsService.updateSetting(
        settingName: settingName,
        value: value,
      );
      state = updatedSettings;
      _logger.info('State updated for setting: $settingName');
    } catch (e, stackTrace) {
      _logger.severe('Failed to update setting in repository', e, stackTrace);
      rethrow;
    }
  }

  /// Update theme - convenience method
  Future<void> setTheme(String paletteName) async {
    await updateSetting(settingName: 'themeName', value: paletteName);
  }

  /// Toggle dark mode - convenience method
  Future<void> setDarkMode(bool isDarkMode) async {
    await updateSetting(settingName: 'isDarkMode', value: isDarkMode);
  }

  /// Update language - convenience method
  Future<void> setLanguage(String language) async {
    await updateSetting(settingName: 'language', value: language);
  }

  /// Update font size - convenience method
  Future<void> setFontSize(int fontSize) async {
    await updateSetting(settingName: 'fontSize', value: fontSize);
  }

  /// Update avatar pack - convenience method
  Future<void> setAvatarPack(String avatarPackName) async {
    _logger.info('Setting avatar pack: $avatarPackName');
    await updateSetting(settingName: 'avatarPackName', value: avatarPackName);
  }
}
