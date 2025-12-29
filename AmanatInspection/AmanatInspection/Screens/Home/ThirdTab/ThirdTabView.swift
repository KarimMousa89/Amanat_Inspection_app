//
//  ThirdTabView.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import SwiftUI

struct ThirdTabView: View {
    @EnvironmentObject var coordinator: HomeCoordinator
    @EnvironmentObject var logoutSuccessHandler: LogoutSuccessHandler
    
    var body: some View {
        Button("Logout") {
            logoutSuccessHandler.onLogoutSuccess?()
        }
        
        Button("Go to First Tab details view") {
            if let urlComponents = URLComponents(string: "fifthDemo://showUser?userId=5") {
                Task {
                    await coordinator.handleURLComponents(urlComponents)
                }
            }
        }
    }
}

#Preview {
    ThirdTabView()
}
