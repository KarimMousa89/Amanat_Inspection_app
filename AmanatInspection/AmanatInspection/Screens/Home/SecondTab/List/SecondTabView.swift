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
    @State var viewModel: ViewModel
    
    @State private var tabBarHidden: Bool = false
    
    var body: some View {
        VStack {
            Button("Add New User") {
                viewModel.addNewUser()
            }
        }
        .onLoad {
            viewModel.coordinator = coordinator
        }
        .onAppear {
            tabBarHidden = false
        }.task {
            await viewModel.fetchUsers()
        }
        .toolbar(tabBarHidden ?.hidden : .visible, for: .tabBar)
    }
        
}
