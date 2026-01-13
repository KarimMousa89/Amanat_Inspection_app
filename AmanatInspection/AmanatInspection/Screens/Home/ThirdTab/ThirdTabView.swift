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
                coordinator.handleURLComponents(urlComponents)
            }
        }
        
        Button("Cross Tab Navigate to First Tab details view") {
            coordinator.perform(on: .first, action: .push(.bookDetais(book: Book(title: "Karim"))), switchTab: true)
//            coordinator.perform(on: .first, actionType: .push, route: .bookDetais(book: Book(title: "Karim")), switchTab: true)
        }
    }
}

#Preview {
    ThirdTabView()
}
