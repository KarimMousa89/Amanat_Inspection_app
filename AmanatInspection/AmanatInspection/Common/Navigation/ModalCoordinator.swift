//
//  ModalCoordinator.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 24/01/2026.
//

import Foundation
import SwiftUI

@MainActor
protocol ModalCoordinator: Coordinator{
    associatedtype Route: Hashable
    // TODO: define ModalCoordinator as decorator for the coordinator, so we add presentation cabability for any navigation stack or tab view
    var modalScene: Route? { get set}
    func presentModal(_ scene: Route)
    func dismissModal()
}

extension ModalCoordinator {
    func presentModal(_ scene: Route) {
        modalScene = scene
    }
    
    func dismissModal() {
        modalScene = nil
    }
}

typealias ModalCoordinating = ModalCoordinator&URLComponentsHandler

@MainActor @Observable
final class AnyModalCoordinator<Route: Hashable>: ModalCoordinating {
    
    // This is the concrete type the View will bind to.
    // It is NOT generic.
    
    // 1. The internal, type-erased storage box.
    @MainActor
    private class BaseModalCoordinatorBox: ModalCoordinating {
        var modalScene: Route? { get { fatalError() } set { fatalError() } }
        func view() -> AnyView { fatalError() }
        func handleURLComponents(_ components: URLComponents) { fatalError() }
    }

    // 2. A generic subclass of the box that captures the concrete coordinator type.
    @MainActor
    private class ModalCoordinatorBox<C: ModalCoordinating>: BaseModalCoordinatorBox where C.Route == Route {
        private let wrapped: C // Holds the REAL coordinator (e.g., LoginCoordinator or MockLoginCoordinator)

        init(_ coordinator: C) {
            self.wrapped = coordinator
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

    private let box: BaseModalCoordinatorBox

    init<C: ModalCoordinating>(_ coordinator: C) where C.Route == Route {
        self.box = ModalCoordinatorBox(coordinator)
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
