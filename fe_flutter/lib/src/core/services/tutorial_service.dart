abstract class TutorialService {
  Future<bool> isFirstTimeUser();
  Future<void> markTutorialAsCompleted();
  Future<void> markTutorialAsSkipped();
}
