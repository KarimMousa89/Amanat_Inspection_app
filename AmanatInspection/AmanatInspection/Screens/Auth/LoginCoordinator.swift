//
//  LoginCoordinator.swift
//  FifthDemo
//
//  Created by Karim Mousa on 08/07/2025.
//

import Foundation
import SwiftUI

enum ForgetPasswordRoute: Identifiable, Hashable {
    case emailVerification(makeViewModel: () -> ForgetPasswordEmailViewModelImpl)
    case setNew(makeViewModel: () -> ForgetPasswordSetNewViewModelImpl)
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: ForgetPasswordRoute, rhs: ForgetPasswordRoute) -> Bool {
        lhs.id == rhs.id
    }
    var id: String {
        switch self {
        case .emailVerification: return "forgetPasswordEmailVerification"
        case .setNew: return "forgetPasswordSetNew"
        }
    }
}

enum LoginRoute: Identifiable, Hashable {
    case userSelection
    case login(makeViewModel: () -> LoginViewModelImpl)
    case forgetPasswordPath(_ route:ForgetPasswordRoute)
    case signup
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: LoginRoute, rhs: LoginRoute) -> Bool {
        lhs.id == rhs.id
    }
    var id: String {
        switch self {
        case .userSelection: return "userSelection"
        case .login: return "login"
        case .forgetPasswordPath: return "forgetPassword"
        case .signup: return "signup"
        }
    }
}

struct LoginRouter {
    @MainActor @ViewBuilder
    static func view(for route: LoginRoute) -> some View {
        switch route {
        case .userSelection:
            UserSelectionView()
        case .login(let makeViewModel):
            LoginView(makeViewModel: makeViewModel)
        case .forgetPasswordPath(let forgetPasswordRoute):
            switch forgetPasswordRoute {
            case .emailVerification(let makeViewModel):
                ForgetPasswordEmailView(makeViewModel: makeViewModel)
            case .setNew(let makeViewModel):
                ForgetPasswordSetNewView(makeViewModel: makeViewModel)
            }
        case .signup:
            Text("Signup")
        }
    }
}

protocol LoginNavigating {
    func loginDidSuccess()
}

@MainActor @Observable
class LoginCoordinator {
    typealias Route = LoginRoute
    var navPath: [Route] = []
    var modalScene: Route? = nil
    
    private var navigator: LoginNavigating
    init(navigator: LoginNavigating) {
        self.navigator = navigator
    }
}

extension LoginCoordinator: NavigationModalCoordinating {
    func view() -> some View {
        print("LoginCoordinator.view")
        return LoginCoordinatorView()
            .environment(\.loginCoordinator, AnyNavigationModalCoordinator(self))
            .environment(\.loginNavigator, navigator)
    }
}

struct LoginCoordinatorView: View {
    @Environment(\.loginCoordinator) private var coordinator
    
    var body: some View {
        @Bindable var coordinator = coordinator
        NavigationStack(path: $coordinator.navPath) {
            LoginRouter.view(for: .userSelection)
                .navigationDestination(for: LoginRoute.self) { route in
                    LoginRouter.view(for: route)
                    //                        .navigationBarBackButtonHidden(true)
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
        .sheet(item: $coordinator.modalScene) { modal in
            LoginRouter.view(for: modal)
        }
    }
}

