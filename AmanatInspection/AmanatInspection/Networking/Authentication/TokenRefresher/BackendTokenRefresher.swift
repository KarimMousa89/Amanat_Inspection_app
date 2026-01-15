//
//  BackendTokenRefresher.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 15/01/2026.
//

import Foundation

struct BackendTokenRefresher: TokenRefresher {
    let refreshRequest: NetworkRequest

    init(refreshRequest: NetworkRequest) {
        self.refreshRequest = refreshRequest
    }

    func refreshToken() async throws {
        _ = try await NetworkManager().requestData(refreshRequest)
    }
}

//extension BackendTokenRefresher: @unchecked Sendable{}
