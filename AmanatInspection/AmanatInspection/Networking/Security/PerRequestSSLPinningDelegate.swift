//
//  PerRequestSSLPinningDelegate.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 16/01/2026.
//

import Foundation

final class PerRequestSSLPinningDelegate: NSObject, URLSessionDelegate {

    private let evaluator: ServerTrustEvaluating

    init(evaluator: ServerTrustEvaluating) {
        self.evaluator = evaluator
        super.init()
    }

    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {

        guard challenge.protectionSpace.authenticationMethod
                == NSURLAuthenticationMethodServerTrust else {
            completionHandler(.performDefaultHandling, nil)
            return
        }

        let disposition = evaluator.evaluate(challenge: challenge)

        if disposition == .useCredential,
           let trust = challenge.protectionSpace.serverTrust {
            completionHandler(.useCredential, URLCredential(trust: trust))
        } else {
            completionHandler(disposition, nil)
        }
    }
}
