import Cocoa
import FlutterMacOS
import EventKit

public class AppleEventkitPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "apple_eventkit", binaryMessenger: registrar.messenger)
        let instance = AppleEventkitPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    let store = EKEventStore()
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getAccess" {
            store.requestAccess(to: .event) { access, error in
                if access {
                    result(true)
                } else {
                    result(false)
                }
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}
