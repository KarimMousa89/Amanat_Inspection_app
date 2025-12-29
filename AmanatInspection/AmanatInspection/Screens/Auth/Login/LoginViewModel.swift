//
//  LoginViewModel.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import Foundation
import SwiftUI

@MainActor
protocol LoginViewModel: ObservableObject {
    var userName: String { get set }
    var password: String { get set }
    var displayedCaptcha: String  { get set }
    var userCaptcha: String  { get set }
    var userNameErrorMessage: String? { get set }
    var passwordErrorMessage: String? { get set }
    var captchaErrorMessage: String? { get set }
    var loginErrorMessage: String? { get set }
    
    func regenerateCaptcha()
    func login(onLoginSuccess: (() -> Void)?) async
}

@MainActor @Observable
class LoginViewModelImpl: LoginViewModel {
    var userName: String = ""
    var password: String = ""
    var displayedCaptcha: String = ""
    var userCaptcha: String = ""
    
    var userNameErrorMessage: String?
    var passwordErrorMessage: String?
    var captchaErrorMessage: String?
    
    var loginErrorMessage: String?

    init () {
        regenerateCaptcha()
    }
    
    func regenerateCaptcha() {
        displayedCaptcha = randomString(length: 5)
    }
    
    func login(onLoginSuccess: (() -> Void)?) async {
         onLoginSuccess?()
    }
}
