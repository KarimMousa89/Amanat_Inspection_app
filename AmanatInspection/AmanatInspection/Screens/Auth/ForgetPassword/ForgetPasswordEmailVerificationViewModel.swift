//
//  ForgetPasswordViewModel.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import Foundation

protocol ForgetPasswordEmailViewModel: ObservableObject {
    func verify(email: String, onEmailVerificationSuccess: (() -> Void))
}

class ForgetPasswordEmailViewModelImpl: ForgetPasswordEmailViewModel {
    init () {}
    func verify(email: String, onEmailVerificationSuccess: (() -> Void)) {
        //FIXME: call usecase
        onEmailVerificationSuccess()
    }
}

