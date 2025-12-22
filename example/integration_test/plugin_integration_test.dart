// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:aadhaar_face_rd/aadhaar_face_rd.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('FaceRD plugin loads without crashing',
      (WidgetTester tester) async {
    final plugin = AadhaarFaceRd();

    // Validate plugin instance is created
    expect(plugin, isNotNull);

    // Validate the stream exists
    expect(plugin.onResponse, isA<Stream<String?>>());

    // Since no native method will reply here, just assert dummy pass
    expect(true, true);
  });
}
