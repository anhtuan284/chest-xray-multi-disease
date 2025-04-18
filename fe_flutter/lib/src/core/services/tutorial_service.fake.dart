import 'package:logging/logging.dart';
import '../utils/app_logger.dart';
import 'tutorial_service.dart';

class FakeTutorialService implements TutorialService {
  final Logger _logger = AppLogger.getLogger('FakeTutorialService');
  bool _isFirstTime = true;
  bool _isCompleted = false;
  bool _isSkipped = false;

  @override
  Future<bool> isFirstTimeUser() async {
    _logger.fine('Checking if user is first time: $_isFirstTime');
    return _isFirstTime;
  }

  @override
  Future<void> markTutorialAsCompleted() async {
    _logger.info('Marking tutorial as completed');
    _isFirstTime = false;
    _isCompleted = true;
    _logger.fine(
        'Tutorial state: firstTime=$_isFirstTime, completed=$_isCompleted, skipped=$_isSkipped');
  }

  @override
  Future<void> markTutorialAsSkipped() async {
    _logger.info('Marking tutorial as skipped');
    _isFirstTime = false;
    _isSkipped = true;
    _logger.fine(
        'Tutorial state: firstTime=$_isFirstTime, completed=$_isCompleted, skipped=$_isSkipped');
  }
}
