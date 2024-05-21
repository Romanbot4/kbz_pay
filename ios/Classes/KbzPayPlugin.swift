import Flutter
import UIKit
import KBZPayAPPPay

public class KBZPayPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "kbz_pay", binaryMessenger: registrar.messenger())
        let instance = KBZPayPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "startPay":
            let argsError = FlutterError(
                code: "ArgumentError",
                message: "Failed to parse call.arguments from Flutter.",
                details: nil
            )
            
            guard let args = call.arguments as? [String: Any] else {
                result(argsError)
                return
            }
            
            guard let orderInfo = args["orderInfo"] as? String,
                  let signType = args["signType"] as? String,
                  let sign = args["sign"] as? String,
                  let appScheme = args["appScheme"] as? String else {
                result(argsError)
                return
            }
            
            PaymentViewController().startPay(
                withOrderInfo: orderInfo,
                signType: signType,
                sign: sign,
                appScheme: appScheme
            )
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
