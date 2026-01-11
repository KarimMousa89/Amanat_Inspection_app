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

typealias LoginCoordinating = Coordinator&NavigationCoordinator&ModalCoordinator

extension LoginCoordinator: LoginCoordinating {
    func view() -> some View {
        print("LoginCoordinator.view")
        return LoginCoordinatorView()
            .environment(\.loginCoordinator, AnyLoginCoordinator(self))
            .environment(\.loginNavigator, navigator)
    }
}

@MainActor @Observable
final class AnyLoginCoordinator: LoginCoordinating {
    
    // This is the concrete type the View will bind to.
    // It is NOT generic.
    
    // 1. The internal, type-erased storage box.
    @MainActor
    private class AnyCoordinatorBox {
        // We define the properties and methods we need to access.
        // These are abstract and will be implemented by a generic subclass.
        var navPath: [LoginRoute] { get { fatalError() } set { fatalError() } }
        var modalScene: LoginRoute? { get { fatalError() } set { fatalError() } }
        func view() -> AnyView { fatalError() }
    }

    // 2. A generic subclass of the box that captures the concrete coordinator type.
    @MainActor
    private class CoordinatorBox<C: LoginCoordinating>: AnyCoordinatorBox where C.Route == LoginRoute {
        private let wrapped: C // Holds the REAL coordinator (e.g., LoginCoordinator or MockLoginCoordinator)

        init(_ coordinator: C) {
            self.wrapped = coordinator
        }

        override var navPath: [LoginRoute] {
            get { wrapped.navPath }
            set { wrapped.navPath = newValue }
        }

        override var modalScene: LoginRoute? {
            get { wrapped.modalScene }
            set { wrapped.modalScene = newValue }
        }

        override func view() -> AnyView {
            // Here is the single, justified use of AnyView.
            // It's used to erase the ViewType of the wrapped coordinator.
            return AnyView(wrapped.view())
        }
    }

    private let box: AnyCoordinatorBox

    init<C: LoginCoordinating>(_ coordinator: C) where C.Route == LoginRoute {
        self.box = CoordinatorBox(coordinator)
    }

    var navPath: [LoginRoute] {
        get { box.navPath }
        set { box.navPath = newValue }
    }

    var modalScene: LoginRoute? {
        get { box.modalScene }
        set { box.modalScene = newValue }
    }

    func view() -> some View {
        box.view()
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

