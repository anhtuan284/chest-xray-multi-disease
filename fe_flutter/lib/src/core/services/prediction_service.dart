import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';

import 'api_service_base.dart';
import 'image_picker_service.dart';

class PredictionService extends ApiServiceBase {
  PredictionService() : super.withLoggerName('PredictionService');

  final Dio _dio = Dio();

  static const String _yoloEndpoint =
      'http://atuan-ubuntu2404:8000/yolo_predict';

  // DenseNet Model API endpoint
  static const String _densenetEndpoint =
      'http://atuan-ubuntu2404:5000/densenet_predict';

  // Make prediction with YOLO model
  Future<Uint8List> predictWithYolo(ImageResult imageResult) async {
    final endpoint = _yoloEndpoint;
    logRequest('POST', endpoint,
        body: 'Image file: ${imageResult.name ?? "unnamed"}');

    try {
      final FormData formData;

      if (kIsWeb) {
        // For web, we use the bytes directly
        formData = FormData.fromMap({
          'file': MultipartFile.fromBytes(
            imageResult.bytes!,
            filename: imageResult.name ?? 'image.jpg',
            contentType: MediaType.parse(imageResult.mimeType ?? 'image/jpeg'),
          ),
        });
      } else {
        // For mobile, we can use the file path
        formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(
            imageResult.file!.path,
            contentType: MediaType.parse(imageResult.mimeType ?? 'image/jpeg'),
          ),
        });
      }

      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            'Accept': 'image/jpeg',
          },
        ),
      );

      logResponse('POST', endpoint, response.statusCode ?? 200,
          responseBody: 'Received ${response.data.length} bytes of image data');

      return response.data;
    } catch (e) {
      logError('POST', endpoint, e,
          stackTrace: e is DioException ? e.stackTrace : null);
      throw Exception('Failed to predict with YOLO: $e');
    }
  }

  // Make prediction with DenseNet model
  Future<List<Uint8List>> predictWithDenseNet(ImageResult imageResult) async {
    final endpoint = _densenetEndpoint;
    logRequest('POST', endpoint,
        body: 'Image file: ${imageResult.name ?? "unnamed"}');

    try {
      final FormData formData;

      if (kIsWeb) {
        formData = FormData.fromMap({
          'file': MultipartFile.fromBytes(
            imageResult.bytes!,
            filename: imageResult.name ?? 'image.jpg',
            contentType: MediaType.parse(imageResult.mimeType ?? 'image/jpeg'),
          ),
        });
      } else {
        formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(
            imageResult.file!.path,
            contentType: MediaType.parse(imageResult.mimeType ?? 'image/jpeg'),
          ),
        });
      }

      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(responseType: ResponseType.bytes),
      );

      logResponse('POST', endpoint, response.statusCode ?? 200,
          responseBody: 'Received ZIP data: ${response.data.length} bytes');

      // Extract files from zip response
      final zipBytes = response.data as Uint8List;
      final archive = ZipDecoder().decodeBytes(zipBytes);

      final extractedFiles = <Uint8List>[];

      for (final file in archive) {
        if (file.isFile) {
          extractedFiles.add(file.content as Uint8List);
        }
      }

      logger.info('Extracted ${extractedFiles.length} images from ZIP archive');

      if (!kIsWeb) {
        // For mobile platforms, we can also save to temp directory if needed
        final tempDir = await getTemporaryDirectory();
        for (var i = 0; i < archive.length; i++) {
          final file = archive[i];
          if (file.isFile) {
            final outputFile = File('${tempDir.path}/${file.name}');
            await outputFile.writeAsBytes(file.content as List<int>);
          }
        }
      }

      return extractedFiles;
    } catch (e) {
      logError('POST', endpoint, e,
          stackTrace: e is DioException ? e.stackTrace : null);
      throw Exception('Failed to predict with DenseNet: $e');
    }
  }
}
