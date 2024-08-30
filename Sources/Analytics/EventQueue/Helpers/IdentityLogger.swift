//
//  IdentityLogger.swift
//  PaltaLibAnalytics
//
//  Created by Vyacheslav Beltyukov on 13.04.2022.
//

import Foundation

final class IdentityLogger {
    private let identifyEventType = "$identify"

    private let eventQueue: EventQueue

    init(eventQueue: EventQueue) {
        self.eventQueue = eventQueue
    }

    func setUserProperties(_ userProperties: [String: Any]) {
        eventQueue.logEvent(
            eventType: identifyEventType,
            eventProperties: [:],
            apiProperties: [:],
            groups: [:],
            userProperties: ["$set": userProperties],
            groupProperties: [:],
            timestamp: nil
        )
    }
}
