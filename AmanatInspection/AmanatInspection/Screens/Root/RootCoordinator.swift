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
//    case home(coordinator: HomeCoordinator)
    
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
//        case .home: return "home"
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
//        case .home(let coordinator):
//            coordinator.view()
        case .login(let coordinator):
            coordinator.view()
        }
    }
}

@MainActor
protocol RootCoordinating: Coordinator {
    var rootScene: AppRoute { get }
    func handleURLComponents(_ components: URLComponents) async
    func handleJailbrokenDevice()
    func resetToSplash()
    func resetToLogin()
    func resetToHome()
}

//TODO: check main actor
@MainActor @Observable
final class RootCoordinator {
    private(set) var rootScene: AppRoute = .jailbroken
    
//    private var homeCoordinator: HomeCoordinator?
    private var loginCoordinator: LoginCoordinator?
    
    init() {
        print(">>> RootCoordinator.init at \(Date())")
        resetToSplash()
    }
}

extension RootCoordinator: RootCoordinating {
    func view() -> some View {
        print("RootCoordinator.view at \(Date()) \(String(describing: rootScene))") // Debug
        return RootCoordinatorView()
    }
    
    func handleURLComponents(_ components: URLComponents) async {
//        let action = components.host
//        switch action {
//        case "showUser":
//            NSLog("KK:: Home related action!")
//            await homeCoordinator?.handleURLComponents(components)
//        default:
//            NSLog("KK:: Unknown URL action: \(String(describing: action))")
//        }
    }
    
    func handleJailbrokenDevice() {
        rootScene = .jailbroken
    }
    
    func resetToSplash() {
        NSLog("KK:: reset to splash")
//        homeCoordinator = nil
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
        NSLog("KK:: reset to login")
//        homeCoordinator = nil
        loginCoordinator = LoginCoordinator {
            self.resetToHome()
        }
        if let loginCoordinator {
            rootScene = .login(coordinator: loginCoordinator)
        }
    }
    
    func resetToHome() {
        NSLog("KK:: reset to home")
//        loginCoordinator = nil
//        homeCoordinator = HomeCoordinator {
//            self.resetToLogin()
//        }
//        if let homeCoordinator {
//            rootScene = .home(coordinator: homeCoordinator)
//        }
    }
}

struct RootCoordinatorView: View {
    @Environment(\.rootCoordinator) private var coordinator: any RootCoordinating
    
    var body: some View {
        AppRouter.view(for: coordinator.rootScene)
    }
}
