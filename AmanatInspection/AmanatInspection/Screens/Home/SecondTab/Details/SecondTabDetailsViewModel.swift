//
//  FirstTabDetailsViewModel.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import Foundation

@MainActor
protocol SecondTabDetailsViewModel {
    var userId: String? { get }
    var user: User? { get }
    var onDismiss: () -> Void { get }
    func loadUserIfNeeded() async throws
}

@MainActor @Observable
class SecondTabDetailsViewModelImpl: SecondTabDetailsViewModel {
    var onDismiss: () -> Void
    var user: User?
    var userId: String?
    
    init?(userId: String? = nil, user: User? = nil, onDismiss: @escaping () -> Void) {
        if userId == nil && user == nil {
            return nil
        }
        
        self.userId = userId
        self.user = user
        self.onDismiss = onDismiss
    }
    
    func loadUserIfNeeded() async throws {
        guard user == nil, let userId else {
            return
        }
        // start loading
        try await Task.sleep(nanoseconds: 100_000_000)
        
        self.user = User(id: userId, name: "User \(userId)")
    }
}
