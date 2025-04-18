import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  static final TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.angkor(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      color: AppColors.gray900,
    ),
    displayMedium: GoogleFonts.angkor(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      color: AppColors.gray900,
    ),
    displaySmall: GoogleFonts.angkor(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      color: AppColors.gray900,
    ),
    headlineLarge: GoogleFonts.angkor(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: AppColors.gray900,
    ),
    headlineMedium: GoogleFonts.angkor(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: AppColors.gray900,
    ),
    headlineSmall: GoogleFonts.angkor(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.gray900,
    ),
    titleLarge: GoogleFonts.anonymousPro(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: AppColors.gray900,
    ),
    titleMedium: GoogleFonts.anonymousPro(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: AppColors.gray900,
    ),
    titleSmall: GoogleFonts.anonymousPro(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: AppColors.gray900,
    ),
    bodyLarge: GoogleFonts.anonymousPro(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      color: AppColors.gray800,
    ),
    bodyMedium: GoogleFonts.anonymousPro(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: AppColors.gray800,
    ),
    bodySmall: GoogleFonts.anonymousPro(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: AppColors.gray700,
    ),
  );
}
