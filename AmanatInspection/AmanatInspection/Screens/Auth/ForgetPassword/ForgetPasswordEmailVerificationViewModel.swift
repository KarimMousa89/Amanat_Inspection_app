//
//  ForgetPasswordViewModel.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import Foundation

@MainActor
protocol ForgetPasswordEmailViewModel {
    var coordinator: AnyLoginCoordinator? { get set }
    var verificationErrorMessage: String? { get set }
    func verify(email: String) async -> Bool
}

@MainActor @Observable
class ForgetPasswordEmailViewModelImpl: ForgetPasswordEmailViewModel {
    var coordinator: AnyLoginCoordinator?
    
    var verificationErrorMessage: String?
    
    func verify(email: String) async -> Bool {
        navigateToPasswordSet()
        return true
    }
    
    init(coordinator: AnyLoginCoordinator? = nil) {
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

