import 'dart:async';
import 'package:aadhaar_face_rd/aadhaar_face_rd.dart';

class FaceRDService {
  final AadhaarFaceRd _plugin = AadhaarFaceRd();
  final StreamController<String?> _controller =
      StreamController<String?>.broadcast();

  FaceRDService() {
    _plugin.onResponse.listen((resp) {
      _controller.add(resp);
    });
  }

  /// Stream of FaceRD response XML / error
  Stream<String?> get onResponse => _controller.stream;

  /// Check if FaceRD app is installed
  Future<bool> isInstalled() async {
    return await _plugin.isFaceRDInstalled();
  }

  /// Launch FaceRD
  Future<void> launch(String pidOptionsXml) async {
    await _plugin.launchFaceRd(
      pidOptionsXml: pidOptionsXml,
    );
  }

  void dispose() {
    _plugin.dispose();
    _controller.close();
  }
}
