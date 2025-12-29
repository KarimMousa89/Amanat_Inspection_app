//
//  ForgetPasswordView.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import SwiftUI

struct ForgetPasswordEmailView: View {
    @EnvironmentObject var coordinator: LoginCoordinator
    @StateObject var viewModel: ForgetPasswordEmailViewModelImpl
    
    @State private var code: String = ""
    
    init(viewModel: ForgetPasswordEmailViewModelImpl) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            Text("Forget Password Email View")
            
            Button("Verify Email") {
                viewModel.verify(email: "x.y@z.com") {
                    coordinator.push(.forgetPasswordPath(.setNew(viewModel: ForgetPasswordSetNewViewModelImpl())))
                }
            }
        }
    }
}
