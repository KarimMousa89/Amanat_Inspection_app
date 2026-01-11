//
//  FirstTabCoordinator.swift
//  FifthDemo
//
//  Created by Karim Mousa on 10/07/2025.
//

import Foundation
import SwiftUI

enum FirstTabRoute: Identifiable, Hashable {
    case list(viewModel: FirstTabViewModelImpl)
    case details(viewModel: FirstTabDetailsViewModelImpl)
    
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
        case .list(viewModel: let viewModel):
            FirstTabView(viewModel: viewModel)
        case .details(viewModel: let viewModel):
            FirstTabDetailsView(viewModel: viewModel)
        }
    }
}

struct FirstTabCoordinatorView: View {
    @Environment(\.FirstTabCoordinator) var coordinator
    @State private var navPath = NavigationPath() // Local state
    @State private var modalScene: FirstTabRoute?
    
    var body: some View {
        NavigationStack(path: $navPath) {
            FirstTabRouter.view(for: .list(viewModel: FirstTabViewModelImpl()))
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
        .sheet(item: $modalScene) { modal in
            FirstTabRouter.view(for: modal)
        }
    }
}

typealias FirstTabCoordinating = NavigationCoordinator&ModalCoordinator
class FirstTabCoordinator: FirstTabCoordinating {
    var modalScene: FirstTabRoute?
    
    var navPath: [FirstTabRoute] = []
    
    func view() -> some View {
        return FirstTabCoordinatorView()
            .environment(\.FirstTabCoordinator, self)
    }
}
