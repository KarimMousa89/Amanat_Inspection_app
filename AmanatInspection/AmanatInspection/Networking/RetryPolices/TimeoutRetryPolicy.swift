//
//  TimeoutRetryPolicy.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 14/01/2026.
//

import Foundation

struct TimeoutRetryPolicy: RetryPolicy {
    var contentBased: Bool = false
    
    let maxRetries: Int
    let delay: TimeInterval

    
    func shouldRetry(attempt: Int, error: NetworkError?, response: HTTPURLResponse?, data: Data?, considerContent: ContentConsideration) -> RetryDecision? {
        guard attempt < maxRetries else {
            return nil
        }

        if case .transportFailure(let underlyingError) = error,
           (underlyingError as? URLError)?.code == .timedOut {
            return .retry(after: delay)
        }

        return nil
    }
}
