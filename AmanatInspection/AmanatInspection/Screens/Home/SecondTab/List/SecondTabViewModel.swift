//
//  SecondTabViewModel.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import Foundation

struct User: Identifiable, Hashable {
    var id = UUID().uuidString
    let name: String
}

@MainActor
protocol SecondTabViewModel {
    var coordinator: (AnyNavigationModalCoordinator<SecondTabRoute>)? { get set }
    var users: [String: [User]] { get set }
    func fetchUsers() async
    func addNewUser()
}

@MainActor @Observable
class SecondTabViewModelImpl: SecondTabViewModel {
    var coordinator: (AnyNavigationModalCoordinator<SecondTabRoute>)? = nil
    var users: [String: [User]] = [:]
    
    func fetchUsers() async {
        do{
            try await Task.sleep(nanoseconds: 2_000_000_000)
        } catch {
        }
        self.users = ["K": [User(name: "Kamal"), User(id: "5", name: "Karim"), User(name: "Karam")],
                      "Z": [User(id: "12", name: "Zozo"), User(name: "Zeinab"), User(name: "Zalabya")],
                      "M": [User(name: "Marwa"), User(name: "Mero"), User(id: "8", name: "Muhamed")],
                      "N": [User(name: "Marwa"), User(name: "Mero"), User(name: "Muhamed")],
                      "R": [User(name: "Marwa"), User(name: "Mero"), User(name: "Muhamed")],
                      "O": [User(name: "Marwa"), User(name: "Mero"), User(name: "Muhamed")],
                      "P": [User(name: "Marwa"), User(name: "Mero"), User(name: "Muhamed")],
                      "A": [User(name: "Marwa"), User(name: "Mero"), User(name: "Muhamed")],
                      "B": [User(name: "Marwa"), User(name: "Mero"), User(name: "Muhamed")],
                      "C": [User(name: "Marwa"), User(name: "Mero"), User(name: "Muhamed")],
                      "D": [User(name: "Marwa"), User(name: "Mero"), User(name: "Muhamed")],
                      "E": [User(name: "Marwa"), User(name: "Mero"), User(name: "Muhamed")],
                      "F": [User(name: "Marwa"), User(name: "Mero"), User(name: "Muhamed")]]
    }
    
    func addNewUser() {
        let loginCoordinator = LoginCoordinator(navigator: self, visitorAllowed: false)
        coordinator?.presentModal(SecondTabRoute.addUser(coordinator: loginCoordinator))
    }
}

extension SecondTabViewModelImpl: @MainActor LoginNavigating {
    func loginDidSuccess() {
        coordinator?.dismissModal()
    }
}
