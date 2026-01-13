//
//  SecondTabView.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import SwiftUI

//Users list & Add new user
struct SecondTabView<ViewModel: SecondTabViewModel>: View {
    @Environment(\.secondTabCoordinator) var coordinator
    
    @State private var tabBarHidden: Bool = false
    @State var viewModel: ViewModel
    
    init(makeViewModel: @escaping () -> ViewModel) {
        _viewModel = State(initialValue: makeViewModel())
    }
    
    var body: some View {
        VStack {
            Button("Add New User") {
                viewModel.addNewUser()
            }
        }
        .onLoad {
            tabBarHidden = false
            viewModel.coordinator = coordinator
        }
        .task {
            await viewModel.fetchUsers()
        }
        .toolbar(tabBarHidden ?.hidden : .visible, for: .tabBar)
    }
        
}
