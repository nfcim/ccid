import Flutter
import UIKit
import CryptoTokenKit

public class FlutterCcidPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_ccid", binaryMessenger: registrar.messenger())
    let instance = FlutterCcidPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)

    case "listReaders":
      let manager = TKSmartCardSlotManager.default
      result(manager?.slotNames ?? [])

    case "waitForCard":
      let arguments = call.arguments as! [String: Any?]
      let name = arguments["name"] as! String
      print(name)
      let manager = TKSmartCardSlotManager.default
      if let slot = manager?.slotNamed(name) {
        while slot.state != .validCard {
          sleep(UInt32(1))
        }
        result(true)
      } else {
        result(FlutterError(code: "INVALID_SLOT", message: "Invalid slot name", details: nil))
      }

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
