//
//  EventStorageMock.swift
//  PaltaLibTests
//
//  Created by Vyacheslav Beltyukov on 04.04.2022.
//

import Foundation
@testable import PaltaLibAnalytics

final class EventStorageMock: EventStorage {
    var addedEvents: [Event] = []

    var removedEvents: [Event] = []

    var eventsToLoad: [Event] = []
    
    var storeError: Error?

    func storeEvent(_ event: Event) throws {
        addedEvents.append(event)
        
        if let storeError = storeError {
            throw storeError
        }
    }

    func removeEvent(_ event: Event) {
        removedEvents.append(event)
    }

    func loadEvents(_ completion: @escaping ([Event]) -> Void) {
        completion(eventsToLoad)
    }
}
