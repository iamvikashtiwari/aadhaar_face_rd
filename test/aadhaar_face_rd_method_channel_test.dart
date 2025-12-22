// test/aadhaar_face_rd_method_channel_test.dart

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // The channel name used by your plugin/native code
  const MethodChannel channel = MethodChannel('facerd_channel');

  setUp(() {
    // Intercept calls to the channel and return mocked values.
    // We handle 'launchFaceRD' here and return true to simulate successful launch.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'launchFaceRD') {
        // Optionally inspect arguments:
        // final args = methodCall.arguments as Map?;
        // final xml = args?['xml'] as String?;
        return true;
      }

      // Return null for other methods (or add handlers if you need them)
      return null;
    });
  });

  tearDown(() {
    // Remove the mock handler after each test
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('launchFaceRD method channel returns true', () async {
    // Call the method through the MethodChannel directly (this simulates the plugin Dart-side invoking native)
    final bool? result = await channel.invokeMethod<bool>('launchFaceRD', {
      'xml': '<PidOptions/>',
      'appScheme': 'face_rddemo',
    });

    expect(result, isTrue);
  });
}
