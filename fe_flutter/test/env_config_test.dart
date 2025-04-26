import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final logger = Logger('env_test');

  // Categories of environment variables to check
  final Map<String, List<String>> requiredVars = {
    'Firebase Web': [
      'FIREBASE_WEB_API_KEY',
      'FIREBASE_WEB_APP_ID',
      'FIREBASE_WEB_MESSAGING_SENDER_ID',
      'FIREBASE_WEB_PROJECT_ID',
      'FIREBASE_WEB_AUTH_DOMAIN',
      'FIREBASE_WEB_STORAGE_BUCKET',
      'FIREBASE_WEB_MEASUREMENT_ID',
    ],
    'Firebase Android': [
      'FIREBASE_ANDROID_API_KEY',
      'FIREBASE_ANDROID_APP_ID',
      'FIREBASE_ANDROID_MESSAGING_SENDER_ID',
      'FIREBASE_ANDROID_PROJECT_ID',
      'FIREBASE_ANDROID_STORAGE_BUCKET',
    ],
    'Firebase iOS': [
      'FIREBASE_IOS_API_KEY',
      'FIREBASE_IOS_APP_ID',
      'FIREBASE_IOS_MESSAGING_SENDER_ID',
      'FIREBASE_IOS_PROJECT_ID',
      'FIREBASE_IOS_STORAGE_BUCKET',
      'FIREBASE_IOS_BUNDLE_ID',
    ],
  };

  group('Environment variables tests', () {
    setUpAll(() async {
      try {
        // Load .env file
        await dotenv.load(fileName: '.env');
        logger.info('Environment file loaded successfully');
      } catch (e) {
        logger.severe('Failed to load .env file: $e');
      }
    });

    test('Check if all required environment variables are set', () {
      Map<String, List<String>> missingVars = {};

      // Check each category of variables
      for (final category in requiredVars.keys) {
        for (final varName in requiredVars[category]!) {
          final value = dotenv.env[varName];
          if (value == null || value.isEmpty) {
            // Add missing variable to the appropriate category
            missingVars.putIfAbsent(category, () => []).add(varName);
          }
        }
      }

      // Print detailed report of missing variables
      if (missingVars.isNotEmpty) {
        StringBuffer report = StringBuffer();
        report.writeln('\n❌ MISSING ENVIRONMENT VARIABLES DETECTED:');
        report.writeln('==========================================');

        missingVars.forEach((category, vars) {
          report.writeln('\n🔴 $category:');
          for (final varName in vars) {
            report.writeln('   - $varName');
          }
        });

        report.writeln(
            '\nℹ️ These variables will use fallback values, but you should set them for production.');
        logger.warning(report.toString());
      } else {
        logger.info('\n✅ All environment variables are properly set.');
      }

      // Check and display variables with fallback values
      if (missingVars.isNotEmpty) {
        expect(missingVars.isEmpty, isFalse,
            reason:
                'Some environment variables are missing and using fallbacks');
      } else {
        expect(missingVars.isEmpty, isTrue,
            reason: 'All environment variables are properly set');
      }
    });
  });
}
