//
//  ForgetPasswordCodeViewModel.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import Foundation
import SwiftUI

protocol ForgetPasswordSetNewViewModel: ObservableObject {
    var errorMessage: String? { get set}
    func process(verificationCode: String, newPassword: String, confirmPassword: String, onPasswordSet: (() -> Void))
}

@Observable
class ForgetPasswordSetNewViewModelImpl: ForgetPasswordSetNewViewModel {

    var errorMessage: String?
    
    func process(verificationCode: String, newPassword: String, confirmPassword: String, onPasswordSet: (() -> Void)) {
        if newPassword != confirmPassword {
            errorMessage = "Passwords do not match"
            return
        }
        
        onPasswordSet()
    }
}
