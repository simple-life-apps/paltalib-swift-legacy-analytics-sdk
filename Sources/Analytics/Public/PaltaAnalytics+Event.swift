import Foundation

extension PaltaAnalytics {
    public func logEvent(_ eventType: String,
                         withEventProperties eventProperties: [AnyHashable : Any]? = nil,
                         withGroups groups: [AnyHashable : Any]? = nil,
                         withTimestamp timestamp: NSNumber? = nil) {
        paltaQueues.forEach {
            $0.logEvent(
                eventType: eventType,
                eventProperties: eventProperties as? [String: Any] ?? [:],
                groups: groups as? [String: Any] ?? [:],
                timestamp: timestamp?.intValue
            )
        }
    }
}
