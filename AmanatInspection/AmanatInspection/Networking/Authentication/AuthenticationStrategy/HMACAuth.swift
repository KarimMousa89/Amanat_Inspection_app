//
//  HMACAuth.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 15/01/2026.
//

import Foundation

struct HMACAuth: AuthenticationStrategy {
    let secret: String

    func apply(to request: inout URLRequest) async throws {
        let timestamp = "\(Int(Date().timeIntervalSince1970))"
        let payload = request.httpBody ?? Data()
        let secretData = secret.data(using: .utf8) ?? Data()
        let signature = payload.hmacSHA256(secret: secretData)

        request.setValue(signature.base64EncodedString(), forHTTPHeaderField: "X-Signature")
        request.setValue(timestamp, forHTTPHeaderField: "X-Timestamp")
    }
}
