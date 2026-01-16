//
//  URLSessionProvider.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 16/01/2026.
//

import Foundation

protocol URLSessionProviding {
    func session(for request: NetworkRequest) -> URLSession
}

final class URLSessionProvider: URLSessionProviding {
    func session(for request: NetworkRequest) -> URLSession{
        let config = URLSessionConfiguration.default

        guard let evaluator = request.serverTrustEvaluator else {
            return URLSession(configuration: config)
        }

        let delegate = PerRequestSSLPinningDelegate(evaluator: evaluator)

        return URLSession(
            configuration: config,
            delegate: delegate,
            delegateQueue: nil
        )
    }
}
