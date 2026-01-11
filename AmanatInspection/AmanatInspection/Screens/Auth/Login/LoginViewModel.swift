//
//  LoginViewModel.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import Foundation

@MainActor
protocol LoginViewModel {
    var coordinator: AnyNavigationModalCoordinator<LoginRoute>? { get set }
    var userName: String { get set }
    var password: String { get set }
    var displayedCaptcha: String  { get set }
    var userCaptcha: String  { get set }
    var userNameErrorMessage: String? { get set }
    var passwordErrorMessage: String? { get set }
    var captchaErrorMessage: String? { get set }
    var loginErrorMessage: String? { get set }
    
    func regenerateCaptcha()
    func forgetPassword()
    func login(handler: any LoginNavigating) async
}

@MainActor @Observable
class LoginViewModelImpl: LoginViewModel {
    var coordinator: AnyNavigationModalCoordinator<LoginRoute>? = nil
    
    var userName: String = ""
    var password: String = ""
    var displayedCaptcha: String = ""
    var userCaptcha: String = ""
    
    var userNameErrorMessage: String?
    var passwordErrorMessage: String?
    var captchaErrorMessage: String?
    
    var loginErrorMessage: String?

    init (coordinator: AnyNavigationModalCoordinator<LoginRoute>? = nil) {
        self.coordinator = coordinator
        regenerateCaptcha()
    }
    
    func regenerateCaptcha() {
        displayedCaptcha = randomString(length: 5)
    }
    
    func login(handler: any LoginNavigating) {
        //        loginErrorMessage = "7Mada"
        handler.loginDidSuccess()
    }
    
    func forgetPassword() {
        coordinator?.push(.forgetPasswordPath(.emailVerification(makeViewModel: {
            ForgetPasswordEmailViewModelImpl(coordinator: self.coordinator)
        })))
    }
}
