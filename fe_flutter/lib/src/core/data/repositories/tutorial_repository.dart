import '../../services/services.dart';

class TutorialRepository {
  final TutorialService _tutorialService;

  TutorialRepository(this._tutorialService);

  Future<bool> isFirstTimeUser() async {
    return await _tutorialService.isFirstTimeUser();
  }

  Future<void> markTutorialAsCompleted() async {
    await _tutorialService.markTutorialAsCompleted();
  }

  Future<void> markTutorialAsSkipped() async {
    await _tutorialService.markTutorialAsSkipped();
  }
}
