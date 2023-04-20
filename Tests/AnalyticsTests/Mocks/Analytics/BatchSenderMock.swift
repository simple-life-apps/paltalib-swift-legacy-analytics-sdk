//
//  BatchSenderMock.swift
//  PaltaLibTests
//
//  Created by Vyacheslav Beltyukov on 21/10/2022.
//

import Foundation
import PaltaCore
@testable import PaltaLibAnalytics

final class BatchSenderMock: BatchSender {
    var batch: Batch?
    var result: Result<(), CategorisedNetworkError>?
    
    func sendBatch(_ batch: Batch, completion: @escaping (Result<(), CategorisedNetworkError>) -> Void) {
        self.batch = batch
        
        if let result = result {
            completion(result)
        }
    }
}
