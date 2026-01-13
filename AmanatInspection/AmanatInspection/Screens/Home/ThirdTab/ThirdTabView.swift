//
//  ThirdTabView.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import SwiftUI

struct ThirdTabView<ViewModel: ThirdTabViewModel>: View {
    @Environment(\.homeCoordinator) var coordinator
    @Environment(\.homeNavigator) var logoutSuccessHandler
    
    @State var viewModel: ViewModel
    
    init(makeViewModel: @escaping () -> ViewModel) {
        _viewModel = State(initialValue: makeViewModel())
    }
    
    var body: some View {
        VStack {
            Button("Logout") {
                viewModel.didTapLogout()
            }
            
            Button("DeepLink Go to Second Tab details view") {
                viewModel.didTapDeeplinkSimulation()
            }
            
            Button("Cross Tab Navigate to First Tab details view") {
                viewModel.didTapSwitchToFirstTab()
            }
        }
        .onLoad {
            viewModel.coordinator = coordinator
            viewModel.navigator = logoutSuccessHandler
        }
    }
}
