//
//  RetryPolicy.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 14/01/2026.
//

import Foundation

enum RetryDecision {
    case retryImmediately
    case retry(after: TimeInterval)
}

enum ContentConsideration {
    case all
    case contentBasedOnly
    case nonContentBasedOnly
}

protocol RetryPolicy: Sendable {
    var contentBased: Bool { get }
    func shouldRetry(
        attempt: Int,
        error: NetworkError?,
        response: HTTPURLResponse?,
        data: Data?,
        considerContent: ContentConsideration
    ) -> RetryDecision?
}

