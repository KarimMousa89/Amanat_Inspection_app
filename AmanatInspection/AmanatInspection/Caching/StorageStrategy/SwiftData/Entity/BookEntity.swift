//
//  BookEntity.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 20/01/2026.
//

import Foundation
import SwiftData

extension Book: DomainWithEntityConvertable {
    typealias UnderlyingEntity = BookEntity
    
    static var entityType: UnderlyingEntity.Type {
        UnderlyingEntity.self
    }
    
    func makeEntity() -> UnderlyingEntity {
        BookEntity(id: id, name: title)
    }
}

@Model
final class BookEntity {
    typealias Domain = Book
    
    @Attribute(.unique) var id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

extension BookEntity: EntityWithDomainConvertible {
    func toDomain() -> Book {
        return Book(id: id, title: name)
    }
}
