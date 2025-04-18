import 'package:flutter/material.dart';

/// Enum representing mood level categories
enum MoodLevel { veryPoor, poor, neutral, good, excellent }

/// Represents a mood category with its associated properties
class MoodCategory {
  final double threshold;
  final IconData icon;
  final String emoji;
  final Color Function(ColorScheme) colorFn;
  final String label;

  const MoodCategory({
    required this.threshold,
    required this.icon,
    required this.emoji,
    required this.colorFn,
    required this.label,
  });
}

/// Utility class for mood-related functionality
class MoodUtils {
  // Private constructor to prevent instantiation
  MoodUtils._();
  static List<String> getAvailableMonthNames() {
    /// Returns a list of month names
    return <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
  }

  /// The list of mood categories, ordered by threshold (lowest to highest)
  static List<MoodCategory> moodCategories = [
    MoodCategory(
      threshold: 0.0,
      icon: Icons.sentiment_very_dissatisfied,
      emoji: '😢',
      colorFn: (_) => Colors.red,
      label: 'Very Sad',
    ),
    MoodCategory(
      threshold: 2.0,
      icon: Icons.sentiment_dissatisfied,
      emoji: '😕',
      colorFn: (_) => Colors.orange,
      label: 'Sad',
    ),
    MoodCategory(
      threshold: 4.0,
      icon: Icons.sentiment_neutral,
      emoji: '😐',
      colorFn: (colorScheme) => colorScheme.primary,
      label: 'Neutral',
    ),
    MoodCategory(
      threshold: 6.0,
      icon: Icons.sentiment_satisfied,
      emoji: '😊',
      colorFn: (_) => Colors.lightGreen,
      label: 'Happy',
    ),
    MoodCategory(
      threshold: 8.0,
      icon: Icons.sentiment_very_satisfied,
      emoji: '😄',
      colorFn: (_) => Colors.green,
      label: 'Very Happy',
    ),
  ];

  /// Standard mood level definitions with thresholds and display labels
  static final Map<MoodLevel, Map<String, dynamic>> moodLevels = {
    MoodLevel.excellent: {
      'label': 'Excellent',
      'chartLabel': 'Excellent (8-10)',
      'minThreshold': 8.0,
      'maxThreshold': 10.0,
    },
    MoodLevel.good: {
      'label': 'Good',
      'chartLabel': 'Good (6-8)',
      'minThreshold': 6.0,
      'maxThreshold': 8.0,
    },
    MoodLevel.neutral: {
      'label': 'Neutral',
      'chartLabel': 'Neutral (4-6)',
      'minThreshold': 4.0,
      'maxThreshold': 6.0,
    },
    MoodLevel.poor: {
      'label': 'Poor',
      'chartLabel': 'Poor (2-4)',
      'minThreshold': 2.0,
      'maxThreshold': 4.0,
    },
    MoodLevel.veryPoor: {
      'label': 'Very Poor',
      'chartLabel': 'Very Poor (0-2)',
      'minThreshold': 0.0,
      'maxThreshold': 2.0,
    },
  };

  /// Standard mood colors for visualization
  static const Map<MoodLevel, Color> moodColors = {
    MoodLevel.excellent: Color(0xFF1E88E5), // Blue
    MoodLevel.good: Color(0xFF43A047), // Green
    MoodLevel.neutral: Color(0xFFFBC02D), // Yellow
    MoodLevel.poor: Color(0xFFFF9800), // Orange
    MoodLevel.veryPoor: Color(0xFFE53935), // Red
  };

  /// Get color for a mood level
  static Color getColorForMoodLevel(MoodLevel level) {
    return moodColors[level] ?? Colors.grey;
  }

  /// Get color for a mood score
  static Color getColorForMoodScore(double score) {
    final level = getMoodLevelFromScore(score);
    return getColorForMoodLevel(level);
  }

  /// Get all mood level chart labels in descending order (best to worst)
  static List<String> getAllMoodLevelChartLabels() {
    return [
      moodLevels[MoodLevel.excellent]!['chartLabel'],
      moodLevels[MoodLevel.good]!['chartLabel'],
      moodLevels[MoodLevel.neutral]!['chartLabel'],
      moodLevels[MoodLevel.poor]!['chartLabel'],
      moodLevels[MoodLevel.veryPoor]!['chartLabel'],
    ];
  }

  /// Get mood level enum from a score
  static MoodLevel getMoodLevelFromScore(double score) {
    if (score >= moodLevels[MoodLevel.excellent]!['minThreshold']) {
      return MoodLevel.excellent;
    }
    if (score >= moodLevels[MoodLevel.good]!['minThreshold']) {
      return MoodLevel.good;
    }
    if (score >= moodLevels[MoodLevel.neutral]!['minThreshold']) {
      return MoodLevel.neutral;
    }
    if (score >= moodLevels[MoodLevel.poor]!['minThreshold']) {
      return MoodLevel.poor;
    }
    return MoodLevel.veryPoor;
  }

  /// Get mood level chart label from a score
  static String getMoodLevelChartLabel(double score) {
    final level = getMoodLevelFromScore(score);
    return moodLevels[level]!['chartLabel'];
  }

  /// Get mood level short label from a score
  static String getMoodLevelLabel(double score) {
    final level = getMoodLevelFromScore(score);
    return moodLevels[level]!['label'];
  }

  /// Gets the mood category for a given mood score
  static MoodCategory getMoodCategory(double moodScore) {
    // Find the highest category where the score is >= the threshold
    for (int i = moodCategories.length - 1; i >= 0; i--) {
      if (moodScore >= moodCategories[i].threshold) {
        return moodCategories[i];
      }
    }
    // Fallback to the lowest category
    return moodCategories.first;
  }

  /// Gets the icon for a mood score
  static IconData getMoodIcon(double moodScore) {
    return getMoodCategory(moodScore).icon;
  }

  /// Gets the emoji for a mood score
  static String getMoodEmoji(double moodScore) {
    return getMoodCategory(moodScore).emoji;
  }

  /// Gets the color for a mood score with the given color scheme
  static Color getMoodColor(double moodScore, ColorScheme colorScheme) {
    return getMoodCategory(moodScore).colorFn(colorScheme);
  }

  /// Gets the text label for a mood score
  static String getMoodLabel(double moodScore) {
    return getMoodCategory(moodScore).label;
  }

  /// Helper method to convert named mood string to mood score
  static double getMoodScoreFromName(String moodName) {
    switch (moodName.toLowerCase()) {
      case 'very happy':
        return 9.0;
      case 'happy':
        return 7.0;
      case 'neutral':
        return 5.0;
      case 'sad':
        return 3.0;
      case 'very sad':
        return 1.0;
      default:
        return 5.0;
    }
  }

  /// Helper method to convert mood score to named mood string
  static String getMoodNameFromScore(double score) {
    if (score >= 8.0) return 'Very Happy';
    if (score >= 6.0) return 'Happy';
    if (score >= 4.0) return 'Neutral';
    if (score >= 2.0) return 'Sad';
    return 'Very Sad';
  }
}
