import Cocoa
import FlutterMacOS
import CryptoTokenKit

extension String {
    var hexadecimal: Data? {
        var data = Data(capacity: count / 2)

        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }

        guard data.count > 0 else { return nil }

        return data
    }
}

extension Data {
    var hexadecimal: String {
        return map { String(format: "%02x", $0) }.joined()
    }
}

public class FlutterCcidPlugin: NSObject, FlutterPlugin {
    var cards: [String: TKSmartCard] = [:]
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_ccid", binaryMessenger: registrar.messenger)
        let instance = FlutterCcidPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "listReaders":
            let manager = TKSmartCardSlotManager.default
            result(manager?.slotNames ?? [])
            
        case "connect":
            let reader = call.arguments as! String
            let manager = TKSmartCardSlotManager.default
            if let slot = manager?.slotNamed(reader) {
                if let card = slot.makeSmartCard() {
                    cards[reader] = card
                    result(nil)
                } else {
                    result(FlutterError(code: "NO_CARD", message: "Failed to find a card", details: nil))
                }
            } else {
                result(FlutterError(code: "INVALID_READER", message: "Invalid reader name", details: nil))
            }
            
        case "transceive":
            let args = call.arguments as! [String: Any?]
            let reader = args["reader"] as! String
            let capdu = args["capdu"] as! String
            let capduData = capdu.hexadecimal!
            let card = cards[reader]
            card?.beginSession { (success, error) in
                if !success {
                    result(FlutterError(code: "BEGIN_SESSION_ERROR", message: error?.localizedDescription, details: nil))
                }
                card?.transmit(capduData) { (rapdu, error) in
                    if let rapdu = rapdu {
                        result(rapdu.hexadecimal)
                    } else {
                        result(FlutterError(code: "TRANSMIT_ERROR", message: error?.localizedDescription, details: nil))
                    }
                    card?.endSession()
                }
            }
            
        case "disconnect":
            let reader = call.arguments as! String
            cards.removeValue(forKey: reader)
            result(nil)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
