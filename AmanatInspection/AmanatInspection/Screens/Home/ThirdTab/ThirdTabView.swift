//
//  ThirdTabView.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import SwiftUI

struct ThirdTabView: View {
    @Environment(\.homeCoordinator) var coordinator
    @Environment(\.homeNavigator) var logoutSuccessHandler
    
    var body: some View {
        Button("Logout") {
            logoutSuccessHandler.logoutDidSuccess()
        }
        
        Button("DeepLink Go to Second Tab details view") {
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
