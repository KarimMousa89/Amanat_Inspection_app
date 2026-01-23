//
//  SecondTabViewModel.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import Foundation
import SwiftData

struct User: Identifiable, Hashable {
    var id: String
    let name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
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
            self.users = ["K": [User(id: "1", name: "Kamal"), User(id: "5", name: "Karim"), User(id: "1", name: "Karam")],
                          "Z": [User(id: "12", name: "Zozo"), User(id: "1", name: "Zeinab"), User(id: "1", name: "Zalabya")],
                          "M": [User(id: "1", name: "Marwa"), User(id: "1", name: "Mero"), User(id: "8", name: "Muhamed")],
                          "N": [User(id: "1", name: "Marwa"), User(id: "1", name: "Mero"), User(id: "1", name: "Muhamed")],
                          "R": [User(id: "1", name: "Marwa"), User(id: "1", name: "Mero"), User(id: "1", name: "Muhamed")],
                          "O": [User(id: "1", name: "Marwa"), User(id: "1", name: "Mero"), User(id: "1", name: "Muhamed")],
                          "P": [User(id: "1", name: "Marwa"), User(id: "1", name: "Mero"), User(id: "1", name: "Muhamed")],
                          "A": [User(id: "1", name: "Marwa"), User(id: "1", name: "Mero"), User(id: "1", name: "Muhamed")],
                          "B": [User(id: "1", name: "Marwa"), User(id: "1", name: "Mero"), User(id: "1", name: "Muhamed")],
                          "C": [User(id: "1", name: "Marwa"), User(id: "1", name: "Mero"), User(id: "1", name: "Muhamed")],
                          "D": [User(id: "1", name: "Marwa"), User(id: "1", name: "Mero"), User(id: "1", name: "Muhamed")],
                          "E": [User(id: "1", name: "Marwa"), User(id: "1", name: "Mero"), User(id: "1", name: "Muhamed")],
                          "F": [User(id: "1", name: "Marwa"), User(id: "1", name: "Mero"), User(id: "1", name: "Muhamed")]]
            
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
