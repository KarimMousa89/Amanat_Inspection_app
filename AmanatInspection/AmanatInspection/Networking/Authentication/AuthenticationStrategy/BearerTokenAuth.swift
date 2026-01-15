//
//  BearerTokenAuth.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 15/01/2026.
//

import Foundation

struct BearerTokenAuth: AuthenticationStrategy {
    let tokenProvider: @Sendable () async throws -> String

    init(tokenProvider: @escaping @Sendable () async throws -> String) {
        self.tokenProvider = tokenProvider
    }

    func apply(to request: inout URLRequest) async throws {
        let token = try await tokenProvider()
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}
