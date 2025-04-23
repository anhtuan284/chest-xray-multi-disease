import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

void main() {
  group('API Integration Tests', () {
    final String cnnApiUrl = 'http://localhost:8001/predict/';
    final String yoloApiUrl = 'http://localhost:8002/detect/';
    final String ragApiUrl = 'http://localhost:8003/rag/query';

    test('CNN API is accessible', () async {
      try {
        final response =
            await http.get(Uri.parse(cnnApiUrl.replaceAll('predict/', '')));
        expect(response.statusCode, equals(200));
      } catch (e) {
        fail('CNN API is not accessible: $e');
      }
    });

    test('YOLO API is accessible', () async {
      try {
        final response =
            await http.get(Uri.parse(yoloApiUrl.replaceAll('detect/', '')));
        expect(response.statusCode, equals(200));
      } catch (e) {
        fail('YOLO API is not accessible: $e');
      }
    });

    test('RAG API is accessible', () async {
      try {
        final response =
            await http.get(Uri.parse(ragApiUrl.replaceAll('rag/query', '')));
        expect(response.statusCode, equals(200));
      } catch (e) {
        fail('RAG API is not accessible: $e');
      }
    });

    test('CNN API accepts image uploads', () async {
      final testImagePath = '../testimage/00000459_053.png';

      if (!File(testImagePath).existsSync()) {
        fail('Test image not found at $testImagePath');
        return;
      }

      try {
        var request = http.MultipartRequest('POST', Uri.parse(cnnApiUrl));
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          testImagePath,
          filename: path.basename(testImagePath),
        ));

        var response = await request.send();
        expect(response.statusCode, anyOf(equals(200), equals(201)));

        var responseData = await response.stream.bytesToString();
        expect(responseData, contains('predictions'));
      } catch (e) {
        fail('Failed to upload image to CNN API: $e');
      }
    });

    test('YOLO API accepts image uploads', () async {
      final testImagePath = '../testimage/00000459_053.png';

      if (!File(testImagePath).existsSync()) {
        fail('Test image not found at $testImagePath');
        return;
      }

      try {
        var request = http.MultipartRequest('POST', Uri.parse(yoloApiUrl));
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          testImagePath,
          filename: path.basename(testImagePath),
        ));

        var response = await request.send();
        expect(response.statusCode, anyOf(equals(200), equals(201)));

        var responseData = await response.stream.bytesToString();
        expect(responseData, contains('detections'));
      } catch (e) {
        fail('Failed to upload image to YOLO API: $e');
      }
    });

    test('RAG API accepts queries', () async {
      try {
        final response = await http.post(
          Uri.parse(ragApiUrl),
          headers: {'Content-Type': 'application/json'},
          body: '{"query": "What are common findings in pleural effusion?"}',
        );

        expect(response.statusCode, equals(200));
        expect(response.body, contains('answer'));
      } catch (e) {
        fail('Failed to query RAG API: $e');
      }
    });
  });
}
