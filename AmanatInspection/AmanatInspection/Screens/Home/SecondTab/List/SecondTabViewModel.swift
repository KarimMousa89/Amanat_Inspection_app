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
protocol SecondTabViewModel: ObservableObject {
    var users: [String: [User]] { get set }
    func fetchUsers() async
    func selectUserId(_ id: String, completion: @escaping (User) -> Void)
}

@MainActor
class SecondTabViewModelImpl: SecondTabViewModel {
    @Published var users: [String: [User]] = [:]
    private var pendingSelectedUserId: String?
    private var pendingSelectedUserIdCompletion: ((User) -> Void)?
    
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
            
            if let pendingSelectedUserId = self.pendingSelectedUserId,
               let completion = self.pendingSelectedUserIdCompletion {
                self.selectUserId(pendingSelectedUserId, completion: completion)
            }
        
    }
    
    func selectUserId(_ id: String, completion: @escaping (User) -> Void) {
        if users.isEmpty {
            pendingSelectedUserId = id
            pendingSelectedUserIdCompletion = completion
        } else {
            let matchedUsers = users.values.flatMap({$0}).filter({$0.id == id})
            if let selectedUser = matchedUsers.first {
                completion(selectedUser)
            }
            pendingSelectedUserId = nil
            pendingSelectedUserIdCompletion = nil
        }
    }
}
