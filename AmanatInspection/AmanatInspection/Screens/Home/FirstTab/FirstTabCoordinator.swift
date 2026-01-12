//
//  FirstTabCoordinator.swift
//  FifthDemo
//
//  Created by Karim Mousa on 10/07/2025.
//

import Foundation
import SwiftUI

enum FirstTabRoute: Identifiable, Hashable {
    case list(makeViewModel: () -> FirstTabViewModelImpl)
    case details(makeViewModel: () -> FirstTabDetailsViewModelImpl)
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: FirstTabRoute, rhs: FirstTabRoute) -> Bool {
        lhs.id == rhs.id
    }
    var id: String {
        switch self {
        case .list: return "list"
        case .details: return "details"
        }
    }
}

struct FirstTabRouter {
    @MainActor @ViewBuilder
    static func view(for route: FirstTabRoute) -> some View {
        switch route {
        case .list(let makeViewModel):
            FirstTabView(makeViewModel: makeViewModel)
        case .details(let makeViewModel):
            FirstTabDetailsView(makeViewModel: makeViewModel)
        }
    }
}

@MainActor @Observable
class FirstTabCoordinator {
    typealias Route = FirstTabRoute
    var navPath: [Route] = []
    var modalScene: Route? = nil
}

extension FirstTabCoordinator: NavigationModalCoordinating {
    func view() -> some View {
        return FirstTabCoordinatorView()
            .environment(\.firstTabCoordinator, AnyNavigationModalCoordinator(self))
    }
    func handleURLComponents(_ components: URLComponents) async {
        
    }
}

struct FirstTabCoordinatorView: View {
    @Environment(\.firstTabCoordinator) var firstCoordinator
    
    var body: some View {
        @Bindable var coordinator1 = firstCoordinator
        NavigationStack(path: $coordinator1.navPath) {
            FirstTabRouter.view(for: .list(makeViewModel: { FirstTabViewModelImpl(coordinator: firstCoordinator) }))
                .navigationDestination(for: FirstTabRoute.self) { route in
                    FirstTabRouter.view(for: route)
                        .navigationBarBackButtonHidden(true)
//                        .toolbar {
//                            ToolbarItem(placement: .navigationBarLeading) {
//                                Button {
//                                    coordinator.pop()
//                                } label: {
//                                    HStack {
//                                        Image(systemName: "chevron.backward")
//                                        Text("Back") // Force English text
//                                    }
//                                }
//                            }
//                        }
                }
        }
        .sheet(item: $coordinator1.modalScene) { modal in
            FirstTabRouter.view(for: modal)
        }
    }
}
