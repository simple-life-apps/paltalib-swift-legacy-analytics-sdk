//
//  IdentityLoggerTests.swift
//  PaltaLibTests
//
//  Created by Vyacheslav Beltyukov on 13.04.2022.
//

import Amplitude
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

    func testInSessionIdentify() {
        let identify = AMPIdentify().add("prop", value: "value" as NSString)!

        logger.identify(identify)

        XCTAssertEqual(eventQueueMock.eventType, "$identify")
        XCTAssertEqual(eventQueueMock.eventProperties?.isEmpty, true)
        XCTAssertEqual(eventQueueMock.groups?.isEmpty, true)
        XCTAssertEqual(eventQueueMock.groupProperties?.isEmpty, true)
        XCTAssertEqual(eventQueueMock.apiProperties?.isEmpty, true)
        XCTAssertEqual(eventQueueMock.userProperties as? [String: [String: String]], ["$add": ["prop": "value"]])
        XCTAssertNil(eventQueueMock.timestamp)
    }

    func testOutOfSessionIdentify() {
        let identify = AMPIdentify().add("prop", value: "value" as NSString)!

        logger.identify(identify)

        XCTAssertEqual(eventQueueMock.eventType, "$identify")
        XCTAssertEqual(eventQueueMock.eventProperties?.isEmpty, true)
        XCTAssertEqual(eventQueueMock.groups?.isEmpty, true)
        XCTAssertEqual(eventQueueMock.groupProperties?.isEmpty, true)
        XCTAssertEqual(eventQueueMock.apiProperties?.isEmpty, true)
        XCTAssertEqual(eventQueueMock.userProperties as? [String: [String: String]], ["$add": ["prop": "value"]])
        XCTAssertNil(eventQueueMock.timestamp)
    }

    func testInSessionGroupIdentify() {
        let identify = AMPIdentify().add("prop", value: "value" as NSString)!

        logger.groupIdentify(
            groupType: "groupType",
            groupName: "groupName" as NSString,
            groupIdentify: identify
        )

        XCTAssertEqual(eventQueueMock.eventType, "$groupidentify")
        XCTAssertEqual(eventQueueMock.eventProperties?.isEmpty, true)
        XCTAssertEqual(eventQueueMock.groups as? [String: String], ["groupType": "groupName"])
        XCTAssertEqual(eventQueueMock.userProperties?.isEmpty, true)
        XCTAssertEqual(eventQueueMock.apiProperties?.isEmpty, true)
        XCTAssertEqual(eventQueueMock.groupProperties as? [String: [String: String]], ["$add": ["prop": "value"]])
        XCTAssertNil(eventQueueMock.timestamp)
    }

    func testOutOfSessionGroupIdentify() {
        let identify = AMPIdentify().add("prop", value: "value" as NSString)!

        logger.groupIdentify(
            groupType: "groupType",
            groupName: "groupName" as NSString,
            groupIdentify: identify
        )

        XCTAssertEqual(eventQueueMock.eventType, "$groupidentify")
        XCTAssertEqual(eventQueueMock.eventProperties?.isEmpty, true)
        XCTAssertEqual(eventQueueMock.groups as? [String: String], ["groupType": "groupName"])
        XCTAssertEqual(eventQueueMock.userProperties?.isEmpty, true)
        XCTAssertEqual(eventQueueMock.apiProperties?.isEmpty, true)
        XCTAssertEqual(eventQueueMock.groupProperties as? [String: [String: String]], ["$add": ["prop": "value"]])
        XCTAssertNil(eventQueueMock.timestamp)
    }

    func testClearProperties() {
        logger.clearUserProperties()

        XCTAssertEqual(eventQueueMock.eventType, "$identify")
        XCTAssertEqual(eventQueueMock.eventProperties?.isEmpty, true)
        XCTAssertEqual(eventQueueMock.groups?.isEmpty, true)
        XCTAssertEqual(eventQueueMock.userProperties as? [String: String], ["$clearAll": "-"])
        XCTAssertEqual(eventQueueMock.apiProperties?.isEmpty, true)
        XCTAssertEqual(eventQueueMock.groupProperties?.isEmpty, true)
        XCTAssertNil(eventQueueMock.timestamp)
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

    func testSetGroup() {
        logger.setGroup(groupType: "type", groupName: "name" as NSString)

        XCTAssertEqual(eventQueueMock.eventType, "$identify")
        XCTAssertEqual(eventQueueMock.eventProperties?.isEmpty, true)
        XCTAssertEqual(eventQueueMock.groups as? [String: String], ["type": "name"])
        XCTAssertEqual(
            eventQueueMock.userProperties as? [String: [String: String]],
            ["$set": ["type": "name"]]
        )
        XCTAssertEqual(eventQueueMock.apiProperties?.isEmpty, true)
        XCTAssertEqual(eventQueueMock.groupProperties?.isEmpty, true)
        XCTAssertNil(eventQueueMock.timestamp)
    }
}
