//
//  LoginCoordinator.swift
//  FifthDemo
//
//  Created by Karim Mousa on 08/07/2025.
//

import Foundation
import SwiftUI

enum ForgetPasswordRoute: Identifiable, Hashable {
    case emailVerification(viewModel: ForgetPasswordEmailViewModelImpl)
    case setNew(viewModel: ForgetPasswordSetNewViewModelImpl)
    
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
    case login(viewModel: LoginViewModelImpl)
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
        case .login(viewModel: let viewModel):
            LoginView(viewModel: viewModel)
        case .forgetPasswordPath(let forgetPasswordRoute):
            switch forgetPasswordRoute {
            case .emailVerification(viewModel: let viewModel):
                ForgetPasswordEmailView(viewModel: viewModel)
            case .setNew(viewModel: let viewModel):
                ForgetPasswordSetNewView(viewModel: viewModel)
            }
        case .signup:
            Text("Signup")
        }
    }
}

//@MainActor
final class LoginSuccessHandler: ObservableObject {
    var onLoginSuccess: (() -> Void)?
}

@MainActor
class LoginCoordinator: Coordinator, NavigationCoordinator, ModalCoordinator {
    private var loginSuccessHandler = LoginSuccessHandler()
    init(onloginSuccess: @escaping (() -> Void)) {
        loginSuccessHandler.onLoginSuccess = onloginSuccess
    }
    
    var onPathChange: ((NavigationPath) -> Void)?
    var navPath = NavigationPath() {
        didSet {
            onPathChange?(navPath)
        }
    }
    
    var onModalChange: ((LoginRoute?) -> Void)?
    var modalScene: LoginRoute?{
        didSet {
            onModalChange?(modalScene)
        }
    }
    
    func view() -> some View {
        print("LoginCoordinator.view")
        return LoginCoordinatorView()
            .environmentObject(self)
            .environmentObject(loginSuccessHandler)
    }
}

struct LoginCoordinatorView: View {
    @EnvironmentObject var coordinator: LoginCoordinator
    @State private var navPath = NavigationPath() // Local state
    @State private var modalScene: LoginRoute?
    
    var body: some View {
        NavigationStack(path: $navPath) {
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
        .sheet(item: $modalScene) { modal in
            LoginRouter.view(for: modal)
        }
        .onLoad {
            coordinator.onPathChange = { newPath in
                navPath = newPath
            }
            
            coordinator.onModalChange = { modal in
                modalScene = modal
            }
        }
    }
}

