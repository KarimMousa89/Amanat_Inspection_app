//
//  ForgetPasswordView.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import SwiftUI

struct ForgetPasswordEmailView<ViewModel: ForgetPasswordEmailViewModel>: View {
    @State private var code: String = ""
    
    @State var viewModel: ViewModel
    
    init(makeViewModel: @escaping () -> ViewModel) {
        _viewModel = State(initialValue: makeViewModel())
    }
    
    var body: some View {
        VStack {
            Text("Forget Password Email View")
            
            Button("Verify Email") {
                Task {
                    guard await viewModel.verify(email: "x.y@z.com")  else { return }
      
                }
            }
        }
    }
}
