//
//  TrackingOptionsProviderMock.swift
//  PaltaLibTests
//
//  Created by Vyacheslav Beltyukov on 14.04.2022.
//

import Foundation
@testable import PaltaLibAnalytics

final class TrackingOptionsProviderMock: TrackingOptionsProvider {
    var trackingOptions: AMPTrackingOptions = .init()
}
