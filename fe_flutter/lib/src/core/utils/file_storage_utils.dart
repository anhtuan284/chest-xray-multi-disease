import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:fe_flutter/src/core/utils/app_logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

final _logger = AppLogger.getLogger('FileStorageUtils');

/// Saves a file to the application documents directory and returns the path.
///
/// Parameters:
/// - [bytes]: The file data as Uint8List
/// - [extension]: File extension (e.g., 'png', 'mp3', etc.)
/// - [prefix]: Optional prefix for the filename (default: 'file')
///
/// Returns the full path to the saved file.
Future<String> saveFileToAppDir(
  Uint8List bytes, {
  required String extension,
  String prefix = 'file',
}) async {
  _logger.info(
      'Saving ${bytes.length} bytes as $prefix file with .$extension extension');
  try {
    // Get the application documents directory
    final appDocDir = await getApplicationDocumentsDirectory();
    _logger.fine('App documents directory: ${appDocDir.path}');

    // Generate a unique filename with timestamp and random string
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(10000).toString().padLeft(4, '0');
    final fileName = '${prefix}_${timestamp}_$random.$extension';

    // Create the full file path
    final filePath = path.join(appDocDir.path, fileName);
    _logger.fine('Generated filepath: $filePath');

    // Write the bytes to the file
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    _logger.info('Successfully saved file to: $filePath');
    return filePath;
  } catch (e, stackTrace) {
    _logger.severe('Error saving file', e, stackTrace);
    rethrow;
  }
}

/// Saves a file to the application documents directory from an existing file and returns the path.
///
/// Parameters:
/// - [sourceFile]: The source File object
/// - [prefix]: Optional prefix for the filename (default: 'file')
///
/// Returns the full path to the saved file.
Future<String> copyFileToAppDir(
  File sourceFile, {
  String prefix = 'file',
}) async {
  _logger.info('Copying file from: ${sourceFile.path}');
  try {
    // Get file extension from the source file
    final extension = path.extension(sourceFile.path).replaceFirst('.', '');

    // Get the file bytes
    final bytes = await sourceFile.readAsBytes();
    _logger.fine('Read ${bytes.length} bytes from source file');

    // Save the file using the other function
    return saveFileToAppDir(bytes, extension: extension, prefix: prefix);
  } catch (e, stackTrace) {
    _logger.severe('Error copying file', e, stackTrace);
    rethrow;
  }
}

/// Deletes a file from the given path.
///
/// Returns true if the file was successfully deleted, false otherwise.
Future<bool> deleteFile(String filePath) async {
  _logger.info('Attempting to delete file: $filePath');
  try {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
      _logger.info('Successfully deleted file: $filePath');
      return true;
    }
    _logger.warning('File not found for deletion: $filePath');
    return false;
  } catch (e, stackTrace) {
    _logger.severe('Error deleting file: $filePath', e, stackTrace);
    return false;
  }
}
