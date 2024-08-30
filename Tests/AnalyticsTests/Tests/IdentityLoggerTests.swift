//
//  IdentityLoggerTests.swift
//  PaltaLibTests
//
//  Created by Vyacheslav Beltyukov on 13.04.2022.
//

import XCTest
@testable import PaltaLibAnalytics

final class IdentityLoggerTests: XCTestCase {
    var eventQueueMock: EventQueueMock!
    var logger: IdentityLogger!

    override func setUpWithError() throws {
        try super.setUpWithError()

        eventQueueMock = EventQueueMock()
        logger = IdentityLogger(eventQueue: eventQueueMock)
    }

    func testSetUserProperties() {
        logger.setUserProperties(
            [
                "property1": 1,
                "property2": 2
            ]
        )

        XCTAssertEqual(eventQueueMock.eventType, "$identify")
        XCTAssertEqual(eventQueueMock.eventProperties?.isEmpty, true)
        XCTAssertEqual(eventQueueMock.groups?.isEmpty, true)
        XCTAssertEqual(
            eventQueueMock.userProperties as? [String: [String: Int]],
            ["$set": ["property1": 1, "property2": 2]]
        )
        XCTAssertEqual(eventQueueMock.apiProperties?.isEmpty, true)
        XCTAssertEqual(eventQueueMock.groupProperties?.isEmpty, true)
        XCTAssertNil(eventQueueMock.timestamp)
    }
}
