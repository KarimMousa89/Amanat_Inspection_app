//
//  Home.swift
//  FifthDemo
//
//  Created by Karim Mousa on 07/07/2025.
//

import Foundation
import SwiftUI

struct TabItem: Identifiable {
    var id = UUID()
    
    var selection: HomeTab
    var name: String
    var image: String
    var view: AnyView
}

enum HomeTab: Hashable {
    case first
    case second
    case third
}

@MainActor
protocol TabCoordinator: Coordinator {
    associatedtype TabType: Hashable
    var selectedTab: TabType {get set}
}

class LogoutSuccessHandler: ObservableObject {
    var onLogoutSuccess: (() -> Void)?
}

struct HomeCoordinatorView: View {
    @EnvironmentObject var coordinator: HomeCoordinator
    @State private var selectedTab: HomeTab = .first
    
    var tabs: [TabItem]
    
    var body: some View {
        TabView(selection: $selectedTab){
            ForEach(tabs) { tab in
                Tab(tab.name, systemImage: tab.image, value: tab.selection) {
                    tab.view
                }
            }
        }
        .tabViewStyle(.tabBarOnly)
        .onAppear {
            coordinator.onTabSelected = { newTab in
                selectedTab = newTab
            }
        }
    }
}

@MainActor
final class HomeCoordinator: TabCoordinator {
    private let firstTabCoordinator = FirstTabCoordinator()
    private let secondTabCoordinator = SecondTabCoordinator()
    private let thirdTabCoordinator = ThirdTabCoordinator()
    
    var selectedTab: HomeTab = .first {
        willSet {
            onTabSelected?(newValue)
        }
    }
    var onTabSelected: ((HomeTab) -> Void)?
    
    var logoutSuccessHandler = LogoutSuccessHandler()
    init(onLogoutSuccess: @escaping () -> Void) {
        logoutSuccessHandler.onLogoutSuccess = onLogoutSuccess
    }
    
    func view() -> some View{
        let tabs = [TabItem(selection: .first, name: "First", image: "house", view: AnyView(firstTabCoordinator.view())),
                    TabItem(selection: .second, name: "Second", image: "person", view: AnyView(secondTabCoordinator.view())),
                    TabItem(selection: .third, name: "Third", image: "ellipsis", view: AnyView(thirdTabCoordinator.view()))]
       return HomeCoordinatorView(tabs: tabs)
        .environmentObject(self)
        .environmentObject(logoutSuccessHandler)
    }
    
    func handleURLComponents(_ components: URLComponents) async {
        let action = components.host
        switch action {
        case "showUser":
            NSLog("KK:: second tab related action!")
            selectedTab = .second
            await secondTabCoordinator.handleURLComponents(components)
        default:
            NSLog("KK:: Unknown URL action: \(String(describing: action))")
        }
    }
}
