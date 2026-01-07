////
////  SecondTabView.swift
////  FifthDemo
////
////  Created by Karim Mousa on 06/07/2025.
////
//
//import SwiftUI
//
////Users list & Add new user
//struct SecondTabView<ViewModel: SecondTabViewModel>: View {
//    @EnvironmentObject var coordinator: SecondTabCoordinator
//    @StateObject var viewModel: ViewModel
//    
//    @State private var tabBarHidden: Bool = false
//    
//    var body: some View {
//        VStack {
//            Button("Add New User") {
//                let loginCoordinator = LoginCoordinator {
//                    print(">>> Login Success")
//                    coordinator.dismissModal()
//                }
//                coordinator.presentModal(SecondTabRoute.addUser(coordinator: loginCoordinator))
//            }
//        }
//        .onAppear {
//            tabBarHidden = false
//        }.task {
//            await viewModel.fetchUsers()
//        }
//        .toolbar(tabBarHidden ?.hidden : .visible, for: .tabBar)
//    }
//        
//}
