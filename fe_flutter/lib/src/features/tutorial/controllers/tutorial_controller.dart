import 'package:fe_flutter/src/core/data/repositories/tutorial_repository.dart';
import 'package:fe_flutter/src/core/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tutorialControllerProvider = Provider<TutorialController>((ref) {
  final tutorialRepository = ref.watch(tutorialRepositoryProvider);
  return TutorialController(tutorialRepository);
});

class TutorialController {
  final TutorialRepository _tutorialRepository;

  TutorialController(this._tutorialRepository);

  Future<bool> isFirstTimeUser() async {
    return await _tutorialRepository.isFirstTimeUser();
  }

  Future<void> markTutorialAsCompleted() async {
    await _tutorialRepository.markTutorialAsCompleted();
  }

  Future<void> markTutorialAsSkipped() async {
    await _tutorialRepository.markTutorialAsSkipped();
  }
}
