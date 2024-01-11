import Amplitude

extension PaltaAnalytics {
    public func logEvent(_ eventType: String,
                         withEventProperties eventProperties: [AnyHashable : Any]? = nil,
                         withGroups groups: [AnyHashable : Any]? = nil,
                         withTimestamp timestamp: NSNumber? = nil) {

        amplitudeInstances.forEach {
            $0.pb_logEvent(
                eventType: eventType,
                eventProperties: eventProperties,
                groups: groups,
                timestamp: timestamp
            )
        }

        paltaQueues.forEach {
            $0.logEvent(
                eventType: eventType,
                eventProperties: eventProperties as? [String: Any] ?? [:],
                groups: groups as? [String: Any] ?? [:],
                timestamp: timestamp?.intValue
            )
        }
    }
    
    public func logEvent(eventType: String) {
        amplitudeInstances.forEach {
            $0.pb_logEvent(eventType: eventType)
        }

        paltaQueues.forEach {
            $0.logEvent(eventType: eventType, eventProperties: [:], groups: [:], timestamp: nil)
        }
    }
    
    public func logEvent(eventType: String, withEventProperties eventProperties: Dictionary<String, Any>) {
        amplitudeInstances.forEach {
            $0.pb_logEvent(eventType: eventType, eventProperties: eventProperties)
        }

        paltaQueues.forEach {
            $0.logEvent(eventType: eventType, eventProperties: eventProperties, groups: [:])
        }
    }
    
    public func logEvent(eventType: String,
                         withEventProperties eventProperties: Dictionary<String, Any>,
                         withGroups groups: Dictionary<String, Any>) {
        amplitudeInstances.forEach {
            $0.pb_logEvent(
                eventType: eventType,
                eventProperties: eventProperties,
                groups: groups
            )
        }

        paltaQueues.forEach {
            $0.logEvent(
                eventType: eventType,
                eventProperties: eventProperties,
                groups: groups,
                timestamp: nil
            )
        }
    }
    
    public func logEvent(
        eventType: String,
        withEventProperties eventProperties: Dictionary<String, Any>,
        withGroups groups: Dictionary<String, Any>,
        withLongLongTimestamp longLongTimestamp: Int64
    ) {
        amplitudeInstances.forEach {
            $0.pb_logEvent(
                eventType: eventType,
                eventProperties: eventProperties,
                groups: groups,
                timestamp: longLongTimestamp as NSNumber
            )
        }

        paltaQueues.forEach {
            $0.logEvent(
                eventType: eventType,
                eventProperties: eventProperties,
                groups: groups,
                timestamp: Int(longLongTimestamp)
            )
        }
    }
    
    
    public func logEvent(
        eventType: String,
        withEventProperties eventProperties: Dictionary<String, Any>,
        withGroups groups: Dictionary<String, Any>,
        withTimestamp timestamp: NSNumber
    ) {
        amplitudeInstances.forEach {
            $0.pb_logEvent(
                eventType: eventType,
                eventProperties: eventProperties,
                groups: groups,
                timestamp: timestamp
            )
        }

        paltaQueues.forEach {
            $0.logEvent(
                eventType: eventType,
                eventProperties: eventProperties,
                groups: groups,
                timestamp: timestamp.intValue
            )
        }
    }

}
