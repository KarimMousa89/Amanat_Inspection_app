//
//  FirstTabDetailsViewModel.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import Foundation

@MainActor
protocol SecondTabDetailsViewModel {
    var coordinator: AnyNavigationModalCoordinator<SecondTabRoute>? { get set }
    var userId: String? { get }
    var user: User? { get }
    func dismiss()
    func loadUserIfNeeded() async throws
}

@MainActor @Observable
class SecondTabDetailsViewModelImpl: SecondTabDetailsViewModel {
    var coordinator: AnyNavigationModalCoordinator<SecondTabRoute>? = nil
    var user: User?
    var userId: String?
    
    init?(userId: String? = nil, user: User? = nil) {
        if userId == nil && user == nil {
            return nil
        }
        self.userId = userId
        self.user = user
    }
    
    func loadUserIfNeeded() async throws {
        guard user == nil, let userId else {
            return
        }
        // start loading
        try await Task.sleep(nanoseconds: 100_000_000)
        
        self.user = User(id: userId, name: "User \(userId)")
    }
    
    func dismiss() {
        coordinator?.pop()
    }
}
