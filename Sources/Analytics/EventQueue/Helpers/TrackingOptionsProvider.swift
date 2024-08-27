//
//  TrackingOptionsProvider.swift
//  PaltaLibAnalytics
//
//  Created by Vyacheslav Beltyukov on 14.04.2022.
//

import Foundation

protocol TrackingOptionsProvider {
    var trackingOptions: AMPTrackingOptions { get }
}

final class TrackingOptionsProviderImpl: TrackingOptionsProvider {
    var trackingOptions: AMPTrackingOptions {
        lock.lock()
        defer { lock.unlock() }
        return effectiveTrackingOptions
    }
    
    private var appliedrackingOptions: AMPTrackingOptions = .init() {
        didSet {
            updateEffectiveTrackingOptions()
        }
    }

    private let lock = NSRecursiveLock()
    private lazy var effectiveTrackingOptions = makeEffectiveTrackingOptions()

    func setTrackingOptions(_ trackingOptions: AMPTrackingOptions) {
        lock.lock()
        appliedrackingOptions = trackingOptions
        lock.unlock()
    }

    private func makeEffectiveTrackingOptions() -> AMPTrackingOptions {
        return appliedrackingOptions
    }

    private func updateEffectiveTrackingOptions() {
        effectiveTrackingOptions = makeEffectiveTrackingOptions()
    }
}
