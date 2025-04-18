import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class ColorPalette {
  final String name;
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color background;

  const ColorPalette({
    required this.name,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.background,
  });
}

class AppColors {
  // Primary colors
  static const Color primary = Colors.orangeAccent;
  static const Color primaryLight = Color(0xFFFFE0B2);
  static const Color primaryDark = Color(0xFFFFA000);

  // Accent colors
  static const Color accent = Color(0xFFE8DEF8);
  static const Color accentLight = Color(0xFFF6EDFF);
  static const Color accentDark = Color(0xFFCAC4D0);

  // Mood colors
  static const Color verySad = Color(0xFFFF6B6B);
  static const Color sad = Color(0xFFFFB169);
  static const Color neutral = Color(0xFFFFD93D);
  static const Color happy = Color(0xFF6BCB77);
  static const Color veryHappy = Color(0xFF4D96FF);

  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF2196F3);

  // Gray scale
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  // Theme Palettes
  static const List<ColorPalette> themePalettes = [
    ColorPalette(
      name: 'Calm',
      primary: Color(0xFF2F5D4B),
      secondary: Color(0xFF6B9080),
      tertiary: Color(0xFFA4C3B2),
      background: Color(0xFFF6FFF8),
    ),
    ColorPalette(
      name: 'Sunset',
      primary: Color(0xFF9B2226),
      secondary: Color(0xFFEE6C4D),
      tertiary: Color(0xFFFFB703),
      background: Color(0xFFFFF8F0),
    ),
    ColorPalette(
      name: 'Ocean',
      primary: Color(0xFF1A3C4C),
      secondary: Color(0xFF2A9D8F),
      tertiary: Color(0xFF90E0EF),
      background: Color(0xFFEDF6F9),
    ),
    ColorPalette(
      name: 'Lavender',
      primary: Color(0xFF4C1D95),
      secondary: Color(0xFF8B5CF6),
      tertiary: Color(0xFFDDD6FE),
      background: Color(0xFFF6F2FF),
    ),
    ColorPalette(
      name: 'Forest',
      primary: Color(0xFF1B4332),
      secondary: Color(0xFF40916C),
      tertiary: Color(0xFF95D5B2),
      background: Color(0xFFF0FFF4),
    ),
  ];

  static ColorPalette? getPaletteByName(String? name) {
    return themePalettes.firstWhereOrNull((palette) => palette.name == name);
  }
}
