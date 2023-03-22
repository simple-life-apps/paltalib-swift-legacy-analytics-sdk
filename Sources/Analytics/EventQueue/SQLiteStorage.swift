//
//  SQLiteStorage.swift
//  PaltaLibAnalytics
//
//  Created by Vyacheslav Beltyukov on 26/11/2022.
//

import Foundation
import SQLite3
import PaltaCore

enum SQliteError: Error {
    case databaseCantBeOpen
    case statementPreparationFailed
    case stepExecutionFailed
    case dataExctractionFailed
    case queryFailed
}

final class SQLiteStorage {
    private let encoder: JSONEncoder = JSONEncoder().do {
        $0.dateEncodingStrategy = .custom { date, encoder in
            var container = encoder.singleValueContainer()
            try container.encode(date.description)
        }
    }
    
    private let decoder: JSONDecoder = .default
    
    private let client: SQLiteClient
    
    init(folderURL: URL) throws {
        self.client = try SQLiteClient(folderURL: folderURL)
        
        try populateTables()
    }
    
    private func populateTables() throws {
        try client.executeStatement("CREATE TABLE IF NOT EXISTS events (event_id BLOB PRIMARY KEY, event_data BLOB);")
        try client.executeStatement("CREATE TABLE IF NOT EXISTS batches (batch_id BLOB PRIMARY KEY, batch_data BLOB);")
    }
}

extension SQLiteStorage: EventStorage {
    func storeEvent(_ event: Event) throws {
        let row = RowData(column1: event.insertId.data, column2: try encoder.encode(event))
        try client.executeStatement("INSERT INTO events (event_id, event_data) VALUES (?, ?)") { executor in
            executor.setRow(row)
            try executor.runStep()
        }
    }
    
    func removeEvent(_ event: Event) {
        try? doRemoveEvent(event)
    }
    
    func loadEvents(_ completion: @escaping ([Event]) -> Void) {
        let results: [Event]? = try? client.executeStatement("SELECT event_id, event_data FROM events") { executor in
            var results: [Event] = []
            
            while executor.runQuery(), let row = executor.getRow() {
                if let event = try? decoder.decode(Event.self, from: row.column2) {
                    results.append(event)
                }
            }
            
            return results as [Event]
        }
        
        completion(results ?? [])
    }
    
    private func doRemoveEvent(_ event: Event) throws {
        try client.executeStatement("DELETE FROM events WHERE event_id = ?") { executor in
            executor.setValue(event.insertId.data)
            try executor.runStep()
        }
    }
}

extension SQLiteStorage: BatchStorage {
    func saveBatch(_ batch: Batch) throws {
        do {
            try client.executeStatement("BEGIN TRANSACTION")
            
            try doSaveBatch(batch)
            
            try batch.events.forEach {
                try doRemoveEvent($0)
            }
            
            try client.executeStatement("COMMIT TRANSACTION")
        } catch {
            try client.executeStatement("ROLLBACK TRANSACTION")
            throw error
        }
    }
    
    func loadBatch() throws -> Batch? {
        try client.executeStatement("SELECT batch_id, batch_data FROM batches") { executor in
            executor.runQuery()
            return try executor.getRow().map { try decoder.decode(Batch.self, from: $0.column2) }
        }
    }
    
    func removeBatch() throws {
        try client.executeStatement("DELETE FROM batches WHERE TRUE")
    }
    
    private func doSaveBatch(_ batch: Batch) throws {
        let row = RowData(column1: batch.batchId.data, column2: try encoder.encode(batch))
        try client.executeStatement("INSERT INTO batches (batch_id, batch_data) VALUES (?, ?)") { executor in
            executor.setRow(row)
            try executor.runStep()
        }
    }
}
