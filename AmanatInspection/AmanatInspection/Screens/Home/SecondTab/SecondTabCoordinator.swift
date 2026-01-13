//
//  SecondTabCoordinator.swift
//  FifthDemo
//
//  Created by Karim Mousa on 10/07/2025.
//

import Foundation
import SwiftUI

enum SecondTabRoute: Identifiable, Hashable {
    case list(makeViewModel: () -> SecondTabViewModelImpl)
    case details(makeViewModel: () -> SecondTabDetailsViewModelImpl)
    case addUser(coordinator: LoginCoordinator)
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: SecondTabRoute, rhs: SecondTabRoute) -> Bool {
        lhs.id == rhs.id
    }
    var id: String {
        switch self {
        case .list: return "list"
        case .details: return "details"
        case .addUser: return "addUser"
        }
    }
}

struct SecondTabRouter {
    @MainActor @ViewBuilder
    static func view(for route: SecondTabRoute) -> some View {
        switch route {
        case .list(let makeViewModel):
            SecondTabView(makeViewModel: makeViewModel)
        case .details(let makeViewModel):
            SecondTabDetailsView(makeViewModel: makeViewModel)
        case .addUser(coordinator: let coordinator):
            coordinator.view()
        }
    }
}

@MainActor @Observable
class SecondTabCoordinator {
    typealias Route = SecondTabRoute
    var navPath: [Route] = []
    var modalScene: Route? = nil
}

extension SecondTabCoordinator: NavigationModalCoordinating {
    func view() -> some View {
        return SecondTabCoordinatorView()
            .environment(\.secondTabCoordinator, AnyNavigationModalCoordinator(self))
    }
    
    func handleURLComponents(_ components: URLComponents){
        let action = components.host
        switch action {
        case "showUser":
            NSLog("KK:: User details action!")
            guard let userId = components.queryItems?.first(where: { $0.name == "userId" })?.value else {
                NSLog("KK:: User Id not found")
                return
            }
            
            guard let model = SecondTabDetailsViewModelImpl(userId: userId) else { return }
            push( SecondTabRoute.details(makeViewModel: {
                model
            }))
        default:
            NSLog("KK:: Unknown URL action: \(String(describing: action))")
        }
    }
}

struct SecondTabCoordinatorView: View {
    @Environment(\.secondTabCoordinator) var coordinator
    
    var body: some View {
        @Bindable var coordinator = coordinator
        NavigationStack(path: $coordinator.navPath) {
            SecondTabRouter.view(for: .list(makeViewModel: { SecondTabViewModelImpl() }))
                .navigationDestination(for: SecondTabRoute.self) { route in
                    SecondTabRouter.view(for: route)
                        .navigationBarBackButtonHidden(true)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    coordinator.pop()
                                    // TODO: what if more actions needed here. for example show the tabbar ??? => handle in view on disappear modifier
                                } label: {
                                    HStack {
                                        Image(systemName: "chevron.backward")
                                        Text("Back") // Force English text
                                    }
                                }
                            }
                        }
                }
        }
        .sheet(item: $coordinator.modalScene) { modal in
            SecondTabRouter.view(for: modal)
        }
    }
}
