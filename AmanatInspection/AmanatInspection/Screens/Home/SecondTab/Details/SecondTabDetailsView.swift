//
//  FirstTabDetailsView.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import SwiftUI

struct SecondTabDetailsView<ViewModel: SecondTabDetailsViewModel>: View {
    @State var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Text("Hello, \(viewModel.user?.name ?? "")")
            
            Button("Go Back") {
                viewModel.onDismiss()
            }
        }.onLoad {
            
            Task {
                try await viewModel.loadUserIfNeeded()
            }
        }
    }
}
