//
//  UserEntity.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 19/01/2026.
//

import Foundation
import SwiftData

extension User: DomainWithEntityConvertable {
    typealias UnderlyingEntity = UserEntity
    
    static var entityType: UserEntity.Type {
        UnderlyingEntity.self
    }
    
    func makeEntity() -> UnderlyingEntity {
        UserEntity(id: id, name: name)
    }
}

@Model
final class UserEntity {
    typealias Domain = User
    
    @Attribute(.unique) var id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

extension UserEntity: EntityWithDomainConvertible {
    func toDomain() -> User {
        return User(id: id, name: name)
    }
}
