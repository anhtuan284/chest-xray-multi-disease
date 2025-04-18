import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/user_setting_repository.dart';
import 'app_theme.dart';

class ThemeNotifier extends StateNotifier<ThemeData> {
  final UserSettingRepository settings;
  bool _isDarkMode;

  ThemeNotifier(this.settings, {required bool isDarkMode})
      : _isDarkMode = isDarkMode,
        super(isDarkMode ? AppTheme.dark : AppTheme.light);

  bool get isDarkMode => _isDarkMode;

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    state = _isDarkMode ? AppTheme.dark : AppTheme.light;
    await settings.setDarkMode(_isDarkMode);
  }
}
