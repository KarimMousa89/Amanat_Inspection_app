//
//  AuthenticationStrategy.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 15/01/2026.
//

import Foundation

protocol AuthenticationStrategy: Sendable {
    func apply(to request: inout URLRequest) async throws
}

protocol TokenRefreshTrigger: Sendable {
    func shouldRefresh(
        attempt: Int,
        error: NetworkError?,
        response: HTTPURLResponse?,
        data: Data?
    ) -> (Bool, Bool)
}

protocol TokenRefresher: Sendable {
    func refreshToken() async throws
}

struct AuthorizationGroup: Sendable {
    let authenticator: AuthenticationStrategy?
    let refreshTrigger: TokenRefreshTrigger?
    let refreshCoordinator: TokenRefreshCoordinator
}
