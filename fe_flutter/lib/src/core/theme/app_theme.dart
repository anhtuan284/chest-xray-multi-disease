import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_sizes.dart';
import 'app_text_styles.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      onPrimary: const Color(0xFF2B2B2B),
      primary: const Color.fromARGB(255, 28, 100, 255),
      surface: const Color.fromARGB(255, 251, 251, 251),
      onSurface: const Color(0xFF2B2B2B),
      seedColor: AppColors.primaryLight,
      onTertiary: const Color(0xFF2B2B2B),
      tertiary: const Color.fromARGB(255, 254, 254, 254),
      brightness: Brightness.light,
    ),
    textTheme: AppTextStyles.textTheme,
    cardTheme: CardTheme(
      elevation: AppSizes.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radius12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radius8),
      ),
      contentPadding: const EdgeInsets.all(AppSizes.space16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(AppSizes.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius8),
        ),
      ),
    ),
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryDark,
      onPrimary: const Color(0xFF2B2B2B),
      primary: const Color(0xFFFFDD58),
      surface: const Color.fromARGB(255, 21, 21, 21),
      onSurface: const Color.fromARGB(255, 202, 202, 202),
      onTertiary: const Color.fromARGB(255, 223, 223, 223),
      tertiary: const Color.fromARGB(255, 65, 65, 65),
      brightness: Brightness.dark,
    ),
    textTheme: AppTextStyles.textTheme.apply(
      bodyColor: AppColors.gray100,
      displayColor: AppColors.gray100,
    ),
    cardTheme: light.cardTheme,
    inputDecorationTheme: light.inputDecorationTheme,
    elevatedButtonTheme: light.elevatedButtonTheme,
  );
}
