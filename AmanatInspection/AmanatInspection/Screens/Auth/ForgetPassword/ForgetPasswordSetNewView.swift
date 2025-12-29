//
//  ForgetPasswordCodeView.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import SwiftUI

struct ForgetPasswordSetNewView: View {
    @EnvironmentObject var loginHandler: LoginSuccessHandler
    @EnvironmentObject var coordinator: LoginCoordinator
    
    @StateObject var viewModel: ForgetPasswordSetNewViewModelImpl
    
    init(viewModel: ForgetPasswordSetNewViewModelImpl) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            Text("Forget Password Code View")

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
            
            Button("Verify Code & Set New Worng Password") {
                viewModel.process(verificationCode: "123456", newPassword: "123453", confirmPassword: "123456") {
                    
                }
            }

            Button("Verify Code & Set New Correct Password") {
                viewModel.process(verificationCode: "123456", newPassword: "654321", confirmPassword: "654321") {
                    coordinator.popLast(2)
                }
            }
            
            Button("Simulate Login") {
//                loginHandler.onLoginSuccess?()
            }
        }
    }
}
