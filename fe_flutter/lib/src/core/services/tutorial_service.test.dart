import 'package:logging/logging.dart';

import '../utils/app_logger.dart';
import 'tutorial_service.dart';

class TestTutorialService implements TutorialService {
  final Logger _logger = AppLogger.getLogger('TestTutorialService');

  @override
  Future<bool> isFirstTimeUser() async {
    _logger.fine('Test mode: Always returning true for isFirstTimeUser');
    return true; // Always return true to show tutorial
  }

  @override
  Future<void> markTutorialAsCompleted() async {
    _logger.info('Test mode: Marking tutorial as completed (no effect)');
  }

  @override
  Future<void> markTutorialAsSkipped() async {
    _logger.info('Test mode: Marking tutorial as skipped (no effect)');
  }
}
