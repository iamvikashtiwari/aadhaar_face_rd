import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {

  private var facerdChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller = window?.rootViewController as! FlutterViewController

    facerdChannel = FlutterMethodChannel(
      name: "facerd_channel",
      binaryMessenger: controller.binaryMessenger
    )

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // 🔁 FaceRD callback handler
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {

    print("FaceRD CALLBACK URL => \(url.absoluteString)")

    var response: String?

    if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
       let items = components.queryItems {

      let keys = ["response", "data", "result", "pidData"]

      for key in keys {
        if let value = items.first(where: { $0.name == key })?.value {
          response = value.removingPercentEncoding
          break
        }
      }

      if response == nil, let first = items.first?.value {
        response = first.removingPercentEncoding
      }
    }

    response = response ?? url.absoluteString.removingPercentEncoding

    facerdChannel?.invokeMethod(
      "facerdResponse",
      arguments: response ?? ""
    )

    return true
  }
}
