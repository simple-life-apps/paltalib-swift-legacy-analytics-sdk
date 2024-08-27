//
//  IdentityLogger.swift
//  PaltaLibAnalytics
//
//  Created by Vyacheslav Beltyukov on 13.04.2022.
//

import Foundation
import Amplitude

final class IdentityLogger {
    private let identifyEventType = "$identify"

    private let eventQueue: EventQueue

    init(eventQueue: EventQueue) {
        self.eventQueue = eventQueue
    }

    func identify(
        _ identify: AMPIdentify
    ) {
        guard let userProperties = identify.userPropertyOperations as? [String: Any] else {
            assertionFailure()
            return
        }

        eventQueue.logEvent(
            eventType: identifyEventType,
            eventProperties: [:],
            apiProperties: [:],
            groups: [:],
            userProperties: userProperties,
            groupProperties: [:],
            timestamp: nil
        )
    }

    func setUserProperties(_ userProperties: [String: Any]) {
        let identifyObject = AMPIdentify()

        userProperties.forEach {
            identifyObject.set($0.key, value: $0.value as? NSObject)
        }

        identify(identifyObject)
    }
}
