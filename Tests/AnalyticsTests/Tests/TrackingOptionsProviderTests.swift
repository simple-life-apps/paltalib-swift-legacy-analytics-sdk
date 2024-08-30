//
//  TrackingOptionsProviderTests.swift
//  PaltaLibTests
//
//  Created by Vyacheslav Beltyukov on 14.04.2022.
//

import XCTest
@testable import PaltaLibAnalytics

final class TrackingOptionsProviderTests: XCTestCase {
    func testInitial() {
        let provider = TrackingOptionsProviderImpl()

        XCTAssertTrue(provider.trackingOptions.shouldTrackCarrier())
        XCTAssertTrue(provider.trackingOptions.shouldTrackCountry())
        XCTAssertTrue(provider.trackingOptions.shouldTrackLanguage())
        XCTAssertTrue(provider.trackingOptions.shouldTrackPlatform())
        XCTAssertTrue(provider.trackingOptions.shouldTrackOSName())
        XCTAssertTrue(provider.trackingOptions.shouldTrackVersionName())
        XCTAssertTrue(provider.trackingOptions.shouldTrackDeviceModel())
        XCTAssertTrue(provider.trackingOptions.shouldTrackDeviceManufacturer())
        XCTAssertTrue(provider.trackingOptions.shouldTrackOSVersion())

        XCTAssertTrue(provider.trackingOptions.shouldTrackIDFA())
        XCTAssertTrue(provider.trackingOptions.shouldTrackIDFV())
    }

    func testNoIDFA() {
        let provider = TrackingOptionsProviderImpl()

        provider.setTrackingOptions(
            AMPTrackingOptions()
                .disableIDFA()
        )

        XCTAssertTrue(provider.trackingOptions.shouldTrackCarrier())
        XCTAssertTrue(provider.trackingOptions.shouldTrackCountry())
        XCTAssertTrue(provider.trackingOptions.shouldTrackLanguage())
        XCTAssertTrue(provider.trackingOptions.shouldTrackPlatform())
        XCTAssertTrue(provider.trackingOptions.shouldTrackOSName())
        XCTAssertTrue(provider.trackingOptions.shouldTrackVersionName())
        XCTAssertTrue(provider.trackingOptions.shouldTrackDeviceModel())
        XCTAssertTrue(provider.trackingOptions.shouldTrackDeviceManufacturer())
        XCTAssertTrue(provider.trackingOptions.shouldTrackOSVersion())

        XCTAssertFalse(provider.trackingOptions.shouldTrackIDFA())
        XCTAssertTrue(provider.trackingOptions.shouldTrackIDFV())
    }

    func testInitialConfigured() {
        let provider = TrackingOptionsProviderImpl()

        provider.setTrackingOptions(
            AMPTrackingOptions()
        )

        XCTAssertTrue(provider.trackingOptions.shouldTrackCarrier())
        XCTAssertTrue(provider.trackingOptions.shouldTrackCountry())
        XCTAssertTrue(provider.trackingOptions.shouldTrackLanguage())
        XCTAssertTrue(provider.trackingOptions.shouldTrackPlatform())
        XCTAssertTrue(provider.trackingOptions.shouldTrackOSName())
        XCTAssertTrue(provider.trackingOptions.shouldTrackVersionName())
        XCTAssertTrue(provider.trackingOptions.shouldTrackDeviceModel())
        XCTAssertTrue(provider.trackingOptions.shouldTrackDeviceManufacturer())
        XCTAssertTrue(provider.trackingOptions.shouldTrackOSVersion())

        XCTAssertTrue(provider.trackingOptions.shouldTrackIDFA())
        XCTAssertTrue(provider.trackingOptions.shouldTrackIDFV())
    }

    func testCoppaOff1() {
        let provider = TrackingOptionsProviderImpl()

        provider.setTrackingOptions(
            AMPTrackingOptions()
                .disableIDFA()
        )

        XCTAssertTrue(provider.trackingOptions.shouldTrackCarrier())
        XCTAssertTrue(provider.trackingOptions.shouldTrackCountry())
        XCTAssertTrue(provider.trackingOptions.shouldTrackLanguage())
        XCTAssertTrue(provider.trackingOptions.shouldTrackPlatform())
        XCTAssertTrue(provider.trackingOptions.shouldTrackOSName())
        XCTAssertTrue(provider.trackingOptions.shouldTrackVersionName())
        XCTAssertTrue(provider.trackingOptions.shouldTrackDeviceModel())
        XCTAssertTrue(provider.trackingOptions.shouldTrackDeviceManufacturer())
        XCTAssertTrue(provider.trackingOptions.shouldTrackOSVersion())

        XCTAssertFalse(provider.trackingOptions.shouldTrackIDFA())
        XCTAssertTrue(provider.trackingOptions.shouldTrackIDFV())
    }

    func testCoppaOnOff1() {
        let provider = TrackingOptionsProviderImpl()

        provider.setTrackingOptions(
            AMPTrackingOptions()
                .disableIDFA()
        )

        XCTAssertTrue(provider.trackingOptions.shouldTrackCarrier())
        XCTAssertTrue(provider.trackingOptions.shouldTrackCountry())
        XCTAssertTrue(provider.trackingOptions.shouldTrackLanguage())
        XCTAssertTrue(provider.trackingOptions.shouldTrackPlatform())
        XCTAssertTrue(provider.trackingOptions.shouldTrackOSName())
        XCTAssertTrue(provider.trackingOptions.shouldTrackVersionName())
        XCTAssertTrue(provider.trackingOptions.shouldTrackDeviceModel())
        XCTAssertTrue(provider.trackingOptions.shouldTrackDeviceManufacturer())
        XCTAssertTrue(provider.trackingOptions.shouldTrackOSVersion())

        XCTAssertFalse(provider.trackingOptions.shouldTrackIDFA())
        XCTAssertTrue(provider.trackingOptions.shouldTrackIDFV())
    }

    func testCoppaOnOff2() {
        let provider = TrackingOptionsProviderImpl()

        provider.setTrackingOptions(
            AMPTrackingOptions()
                .disableIDFA()
        )

        XCTAssertTrue(provider.trackingOptions.shouldTrackCarrier())
        XCTAssertTrue(provider.trackingOptions.shouldTrackCountry())
        XCTAssertTrue(provider.trackingOptions.shouldTrackLanguage())
        XCTAssertTrue(provider.trackingOptions.shouldTrackPlatform())
        XCTAssertTrue(provider.trackingOptions.shouldTrackOSName())
        XCTAssertTrue(provider.trackingOptions.shouldTrackVersionName())
        XCTAssertTrue(provider.trackingOptions.shouldTrackDeviceModel())
        XCTAssertTrue(provider.trackingOptions.shouldTrackDeviceManufacturer())
        XCTAssertTrue(provider.trackingOptions.shouldTrackOSVersion())

        XCTAssertFalse(provider.trackingOptions.shouldTrackIDFA())
        XCTAssertTrue(provider.trackingOptions.shouldTrackIDFV())
    }
}
