//
//  ServerTrustEvaluating.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 16/01/2026.
//

import Foundation

protocol ServerTrustEvaluating: Sendable {
    func evaluate(
        challenge: URLAuthenticationChallenge
    ) -> URLSession.AuthChallengeDisposition
}
