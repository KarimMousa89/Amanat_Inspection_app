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
    case splash(makeViewModel: () -> SplashViewModelImpl)
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
        case .splash(let makeViewModel):
            SplashView(makeViewModel: makeViewModel)
        case .home(let coordinator):
            coordinator.view()
        case .login(let coordinator):
            coordinator.view()
        }
    }
}

@MainActor
protocol RootCoordinator: Coordinator {
    var rootScene: AppRoute { get }
}

//TODO: check main actor
@MainActor @Observable
final class AppRootCoordinatorImp {
    private(set) var rootScene: AppRoute = .jailbroken
    
    private var homeCoordinator: HomeCoordinator?
    private var loginCoordinator: LoginCoordinator?
    
    init() {
        print(">>> RootCoordinator.init at \(Date())")
        resetToSplash()
    }
    
    func handleJailbrokenDevice() {
        rootScene = .jailbroken
    }
    
    func resetToSplash() {
        NSLog("KK:: reset to splash")
        homeCoordinator = nil
        loginCoordinator = nil
        rootScene = .splash(makeViewModel: { SplashViewModelImpl(navigator: self) })
    }
    
    func resetToLogin() {
        NSLog("KK:: reset to login")
        homeCoordinator = nil
        loginCoordinator = LoginCoordinator(navigator: self)
        if let loginCoordinator {
            rootScene = .login(coordinator: loginCoordinator)
        }
    }
    
    func resetToHome() {
        NSLog("KK:: reset to home")
        loginCoordinator = nil
        homeCoordinator = HomeCoordinator(navigator: self)
        if let homeCoordinator {
            rootScene = .home(coordinator: homeCoordinator)
        }
    }
}

typealias RootCoordinating = RootCoordinator&URLComponentsHandler

extension AppRootCoordinatorImp: RootCoordinating {
    func view() -> some View {
        print("RootCoordinator.view at \(Date()) \(String(describing: rootScene))") // Debug
        return RootCoordinatorView()
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
}

extension AppRootCoordinatorImp: @MainActor SplashNavigating {
    func splashDidFinish(loggedIn: Bool) {
        loggedIn ? resetToHome() : resetToLogin()
    }
}

extension AppRootCoordinatorImp: @MainActor LoginNavigating {
    func loginDidSuccess() {
        resetToHome()
    }
}

extension AppRootCoordinatorImp: @MainActor HomeNavigating {
    func logoutDidSuccess() {
        resetToLogin()
    }
}

struct RootCoordinatorView: View {
    @Environment(\.rootCoordinator) private var coordinator
    
    var body: some View {
        AppRouter.view(for: coordinator.rootScene)
    }
}
