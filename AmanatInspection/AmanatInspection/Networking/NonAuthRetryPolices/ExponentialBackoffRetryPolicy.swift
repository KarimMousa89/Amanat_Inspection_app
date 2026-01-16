//
//  ExponentialBackoffRetryPolicy.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 14/01/2026.
//

import Foundation

struct ExponentialBackoffRetryPolicy: RetryPolicy {
    var contentBased: Bool = false
    
    let maxRetries: Int
    let baseDelay: TimeInterval
    let maxDelay: TimeInterval
    
    func shouldRetry(attempt: Int, error: NetworkError?, response: HTTPURLResponse?, data: Data?, considerContent: ContentConsideration) -> RetryDecision? {
        guard attempt <= maxRetries else {
            return nil
        }

        let exponentialDelay = min(
            maxDelay,
            baseDelay * pow(2, Double(attempt - 1))
        )

        // Full jitter
        let jitteredDelay = TimeInterval.random(in: 0...exponentialDelay)

        return .retry(after: jitteredDelay)
    }
}
