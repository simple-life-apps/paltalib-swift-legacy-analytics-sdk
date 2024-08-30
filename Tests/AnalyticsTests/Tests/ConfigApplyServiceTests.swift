//
//  ConfigApplyServiceTests.swift
//  PaltaLibAnalytics
//
//  Created by Vyacheslav Beltyukov on 18/05/2022.
//

import Foundation
import XCTest
@testable import PaltaLibAnalytics

final class ConfigApplyServiceTests: XCTestCase {
    private let assemblyProvider = EventQueueAssemblyProviderMock()
    
    private var defaultPaltaInstance: EventQueueAssembly?
    
    private var paltaQueueAssemblies: [EventQueueAssembly] = []

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        defaultPaltaInstance = nil

        paltaQueueAssemblies = []
    }

    func testOnlyPaltaBrain() throws {
        let config = RemoteConfig(targets: [.defaultPaltaBrain])
        
        let palta = try assemblyProvider.newEventQueueAssembly()
        
        let coreConfigApplied = expectation(description: "Core config applied")
        
        defaultPaltaInstance = palta
        
        let service = ConfigApplyService(
            remoteConfig: config,
            apiKey: "palta-key",
            eventQueueAssemblyProvider: assemblyProvider,
            host: nil
        )
        
        service.apply(
            defaultPaltaAssembly: &defaultPaltaInstance,
            paltaAssemblies: &paltaQueueAssemblies
        )
        
        palta.eventQueueCore.addBarrier(coreConfigApplied.fulfill)
        wait(for: [coreConfigApplied], timeout: 0.1)
        
        XCTAssertNil(defaultPaltaInstance)
        
        XCTAssertEqual(paltaQueueAssemblies.count, 1)

        XCTAssertNotNil(paltaQueueAssemblies.first?.eventQueueCore.config)
        
        XCTAssert(paltaQueueAssemblies.first === palta)
        
        XCTAssertEqual(paltaQueueAssemblies.first?.batchSender.apiToken, "palta-key")
    }

    func testTwoPaltaBrain() throws {
        let config = RemoteConfig(targets: [
            ConfigTarget(
                name: .paltabrain,
                settings: .init(
                    eventUploadThreshold: 1,
                    eventUploadMaxBatchSize: 1,
                    eventMaxCount: 1,
                    eventUploadPeriodSeconds: 1,
                    minTimeBetweenSessionsMillis: 1,
                    trackingSessionEvents: true,
                    realtimeEventTypes: [],
                    excludedEventTypes: [],
                    sendMechanism: .paltaBrain
                )
            ),
            .defaultPaltaBrain
        ])
        
        let palta = try assemblyProvider.newEventQueueAssembly()
        
        let coreConfigApplied = expectation(description: "Core config applied")
        
        defaultPaltaInstance = palta
        
        let service = ConfigApplyService(
            remoteConfig: config,
            apiKey: "palta-key",
            eventQueueAssemblyProvider: assemblyProvider,
            host: URL(string: "http://example.com")
        )
        
        service.apply(
            defaultPaltaAssembly: &defaultPaltaInstance,
            paltaAssemblies: &paltaQueueAssemblies
        )
        
        palta.eventQueueCore.addBarrier(coreConfigApplied.fulfill)
        wait(for: [coreConfigApplied], timeout: 0.1)
        
        XCTAssertNil(defaultPaltaInstance)
        
        XCTAssertEqual(paltaQueueAssemblies.count, 2)

        XCTAssert(paltaQueueAssemblies.first === palta)

        XCTAssertEqual(paltaQueueAssemblies[0].batchSender.apiToken, "palta-key")
        XCTAssertEqual(paltaQueueAssemblies.last?.batchSender.apiToken, "palta-key")
    }
}
