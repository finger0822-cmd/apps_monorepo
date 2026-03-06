import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    #if targetEnvironment(simulator)
    if #available(iOS 15.0, *) {
      Task { @MainActor in
        await logEntitlementsForDebug()
      }
    }
    #endif

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
