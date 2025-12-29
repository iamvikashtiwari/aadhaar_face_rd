library aadhaar_face_rd;

import 'dart:async';
import 'package:flutter/services.dart';

class AadhaarFaceRd {
  static const MethodChannel _channel = MethodChannel('facerd_channel');

  final StreamController<String?> _controller =
      StreamController<String?>.broadcast();

  /// Stream of FaceRD responses (PID XML or error)
  Stream<String?> get onResponse => _controller.stream;

  AadhaarFaceRd() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == "facerdResponse") {
        _controller.add(call.arguments as String?);
      }
    });
  }

  /// Check if Aadhaar FaceRD app is installed
  Future<bool> isFaceRDInstalled() async {
    final bool installed = await _channel.invokeMethod("isFaceRDInstalled");
    return installed;
  }

  /// Launch FaceRD app
  Future<void> launchFaceRd({
    required String pidOptionsXml,
    String iosScheme = "face_rddemo",
  }) async {
    await _channel.invokeMethod("launchFaceRD", {
      "xml": pidOptionsXml,
    });
  }

  void dispose() {
    _controller.close();
  }
}
