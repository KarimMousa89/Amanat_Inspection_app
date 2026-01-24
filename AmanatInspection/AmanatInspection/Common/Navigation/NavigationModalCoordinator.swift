//
//  NavigationCoordinator.swift
//  FifthDemo
//
//  Created by Karim Mousa on 10/07/2025.
//

import Foundation
import SwiftUI

enum NavigationModalAction<Route> {
    case push(Route)
    case present(Route)
    case pop
    case popToRoot
    case popLast(Int)
    case dismiss
    case reset(Route)
}

extension NavigationModalAction {
    var route: Route? {
        switch self {
        case .push(let route),
                .present(let route),
                .reset(let route):
            return route
        default:
            return nil
        }
    }
}

extension NavigationModalAction {
    func eraseRoute<NewRoute>() -> NavigationModalAction<NewRoute>? {
        switch self {
        case .pop:
            return .pop
        case .popToRoot:
            return .popToRoot
        case .popLast(let count):
            return .popLast(count)
        case .dismiss:
            return .dismiss
        default: // rootless navigation actions don't need to be erased
            return nil
        }
    }
}


@MainActor
protocol NavigationCoordinator: Coordinator {
    associatedtype Route: Hashable
    var navPath: [Route] { get set }
    func push(_ destination: Route)
    func pop()
    func popLast(_ count: Int)
    func popToRoot()
    func resetToNewRoot(_ destination: Route)
}

extension NavigationCoordinator {
    func push(_ destination: Route) {
        navPath.append(destination)
    }

    func pop() {
        navPath.removeLast()
    }
    
    func popLast(_ count: Int) {
        if count < navPath.count {
            navPath.removeLast(count)
        } else {
            popToRoot()
        }
    }
    
    func popToRoot() {
        navPath.removeLast(navPath.count)
    }
    
    func resetToNewRoot(_ destination: Route) {
        navPath = [destination]
    }
}

@MainActor
protocol NavigationModalCoordinating: NavigationCoordinator, ModalCoordinator, URLComponentsHandler {
    func perform(_ action: NavigationModalAction<Route>)
}

extension NavigationModalCoordinating {
    func perform(_ action: NavigationModalAction<Route>) {
        switch action {
        case .push(let destination):
            push(destination)
        case .pop:
            pop()
        case .popToRoot:
            popToRoot()
        case .popLast(let count):
            popLast(count)
        case .reset(let destination):
            resetToNewRoot(destination)
        case .present(let scene):
            presentModal(scene)
        case .dismiss:
            dismissModal()
        }
    }
}

@MainActor @Observable
final class AnyNavigationModalCoordinator<Route: Hashable>: NavigationModalCoordinating {
    
    // This is the concrete type the View will bind to.
    // It is NOT generic.
    
    // 1. The internal, type-erased storage box.
    @MainActor
    private class BaseNavigationModalCoordinatorBox: NavigationModalCoordinating {
        // We define the properties and methods we need to access.
        // These are abstract and will be implemented by a generic subclass.
        var navPath: [Route] { get { fatalError() } set { fatalError() } }
        var modalScene: Route? { get { fatalError() } set { fatalError() } }
        func view() -> AnyView { fatalError() }
        func handleURLComponents(_ components: URLComponents) { fatalError() }
    }

    // 2. A generic subclass of the box that captures the concrete coordinator type.
    @MainActor
    private class NavigationModalCoordinatorBox<C: NavigationModalCoordinating>: BaseNavigationModalCoordinatorBox where C.Route == Route {
        private let wrapped: C // Holds the REAL coordinator (e.g., LoginCoordinator or MockLoginCoordinator)

        init(_ coordinator: C) {
            self.wrapped = coordinator
        }

        override var navPath: [Route] {
            get { wrapped.navPath }
            set { wrapped.navPath = newValue }
        }

        override var modalScene: Route? {
            get { wrapped.modalScene }
            set { wrapped.modalScene = newValue }
        }

        override func view() -> AnyView {
            // Here is the single, justified use of AnyView.
            // It's used to erase the ViewType of the wrapped coordinator.
            return AnyView(wrapped.view())
        }
        
        override func handleURLComponents(_ components: URLComponents) {
            wrapped.handleURLComponents(components)
        }
    }

    private let box: BaseNavigationModalCoordinatorBox

    init<C: NavigationModalCoordinating>(_ coordinator: C) where C.Route == Route {
        self.box = NavigationModalCoordinatorBox(coordinator)
    }

    var navPath: [Route] {
        get { box.navPath }
        set { box.navPath = newValue }
    }

    var modalScene: Route? {
        get { box.modalScene }
        set { box.modalScene = newValue }
    }

    func view() -> some View {
        box.view()
    }
    
    func handleURLComponents(_ components: URLComponents) {
        box.handleURLComponents(components)
    }
}
