//
//  CompositeRetryPolicy.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 14/01/2026.
//

import Foundation

struct CompositeRetryPolicy: RetryPolicy {
    var contentBased: Bool {
        policies.contains(where: { $0.contentBased })
    }
    
    let policies: [RetryPolicy]

    func shouldRetry(attempt: Int, error: NetworkError?, response: HTTPURLResponse?, data: Data?, considerContent: ContentConsideration) -> RetryDecision? {
        
        var requiredPolices: [RetryPolicy] = policies
        
        if considerContent == .nonContentBasedOnly {
            requiredPolices = requiredPolices.filter( { $0.contentBased == false } )
        }
        
        for policy in requiredPolices {
            if let decision = policy.shouldRetry(
                attempt: attempt,
                error: error,
                response: response,
                data: data,
                considerContent: considerContent
            ) {
                return decision
            }
        }

        return nil
    }
}
