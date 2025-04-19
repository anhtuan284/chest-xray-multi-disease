import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_html/html.dart' as html;

class ImageResult {
  final File? file; // For mobile platforms
  final Uint8List? bytes; // For all platforms
  final String? name; // File name
  final String? mimeType; // Mime type

  ImageResult({
    this.file,
    this.bytes,
    this.name,
    this.mimeType,
  });

  bool get hasImage => file != null || bytes != null;
}

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<ImageResult?> pickImageFromGallery() async {
    if (kIsWeb) {
      // Web implementation
      final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
      uploadInput.click();

      await uploadInput.onChange.first;
      if (uploadInput.files!.isEmpty) return null;

      final file = uploadInput.files!.first;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);

      await reader.onLoad.first;
      return ImageResult(
        bytes: Uint8List.fromList(reader.result as List<int>),
        name: file.name,
        mimeType: file.type,
      );
    } else {
      // Mobile implementation
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (pickedFile != null) {
        final fileBytes = await pickedFile.readAsBytes();
        return ImageResult(
          file: File(pickedFile.path),
          bytes: fileBytes,
          name: pickedFile.name,
          mimeType: 'image/${pickedFile.name.split('.').last}',
        );
      }
    }
    return null;
  }

  Future<ImageResult?> pickImageFromCamera() async {
    if (kIsWeb) {
      // For web, we'll just use the file picker with a message
      // We can't reliably access the camera on all browsers
      return pickImageFromGallery();
    } else {
      // Mobile implementation
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );

      if (pickedFile != null) {
        final fileBytes = await pickedFile.readAsBytes();
        return ImageResult(
          file: File(pickedFile.path),
          bytes: fileBytes,
          name: pickedFile.name,
          mimeType: 'image/${pickedFile.name.split('.').last}',
        );
      }
    }
    return null;
  }
}
