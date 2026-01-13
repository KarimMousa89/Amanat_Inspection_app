//
//  TabCoordinator.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 11/01/2026.
//

import Foundation
import SwiftUI

@MainActor
protocol TabCoordinator: Coordinator {
    associatedtype TabType: Hashable
    var selectedTab: TabType {get set}
    func perform(on tab: TabType, action: NavigationAction<CrossTabRoute>, switchTab: Bool)
}

typealias TabCoordinating = TabCoordinator&URLComponentsHandler

@MainActor @Observable
final class AnyTabCoordinator<Tab: Hashable>: TabCoordinating {
    
    // This is the concrete type the View will bind to.
    // It is NOT generic.
    
    // 1. The internal, type-erased storage box.
    @MainActor
    private class BaseTabCoordinatorBox: TabCoordinating {
        // We define the properties and methods we need to access.
        // These are abstract and will be implemented by a generic subclass.
        var selectedTab: Tab { get { fatalError() } set { fatalError() } }
        func view() -> AnyView { fatalError() }
        func handleURLComponents(_ components: URLComponents) { fatalError() }
        func perform(on tab: Tab, action: NavigationAction<CrossTabRoute>, switchTab: Bool) {
            fatalError()
        }
    }

    // 2. A generic subclass of the box that captures the concrete coordinator type.
    @MainActor
    private class TabCoordinatorBox<C: TabCoordinating>: BaseTabCoordinatorBox where C.TabType == Tab {
        private let wrapped: C // Holds the REAL coordinator (e.g., LoginCoordinator or MockLoginCoordinator)

        init(_ coordinator: C) {
            self.wrapped = coordinator
        }

        override var selectedTab: Tab {
            get { wrapped.selectedTab }
            set { wrapped.selectedTab = newValue }
        }
        
        override func view() -> AnyView {
            // Here is the single, justified use of AnyView.
            // It's used to erase the ViewType of the wrapped coordinator.
            return AnyView(wrapped.view())
        }
        
        override func handleURLComponents(_ components: URLComponents) {
            wrapped.handleURLComponents(components)
        }
        
        override func perform(on tab: Tab, action: NavigationAction<CrossTabRoute>, switchTab: Bool) {
            wrapped.perform(on: tab, action: action, switchTab: switchTab)
        }
    }

    private let box: BaseTabCoordinatorBox

    init<C: TabCoordinating>(_ coordinator: C) where C.TabType == Tab {
        self.box = TabCoordinatorBox(coordinator)
    }

    var selectedTab: Tab {
        get { box.selectedTab }
        set { box.selectedTab = newValue }
    }
    
    func handleURLComponents(_ components: URLComponents) {
        box.handleURLComponents(components)
    }
    
    func view() -> some View {
        box.view()
    }
    
    func perform(on tab: Tab, action: NavigationAction<CrossTabRoute>, switchTab: Bool) {
        box.perform(on: tab, action: action, switchTab: switchTab)
    }
}
