//
//  FirstTabDetailsView.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import SwiftUI

struct SecondTabDetailsView<ViewModel: SecondTabDetailsViewModel>: View {
    @Environment(\.secondTabCoordinator) var coordinator
    @State var viewModel: ViewModel
    
    init(makeViewModel: @escaping () -> ViewModel) {
        _viewModel = State(initialValue: makeViewModel())
    }
    
    var body: some View {
        VStack {
            Text("Hello, \(viewModel.user?.name ?? "")")
            
            Button("Go Back") {
                viewModel.dismiss()
            }
        }.onLoad {
            viewModel.coordinator = coordinator
            Task {
                try await viewModel.loadUserIfNeeded()
            }
        }
    }
}
