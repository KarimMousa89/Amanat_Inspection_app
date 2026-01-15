//
//  CompositeTokenRefresher.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 15/01/2026.
//

import Foundation

struct CompositeTokenRefresher: TokenRefresher {
    let refreshers: [TokenRefresher]
    
    func refreshToken() async throws {
        var lastError: Error?
        
        for refresher in refreshers {
            do {
                try await refresher.refreshToken()
                return // Success!
            } catch {
                lastError = error
                continue // try next refresher
            }
        }
        
        // All failed
        throw lastError ?? NetworkError.authGenerationFailure(error: nil)
    }
}
