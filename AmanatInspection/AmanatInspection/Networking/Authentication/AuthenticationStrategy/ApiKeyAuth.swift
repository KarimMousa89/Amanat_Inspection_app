//
//  ApiKeyAuth.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 15/01/2026.
//

import Foundation

struct ApiKeyAuth: AuthenticationStrategy {
    let apiKey: String
    let clientToken: String

    func apply(to request: inout URLRequest) async throws {
        request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
        request.setValue(clientToken, forHTTPHeaderField: "X-Client-Token")
    }
}
