//
//  EventQueueAssemblyTests.swift
//  PaltaLibAnalytics
//
//  Created by Vyacheslav Beltyukov on 18/05/2022.
//

import Foundation
import XCTest
import PaltaCore
@testable import PaltaLibAnalytics

final class EventQueueAssemblyTests: XCTestCase {
    var assembly: EventQueueAssembly!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        assembly = try EventQueueAssembly(
            coreAssembly: CoreAssembly(),
            analyticsCoreAssembly: AnalyticsCoreAssembly(coreAssembly: CoreAssembly())
        )
    }
    
    func testApplyTarget() {
        let target = ConfigTarget(
            name: .paltabrain,
            settings: ConfigSettings(
                eventUploadThreshold: 98,
                eventUploadMaxBatchSize: 234,
                eventMaxCount: 12,
                eventUploadPeriodSeconds: 15,
                minTimeBetweenSessionsMillis: 87,
                trackingSessionEvents: true,
                realtimeEventTypes: ["real-time"],
                excludedEventTypes: ["excluded-event"],
                sendMechanism: .paltaBrain
            )
        )
        
        assembly.apply(target, host: URL(string: "http://example.com"))
        
        let configApplied = expectation(description: "Config applied")
        assembly.eventQueueCore.addBarrier(configApplied.fulfill)
        wait(for: [configApplied], timeout: 0.1)
        
        XCTAssertEqual(assembly.eventQueueCore.config?.uploadThreshold, 98)
        XCTAssertEqual(assembly.eventQueueCore.config?.maxBatchSize, 234)
        XCTAssertEqual(assembly.eventQueueCore.config?.maxEvents, 12)
        XCTAssertEqual(assembly.eventQueueCore.config?.uploadInterval, 15)
        XCTAssertEqual(assembly.sessionManager.maxSessionAge, 87)
        XCTAssertEqual(assembly.eventQueue.trackingSessionEvents, true)
        XCTAssertEqual(assembly.eventQueue.excludedEvents, ["excluded-event"])
        XCTAssertEqual(assembly.eventQueue.liveEventTypes, ["real-time"])
        
        XCTAssertEqual(assembly.batchSender.baseURL, URL(string: "http://example.com"))
    }
}
