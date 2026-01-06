//
//  NavigationCoordinator.swift
//  FifthDemo
//
//  Created by Karim Mousa on 10/07/2025.
//

import Foundation
import SwiftUI

@MainActor
protocol Coordinator {
    associatedtype ViewType: View
    func view() -> ViewType
}

@MainActor
protocol NavigationCoordinator: ObservableObject {
    associatedtype Route: Hashable
    var navPath: NavigationPath { get set }
    func push(_ destination: Route)
    func pop()
    func popLast(_ count: Int)
    func popToRoot()
    func resetToNewRoot(_ destination: Route)
    
    // TODO: define ModalCoordinator as decorator for the coordinator, so we add presentation cabability for any navigation stack or tab view
    var modalScene: Route? { get set }
    func presentModal(_ scene: Route)
    func dismissModal()
}

extension NavigationCoordinator {
    func push(_ destination: Route) {
        print("push \(destination)")
        navPath.append(destination)
    }

    func pop() {
        print("pop")
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
        navPath = NavigationPath([destination])
    }
}


@MainActor
protocol ModalCoordinator: ObservableObject {
    associatedtype Route: Hashable
    // TODO: define ModalCoordinator as decorator for the coordinator, so we add presentation cabability for any navigation stack or tab view
    var modalScene: Route? { get set }
    func presentModal(_ scene: Route)
    func dismissModal()
}

extension ModalCoordinator {
    func presentModal(_ scene: Route) {
        print("presentModal \(scene)")
        self.modalScene = scene
    }
    
    func dismissModal() {
        print("dismissModal")
        self.modalScene = nil
    }
}
