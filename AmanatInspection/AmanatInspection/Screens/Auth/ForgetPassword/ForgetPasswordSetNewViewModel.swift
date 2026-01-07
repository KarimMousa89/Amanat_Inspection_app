//
//  ForgetPasswordCodeViewModel.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import Foundation

protocol ForgetPasswordSetNewViewModel {
    var loginHandler: (any LoginNavigating)? { get set }
    var coordinator: AnyLoginCoordinator? { get set }
    var errorMessage: String? { get set}
    func process(verificationCode: String, newPassword: String, confirmPassword: String) async -> Bool
    func simulateLogin()
}

@MainActor @Observable
class ForgetPasswordSetNewViewModelImpl: @MainActor ForgetPasswordSetNewViewModel {
    var loginHandler: (any LoginNavigating)?
    
    var coordinator: AnyLoginCoordinator?
    
    var errorMessage: String?
    
    init(coordinator: AnyLoginCoordinator? = nil) {
        self.coordinator = coordinator
    }
    
    func process(verificationCode: String, newPassword: String, confirmPassword: String) async -> Bool {
        if newPassword != confirmPassword {
            errorMessage = "Passwords do not match"
            return false
        }
        coordinator?.popToRoot()
        return true
    }
    
    func simulateLogin() {
        loginHandler?.loginDidSuccess()
    }
}
