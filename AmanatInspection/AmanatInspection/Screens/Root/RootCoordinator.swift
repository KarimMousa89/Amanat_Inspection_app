//
//  AppCoordinator.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import Foundation
import SwiftUI

enum AppRoute: Identifiable, Hashable {
    case jailbroken
    case splash(viewModel: SplashViewModelImpl)
    case login(coordinator: LoginCoordinator)
    case home(coordinator: HomeCoordinator)
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String {
        switch self {
        case .jailbroken: return "Jailbroken"
        case .splash: return "splash"
        case .login: return "login"
        case .home: return "home"
        }
    }
}

struct AppRouter {
    @MainActor @ViewBuilder
    static func view(for route: AppRoute) -> some View {
        switch route {
        case .jailbroken:
            JailbrokenView()
        case .splash(viewModel: let viewModel):
            SplashView(viewModel: viewModel)
        case .home(let coordinator):
            coordinator.view()
        case .login(let coordinator):
            coordinator.view()
        }
    }
}

//TODO: check main actor
@MainActor
final class RootCoordinator: Coordinator {
    var onRootChange: ((AppRoute) -> Void)?
    private var rootScene: AppRoute! {
        willSet{
            onRootChange?(newValue)
        }
    }
    
    private var homeCoordinator: HomeCoordinator?
    private var loginCoordinator: LoginCoordinator?
    
    init() {
        print(">>> RootCoordinator.init at \(Date())")
        resetToSplash()
    }
    
    func handleJailbrokenDevice() {
        rootScene = .jailbroken
    }
    
    func view() -> some View {
        print("RootCoordinator.view at \(Date()) \(String(describing: rootScene))") // Debug
        return RootCoordinatorView(rootScene: rootScene)
            .environmentObject(self)
    }
    
    func handleURLComponents(_ components: URLComponents) async {
        let action = components.host
        switch action {
        case "showUser":
            NSLog("KK:: Home related action!")
            await homeCoordinator?.handleURLComponents(components)
        default:
            NSLog("KK:: Unknown URL action: \(String(describing: action))")
        }
    }
    
    func resetToSplash() {
        homeCoordinator = nil
        loginCoordinator = nil
        rootScene = .splash(viewModel: SplashViewModelImpl(onloadFinished: { userLoggedIn in
            if userLoggedIn {
                self.resetToHome()
            } else {
                self.resetToLogin()
            }
        }))
    }
    
    func resetToLogin() {
        homeCoordinator = nil
        loginCoordinator = LoginCoordinator {
            self.resetToHome()
        }
        if let loginCoordinator {
            rootScene = .login(coordinator: loginCoordinator)
        }
    }
    
    func resetToHome() {
        loginCoordinator = nil
        homeCoordinator = HomeCoordinator {
            self.resetToLogin()
        }
        if let homeCoordinator {
            rootScene = .home(coordinator: homeCoordinator)
        }
    }
}

struct RootCoordinatorView: View {
    @EnvironmentObject var coordinator: RootCoordinator
    @State var rootScene: AppRoute
    
    init(rootScene: AppRoute) {
        self.rootScene = rootScene
    }
    
    var body: some View {
        AppRouter.view(for: rootScene)
            .onLoad {
                coordinator.onRootChange = { newRoot in
                    rootScene = newRoot
                }
            }
    }
}
