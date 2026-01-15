//
//  TokenRefreshCoordinator.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 15/01/2026.
//

import Foundation

actor TokenRefreshCoordinator {
    private let refresher: TokenRefresher
    private var isRefreshing = false
    private var waiters: [CheckedContinuation<Void, Error>] = []

    
    init(refresher: TokenRefresher) {
        self.refresher = refresher
    }

    func refresh() async throws {
        if isRefreshing {
            try await withCheckedThrowingContinuation { cont in
                waiters.append(cont)
            }
            return
        }

        isRefreshing = true
        do {
            try await refresher.refreshToken()
            waiters.forEach { $0.resume() }
            waiters.removeAll()
            isRefreshing = false
        } catch {
            waiters.forEach { $0.resume(throwing: error) }
            waiters.removeAll()
            isRefreshing = false
            throw error
        }
    }
}
