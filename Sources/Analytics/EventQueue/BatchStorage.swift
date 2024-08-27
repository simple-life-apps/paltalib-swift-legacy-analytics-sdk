//
//  BatchStorage.swift
//  PaltaLibAnalytics
//
//  Created by Vyacheslav Beltyukov on 20/10/2022.
//

import Foundation
import PaltaCore

protocol BatchStorage {
    func loadBatch() throws -> Batch?
    
    /// This method supposed to save the batch and simultaneously delete events that form the batch from event storage
    func saveBatch(_ batch: Batch) throws
    
    func removeBatch() throws
}
