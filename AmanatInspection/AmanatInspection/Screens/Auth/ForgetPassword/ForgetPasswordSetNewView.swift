//
//  ForgetPasswordCodeView.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import SwiftUI

struct ForgetPasswordSetNewView<ViewModel: ForgetPasswordSetNewViewModelImpl>: View {
    @Environment(\.loginNavigator) var loginHandler
    
    @State var viewModel: ViewModel
    
    init(makeViewModel: @escaping () -> ViewModel) {
        _viewModel = State(initialValue: makeViewModel())
    }
    
    var body: some View {
        VStack {
            Text("Forget Password Code View")

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
            
            Button("Verify Code & Set New Worng Password") {
                Task {
                    await viewModel.process(verificationCode: "123456", newPassword: "123453", confirmPassword: "123456")
                }
            }

            Button("Verify Code & Set New Correct Password") {
                Task {
                    guard await viewModel.process(verificationCode: "123456", newPassword: "654321", confirmPassword: "654321") else { return }
                }
            }
            
            Button("Simulate Login") {
                viewModel.simulateLogin()
            }
        }
        .onLoad {
            viewModel.loginHandler = self.loginHandler
        }
    }
}
