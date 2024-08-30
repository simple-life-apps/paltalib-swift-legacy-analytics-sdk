//
//  DeviceInfoProviderTests.swift
//  PaltaLibTests
//
//  Created by Vyacheslav Beltyukov on 11.04.2022.
//

import XCTest
@testable import PaltaLibAnalytics

final class DeviceInfoProviderTests: XCTestCase {
    var infoProvider: DeviceInfoProviderImpl!

    override func setUpWithError() throws {
        try super.setUpWithError()

        infoProvider = .init()
    }

    func testCountry() {
        XCTAssertEqual(infoProvider.country, Locale.current.regionCode)
    }

    func testLanguage() {
        XCTAssertEqual(infoProvider.language, Locale.current.languageCode)
    }

    func testDevice() {
        #if targetEnvironment(simulator)
        XCTAssertEqual(infoProvider.deviceModel, "iPhone Simulator")
        #else
        XCTAssertEqual(infoProvider.deviceModel, "iPhone")
        #endif
    }

    func testNoCarrier() {
        XCTAssertEqual(infoProvider.carrier, "Unknown")
    }

    func testTimezone() {
        XCTAssert((-12...12).contains(infoProvider.timezoneOffset))
    }
}
