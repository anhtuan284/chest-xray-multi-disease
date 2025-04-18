import 'package:shared_preferences/shared_preferences.dart';

import 'tutorial_service.dart';

class TutorialServiceSharedPrefs implements TutorialService {
  // Keys for SharedPreferences
  static const String firstTimeUserKey = 'fe_flutter_first_time_user';
  static const String tutorialCompletedKey = 'fe_flutter_tutorial_completed';
  static const String tutorialSkippedKey = 'fe_flutter_tutorial_skipped';

  @override
  Future<bool> isFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(firstTimeUserKey) ?? true;
  }

  @override
  Future<void> markTutorialAsCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(tutorialCompletedKey, true);
    await prefs.setBool(firstTimeUserKey, false);
  }

  @override
  Future<void> markTutorialAsSkipped() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(tutorialSkippedKey, true);
    await prefs.setBool(firstTimeUserKey, false);
  }
}
