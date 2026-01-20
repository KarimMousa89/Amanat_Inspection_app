//
//  UserEntity.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 19/01/2026.
//

import Foundation
import SwiftData

extension User: EntityConvertable {
    func makeEntity() -> any PersistentModel {
        UserEntity(id: UUID(uuidString: id) ?? UUID(), name: name)
    }
}

@Model
final class UserEntity {
    typealias Domain = User
    
    @Attribute(.unique) var id: UUID
    var name: String
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}

extension UserEntity: DomainConvertible {
    func toDomain() -> User {
        return User(id: id.uuidString, name: name)
    }
}
