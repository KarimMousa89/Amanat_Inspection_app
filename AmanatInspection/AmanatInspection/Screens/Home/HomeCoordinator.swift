//
//  Home.swift
//  FifthDemo
//
//  Created by Karim Mousa on 07/07/2025.
//

import Foundation
import SwiftUI

enum HomeTab: Hashable {
    case first
    case second
    case third
}

struct TabItem: Identifiable {
    var id = UUID()
    
    var selection: HomeTab
    var name: String
    var image: String
    var view: AnyView
}

@MainActor
class LogoutSuccessHandler {
    var onLogoutSuccess: (() -> Void)?
}

protocol HomeNavigating {
    func logoutDidSuccess()
}

@MainActor @Observable
final class HomeCoordinator: TabCoordinating {
    typealias TabType = HomeTab
    var selectedTab: TabType = .first
    
    private let firstTabCoordinator = FirstTabCoordinator()
//    private let secondTabCoordinator = SecondTabCoordinator()
//    private let thirdTabCoordinator = ThirdTabCoordinator()
    
    
    private var navigator: HomeNavigating
    init(navigator: HomeNavigating) {
        self.navigator = navigator
    }
    
    func view() -> some View{
        let tabs: [TabItem] = [
            TabItem(selection: .first, name: "First", image: "house", view: AnyView(firstTabCoordinator.view()))
//            ,
//            TabItem(selection: .second, name: "Second", image: "person", view: AnyView(secondTabCoordinator.view())),
//            TabItem(selection: .third, name: "Third", image: "ellipsis", view: AnyView(thirdTabCoordinator.view()))
        ]
       return HomeCoordinatorView(tabs: tabs)
            .environment(\.homeCoordinator, AnyTabCoordinator(self))
            .environment(\.homeNavigator, navigator)
    }
    
    func handleURLComponents(_ components: URLComponents) async {
//        let action = components.host
//        switch action {
//        case "showUser":
//            NSLog("KK:: second tab related action!")
//            selectedTab = .second
//            await secondTabCoordinator.handleURLComponents(components)
//        default:
//            NSLog("KK:: Unknown URL action: \(String(describing: action))")
//        }
    }
}

struct HomeCoordinatorView: View {
    @Environment(\.homeCoordinator) var coordinator: AnyTabCoordinator
    
    var tabs: [TabItem]
    
    var body: some View {
        @Bindable var coordinator = coordinator
        TabView(selection: $coordinator.selectedTab){
            ForEach(tabs) { tab in
                Tab(tab.name, systemImage: tab.image, value: tab.selection) {
                    tab.view
                }
            }
        }
        .tabViewStyle(.tabBarOnly)
    }
}
