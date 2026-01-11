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
protocol TabCoordinator: Coordinator {
    associatedtype TabType: Hashable
    var selectedTab: TabType {get set}
}

@MainActor
class LogoutSuccessHandler {
    var onLogoutSuccess: (() -> Void)?
}

protocol HomeNavigating {
    func logoutDidSuccess()
}

typealias HomeCoordinating = TabCoordinator&URLComponentsHandler

@MainActor @Observable
final class HomeCoordinator: HomeCoordinating {
    private let firstTabCoordinator = FirstTabCoordinator()
//    private let secondTabCoordinator = SecondTabCoordinator()
//    private let thirdTabCoordinator = ThirdTabCoordinator()
    
    var selectedTab: HomeTab = .first
    
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
            .environment(\.homeCoordinator, AnyHomeCoordinator(self))
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

@MainActor @Observable
final class AnyHomeCoordinator: HomeCoordinating {
    typealias TabType = HomeTab
    
    // This is the concrete type the View will bind to.
    // It is NOT generic.
    
    // 1. The internal, type-erased storage box.
    @MainActor
    private class AnyCoordinatorBox {
        // We define the properties and methods we need to access.
        // These are abstract and will be implemented by a generic subclass.
        var selectedTab: HomeTab { get { fatalError() } set { fatalError() } }
        func view() -> AnyView { fatalError() }
        func handleURLComponents(_ components: URLComponents) async {}
    }

    // 2. A generic subclass of the box that captures the concrete coordinator type.
    @MainActor
    private class CoordinatorBox<C: HomeCoordinating>: AnyCoordinatorBox where C.TabType == HomeTab {
        private let wrapped: C // Holds the REAL coordinator (e.g., LoginCoordinator or MockLoginCoordinator)

        init(_ coordinator: C) {
            self.wrapped = coordinator
        }

        override var selectedTab: HomeTab {
            get { wrapped.selectedTab }
            set { wrapped.selectedTab = newValue }
        }
        
        override func view() -> AnyView {
            // Here is the single, justified use of AnyView.
            // It's used to erase the ViewType of the wrapped coordinator.
            return AnyView(wrapped.view())
        }
        
        override func handleURLComponents(_ components: URLComponents) async {
            await wrapped.handleURLComponents(components)
        }
    }

    private let box: AnyCoordinatorBox

    init<C: HomeCoordinating>(_ coordinator: C) where C.TabType == HomeTab {
        self.box = CoordinatorBox(coordinator)
    }

    var selectedTab: HomeTab {
        get { box.selectedTab }
        set { box.selectedTab = newValue }
    }
    
    func handleURLComponents(_ components: URLComponents) async {
        await box.handleURLComponents(components)
    }
    
    func view() -> some View {
        box.view()
    }
}

struct HomeCoordinatorView: View {
    @Environment(\.homeCoordinator) var coordinator: AnyHomeCoordinator
    
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
