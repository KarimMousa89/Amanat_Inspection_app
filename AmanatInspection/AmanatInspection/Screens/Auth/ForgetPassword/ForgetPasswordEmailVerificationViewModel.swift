//
//  ForgetPasswordViewModel.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import Foundation

@MainActor
protocol ForgetPasswordEmailViewModel {
    var coordinator: AnyNavigationModalCoordinator<LoginRoute>? { get set }
    var verificationErrorMessage: String? { get set }
    func verify(email: String) async -> Bool
}

@MainActor @Observable
class ForgetPasswordEmailViewModelImpl: ForgetPasswordEmailViewModel {
    var coordinator: AnyNavigationModalCoordinator<LoginRoute>?
    
    var verificationErrorMessage: String?
    
    func verify(email: String) async -> Bool {
        navigateToPasswordSet()
        return true
    }
    
    init(coordinator: AnyNavigationModalCoordinator<LoginRoute>? = nil) {
        self.coordinator = coordinator
    }
}

private extension ForgetPasswordEmailViewModelImpl {
    func navigateToPasswordSet() {
        //        verificationErrorMessage = "7mada"
        coordinator?.push(.forgetPasswordPath(.setNew(makeViewModel: {
            ForgetPasswordSetNewViewModelImpl(coordinator: self.coordinator)
        })))
    }
}

