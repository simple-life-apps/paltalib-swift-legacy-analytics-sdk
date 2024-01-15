//
//  BatchSender.swift
//  PaltaLibAnalytics
//
//  Created by Vyacheslav Beltyukov on 20/10/2022.
//

import Foundation
import PaltaCore

protocol BatchSender {
    func sendBatch(_ batch: Batch, completion: @escaping (Result<(), CategorisedNetworkError>) -> Void)
}

final class BatchSenderImpl: BatchSender {
    var apiToken: String? {
        didSet {
            httpClient.mandatoryHeaders["X-API-Key"] = apiToken ?? ""
        }
    }
    
    var baseURL: URL?
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func sendBatch(_ batch: Batch, completion: @escaping (Result<(), CategorisedNetworkError>) -> Void) {
        guard let apiToken = apiToken else {
            assertionFailure("Attempt to send event without API token")
            return
        }
        
        guard !batch.events.isEmpty else {
            completion(.success(()))
            return
        }
        
        let errorHandler = ErrorHandler(completion: completion)

        let request = AnalyticsHTTPRequest.sendEvents(
            baseURL,
            SendEventsPayload(
                apiKey: apiToken,
                events: batch.events,
                serviceInfo: .init(
                    uploadTime: .currentTimestamp(),
                    library: .init(name: "PaltaBrain", version: global_sdkVersion), // TODO: Auto update version
                    telemetry: batch.telemetry,
                    batchId: batch.batchId
                )
            )
        )

        httpClient.perform(request) { (result: Result<EmptyResponse, NetworkErrorWithoutResponse>) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                errorHandler.handle(error)
            }
        }
    }
}

private struct ErrorHandler {
    let completion: (Result<Void, CategorisedNetworkError>) -> Void
    
    func handle(_ error: NetworkErrorWithoutResponse) {
        completion(.failure(CategorisedNetworkError(error)))
    }
}
