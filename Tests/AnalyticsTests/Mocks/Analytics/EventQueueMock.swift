//
//  EventQueueMock.swift
//  PaltaLibTests
//
//  Created by Vyacheslav Beltyukov on 13.04.2022.
//

import Foundation
@testable import PaltaLibAnalytics

final class EventQueueMock: EventQueue {
    var eventType: String?
    var eventProperties: [String : Any]?
    var apiProperties: [String: Any]?
    var groups: [String : Any]?
    var userProperties: [String : Any]?
    var groupProperties: [String : Any]?
    var timestamp: Int?

    func logEvent(
        eventType: String,
        eventProperties: [String: Any],
        apiProperties: [String: Any],
        groups: [String: Any],
        userProperties: [String : Any],
        groupProperties: [String: Any],
        timestamp: Int?
    ) {
        self.eventType = eventType
        self.eventProperties = eventProperties
        self.apiProperties = apiProperties
        self.groups = groups
        self.userProperties = userProperties
        self.groupProperties = groupProperties
        self.timestamp = timestamp
    }


}
