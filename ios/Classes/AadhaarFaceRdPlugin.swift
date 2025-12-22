import Flutter
import UIKit

public class AadhaarFaceRdPlugin: NSObject, FlutterPlugin {

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "facerd_channel",
      binaryMessenger: registrar.messenger()
    )
    let instance = AadhaarFaceRdPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

    switch call.method {

    // ✅ Check if FaceRD app is installed
    case "isFaceRDInstalled":
      let url = URL(string: "FaceRDLib://")!
      result(UIApplication.shared.canOpenURL(url))

    // ✅ Launch FaceRD (HEADLESS MODE)
    case "launchFaceRD":
      guard let args = call.arguments as? [String: Any],
            let pidXml = args["xml"] as? String else {
        result(FlutterError(
          code: "INVALID_ARGS",
          message: "PidOptions XML missing",
          details: nil
        ))
        return
      }

      // Encode PID XML
      guard let encodedXml = pidXml
        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        result(FlutterError(
          code: "ENCODING_FAILED",
          message: "Failed to encode PID XML",
          details: nil
        ))
        return
      }

      // UIDAI-defined CAPTURE URL Scheme
      let urlString =
        "FaceRDLib://in.gov.uidai.rdservice.face.CAPTURE?request=\(encodedXml)"

      guard let url = URL(string: urlString) else {
        result(FlutterError(
          code: "INVALID_URL",
          message: "Invalid FaceRD URL",
          details: nil
        ))
        return
      }

      if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:]) { success in
          result(success)
        }
      } else {
        result(FlutterError(
          code: "FACE_RD_NOT_INSTALLED",
          message: "Aadhaar FaceRD app not installed",
          details: nil
        ))
      }

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
