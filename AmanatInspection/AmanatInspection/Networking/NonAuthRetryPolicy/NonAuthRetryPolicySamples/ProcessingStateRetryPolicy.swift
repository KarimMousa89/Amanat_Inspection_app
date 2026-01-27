//
//  ProcessingStateRetryPolicy.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 14/01/2026.
//

import Foundation

struct ProcessingStateRetryPolicy: RetryPolicy {
    var contentBased: Bool = true
    
    let maxRetries: Int
    let delay: TimeInterval
    
    func shouldRetry(attempt: Int, error: NetworkError?, response: HTTPURLResponse?, data: Data?, considerContent: ContentConsideration) -> RetryDecision? {
        guard attempt < maxRetries,
              considerContent != .nonContentBasedOnly,
              let data else { return nil }

        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           json["status"] as? String == "processing" {
            return .retry(after: delay)
        }

        return nil
    }
}
