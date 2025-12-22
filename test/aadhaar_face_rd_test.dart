// import 'package:flutter_test/flutter_test.dart';
// import 'package:aadhaar_face_rd/aadhaar_face_rd.dart';
// import 'package:aadhaar_face_rd/aadhaar_face_rd_platform_interface.dart';
// import 'package:aadhaar_face_rd/aadhaar_face_rd_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockAadhaarFaceRdPlatform
//     with MockPlatformInterfaceMixin
//     implements AadhaarFaceRdPlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final AadhaarFaceRdPlatform initialPlatform = AadhaarFaceRdPlatform.instance;
//
//   test('$MethodChannelAadhaarFaceRd is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelAadhaarFaceRd>());
//   });
//
//   test('getPlatformVersion', () async {
//     AadhaarFaceRd aadhaarFaceRdPlugin = AadhaarFaceRd();
//     MockAadhaarFaceRdPlatform fakePlatform = MockAadhaarFaceRdPlatform();
//     AadhaarFaceRdPlatform.instance = fakePlatform;
//
//     expect(await aadhaarFaceRdPlugin.getPlatformVersion(), '42');
//   });
// }
