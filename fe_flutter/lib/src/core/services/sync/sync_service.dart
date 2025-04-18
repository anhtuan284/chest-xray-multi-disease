import 'package:synchronized/synchronized.dart';

import '../../../core/utils/app_logger.dart';

abstract class SyncTask {
  String get id;
  Future<void> execute();
}

class SyncService {
  final _log = AppLogger.getLogger('SyncService');
  final Map<String, bool> _syncingTasks = {};

  // A lock to prevent concurrent access to the internal _syncingTasks map
  final _syncLock = Lock();

  // Attempt to acquire a lock for a given task ID
  // Returns true if the lock was acquired, false if the task is already syncing
  // This is used to prevent multiple sync tasks from running concurrently
  // and to ensure that the same task is not started multiple times
  Future<bool> _acquireLock(String taskId) async {
    return _syncLock.synchronized(() {
      if (_syncingTasks[taskId] == true) {
        return false;
      }
      _syncingTasks[taskId] = true;
      return true;
    });
  }

  Future<void> sync(SyncTask task) async {
    if (!await _acquireLock(task.id)) {
      _log.info('Task ${task.id} is already syncing, skipping.');
      return;
    }

    try {
      _log.info('Starting sync task: ${task.id}');
      await task.execute();
      _log.info('Sync task completed: ${task.id}');
    } catch (e, stackTrace) {
      _log.severe('Error in sync task ${task.id}', e, stackTrace);
      rethrow;
    } finally {
      _syncingTasks[task.id] = false;
    }
  }
}
