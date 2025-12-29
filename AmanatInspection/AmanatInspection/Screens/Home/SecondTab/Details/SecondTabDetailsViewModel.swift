//
//  FirstTabDetailsViewModel.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import Foundation

protocol SecondTabDetailsViewModel: ObservableObject {
    var user: User { get }
    var onDismiss: () -> Void { get }
}

class SecondTabDetailsViewModelImpl: SecondTabDetailsViewModel {
    var onDismiss: () -> Void
    @Published var user: User
    
    init(user: User, onDismiss: @escaping () -> Void) {
        self.user = user
        self.onDismiss = onDismiss
    }
}
