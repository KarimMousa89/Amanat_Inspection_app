//
//  FirstTabDetailsView.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import SwiftUI

struct FirstTabDetailsView<ViewModel: FirstTabDetailsViewModel>: View {
    @Environment(\.firstTabCoordinator) var coordinator
    @State var viewModel: ViewModel
    
    init(makeViewModel: @escaping () -> ViewModel) {
        _viewModel = State(initialValue: makeViewModel())
    }
    
    var body: some View {
        VStack {
            Text("Hello, \(viewModel.book.title)")
            
            Button("Go Back") {
                viewModel.didTapBack()
            }
        }.onLoad {
            viewModel.coordinator = coordinator
        }
    }
}
