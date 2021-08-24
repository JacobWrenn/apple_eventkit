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
    let formatter = DateFormatter()
    
    func encodeColor(color: NSColor) -> String {
        let ciColor = CIColor(color: color)!
        return "\(ciColor.red):\(ciColor.green):\(ciColor.blue)"
    }
    
    func generateRule(interval: String, end: String) -> EKRecurrenceRule {
        let date = formatter.date(from: end)!
        return EKRecurrenceRule(recurrenceWith: .weekly, interval: Int(interval)!, end: EKRecurrenceEnd(end: date))
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getAccess" {
            store.requestAccess(to: .event) { access, error in
                if access {
                    result(true)
                } else {
                    result(false)
                }
            }
        } else if call.method == "getCalendars" {
            var calendars: [[String:Any]] = []
            for calendar in store.calendars(for: .event) {
                calendars.append([
                    "title": calendar.title,
                    "id": calendar.calendarIdentifier,
                    "editable": calendar.allowsContentModifications,
                    "color": encodeColor(color: calendar.color),
                    "account": calendar.source.title,
                ])
            }
            result(calendars)
        } else if call.method == "createEvent" {
            guard let args = call.arguments as? [String : String] else {return result(false)}
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let event = EKEvent(eventStore: store)
            event.title = args["title"]
            event.startDate = formatter.date(from: args["start"]!)
            event.endDate = formatter.date(from: args["end"]!)
            event.calendar = store.calendar(withIdentifier: args["calendar"]!)
            event.recurrenceRules = [generateRule(interval: args["interval"]!, end: args["recurrenceEnd"]!)]
            event.location = args["location"]
            do {
                try store.save(event, span: .futureEvents, commit: true)
                result(true)
            } catch {
                result(false)
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}
