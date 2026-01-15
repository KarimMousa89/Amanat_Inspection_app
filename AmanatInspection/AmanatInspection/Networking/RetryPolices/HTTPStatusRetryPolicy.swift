//
//  HTTPStatusRetryPolicy.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 14/01/2026.
//

import Foundation

struct HTTPStatusRetryPolicy: RetryPolicy {
    var contentBased: Bool = false
    
    let retryStatusCodes: Set<Int>
    let maxRetries: Int
    let delay: TimeInterval

    func shouldRetry(attempt: Int, error: NetworkError?, response: HTTPURLResponse?, data: Data?, considerContent: ContentConsideration) -> RetryDecision? {
        guard attempt < maxRetries else { return nil }

        if let statusCode = response?.statusCode,
           retryStatusCodes.contains(statusCode) {
            return .retry(after: delay)
        }

        return nil
    }
}
