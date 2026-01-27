//
//  BackendTokenRefresher.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 15/01/2026.
//

import Foundation

struct BackendTokenRefresher: TokenRefresher/*, @unchecked Sendable*/ {
    let refreshRequest: NetworkRequest

    init(refreshRequest: NetworkRequest) {
        self.refreshRequest = refreshRequest
    }

    func refreshToken() async throws {
        _ = try await NetworkManagerImp().requestData(refreshRequest)
    }
}
