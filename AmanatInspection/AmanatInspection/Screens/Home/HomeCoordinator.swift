//
//  Home.swift
//  FifthDemo
//
//  Created by Karim Mousa on 07/07/2025.
//

import Foundation
import SwiftUI

enum HomeTab: Int {
    case first = 0
    case second
    case third
}

struct TabItem<TabType: Hashable>: Identifiable {
    var id = UUID()
    
    var selection: TabType
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
    private let secondTabCoordinator = SecondTabCoordinator()
    private let thirdTabCoordinator = ThirdTabCoordinator()
    
    private var navigator: HomeNavigating
    init(navigator: HomeNavigating) {
        self.navigator = navigator
    }
    
    func view() -> some View{
        let tabs: [TabItem<HomeTab>] = [
            TabItem(selection: .first, name: "First", image: "house", view: AnyView(firstTabCoordinator.view())),
            TabItem(selection: .second, name: "Second", image: "person", view: AnyView(secondTabCoordinator.view())),
            TabItem(selection: .third, name: "Third", image: "ellipsis", view: AnyView(thirdTabCoordinator.view()))
        ]
       return HomeCoordinatorView(tabs: tabs)
            .environment(\.homeCoordinator, AnyTabCoordinator(self))
            .environment(\.homeNavigator, navigator)
    }
    
    func handleURLComponents(_ components: URLComponents) {
        let action = components.host
        switch action {
        case "showUser":
            NSLog("KK:: second tab related action!")
            selectedTab = .second
            secondTabCoordinator.handleURLComponents(components)
        default:
            NSLog("KK:: Unknown URL action: \(String(describing: action))")
        }
    }
    
    func perform(on tab: TabType, action: NavigationAction<CrossTabRoute>, switchTab: Bool) {
        if switchTab {
            self.selectedTab = tab
        }
        
        guard let route = action.route else {
            switch tab {
            case .first:
                guard let erasedAction: NavigationAction<FirstTabRoute> = action.eraseRoute() else { return }
                firstTabCoordinator.perform(erasedAction)
            case .second:
                guard let erasedAction: NavigationAction<SecondTabRoute> = action.eraseRoute() else { return }
                secondTabCoordinator.perform(erasedAction)
            default:
                break
            }
            return
        }

        guard let resolvedRoute = resolve(tab: tab, route: route) else { return }

        perform(action, with: resolvedRoute)
    }
}

private extension HomeCoordinator{
    private enum ResolvedCrossTabRoute {/// No Third Tab here because no cross tab navigation happens on it
        case first(FirstTabRoute)
        case second(SecondTabRoute)
    }

    private func resolve( tab: TabType, route: CrossTabRoute) -> ResolvedCrossTabRoute? {
        switch (tab, route) {
        case (.first, .bookDetais(let book)):
            return .first(
                .details(makeViewModel: {
                    FirstTabDetailsViewModelImpl(book: book)
                })
            )
        case (.second, .userDetails(let user)):
            guard let model = SecondTabDetailsViewModelImpl(user: user) else { return nil }
            return .second(.details(makeViewModel: {
                model
            }))
        default:
            return nil
        }
    }
    
    private func perform(_ action: NavigationAction<CrossTabRoute>, with resolved: ResolvedCrossTabRoute) {
        switch (action, resolved) {
        case (.push, .first(let route)):
            firstTabCoordinator.perform(.push(route))
        case (.present, .first(let route)):
            firstTabCoordinator.perform(.present(route))
        case (.reset, .first(let route)):
            firstTabCoordinator.perform(.reset(route))
        case (.push, .second(let route)):
            secondTabCoordinator.perform(.push(route))
        case (.present, .second(let route)):
            secondTabCoordinator.perform(.present(route))
        case (.reset, .second(let route)):
            secondTabCoordinator.perform(.reset(route))
        default:
            break
        }
    }
}

enum CrossTabRoute: Hashable {
    case userDetails(user: User)
    case bookDetais(book: Book)
}

struct HomeCoordinatorView: View {
    @Environment(\.homeCoordinator) var coordinator
    
    var tabs: [TabItem<HomeTab>]
    
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
