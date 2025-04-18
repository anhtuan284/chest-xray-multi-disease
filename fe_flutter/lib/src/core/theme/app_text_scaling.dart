import 'package:flutter/material.dart';

/// Scales a TextTheme according to a given font size
TextTheme scaleTextTheme(TextTheme base, double fontSize) {
  final fontSizeFactor = fontSize / 14;
  return base.copyWith(
    displayLarge: base.displayLarge?.copyWith(
      fontSize: (base.displayLarge?.fontSize ?? 14) * fontSizeFactor,
    ),
    displayMedium: base.displayMedium?.copyWith(
      fontSize: (base.displayMedium?.fontSize ?? 14) * fontSizeFactor,
    ),
    displaySmall: base.displaySmall?.copyWith(
      fontSize: (base.displaySmall?.fontSize ?? 14) * fontSizeFactor,
    ),
    headlineLarge: base.headlineLarge?.copyWith(
      fontSize: (base.headlineLarge?.fontSize ?? 14) * fontSizeFactor,
    ),
    headlineMedium: base.headlineMedium?.copyWith(
      fontSize: (base.headlineMedium?.fontSize ?? 14) * fontSizeFactor,
    ),
    headlineSmall: base.headlineSmall?.copyWith(
      fontSize: (base.headlineSmall?.fontSize ?? 14) * fontSizeFactor,
    ),
    titleLarge: base.titleLarge?.copyWith(
      fontSize: (base.titleLarge?.fontSize ?? 14) * fontSizeFactor,
    ),
    titleMedium: base.titleMedium?.copyWith(
      fontSize: (base.titleMedium?.fontSize ?? 14) * fontSizeFactor,
    ),
    titleSmall: base.titleSmall?.copyWith(
      fontSize: (base.titleSmall?.fontSize ?? 14) * fontSizeFactor,
    ),
    bodyLarge: base.bodyLarge?.copyWith(
      fontSize: (base.bodyLarge?.fontSize ?? 14) * fontSizeFactor,
    ),
    bodyMedium: base.bodyMedium?.copyWith(
      fontSize: (base.bodyMedium?.fontSize ?? 14) * fontSizeFactor,
    ),
    bodySmall: base.bodySmall?.copyWith(
      fontSize: (base.bodySmall?.fontSize ?? 14) * fontSizeFactor,
    ),
    labelLarge: base.labelLarge?.copyWith(
      fontSize: (base.labelLarge?.fontSize ?? 14) * fontSizeFactor,
    ),
    labelMedium: base.labelMedium?.copyWith(
      fontSize: (base.labelMedium?.fontSize ?? 14) * fontSizeFactor,
    ),
    labelSmall: base.labelSmall?.copyWith(
      fontSize: (base.labelSmall?.fontSize ?? 14) * fontSizeFactor,
    ),
  );
}
