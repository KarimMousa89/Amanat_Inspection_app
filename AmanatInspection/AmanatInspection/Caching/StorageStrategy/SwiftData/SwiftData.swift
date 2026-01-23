//
//  SwiftData.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 19/01/2026.
//

import Foundation
import SwiftData
/// PersistentModel
protocol EntityWithDomainConvertible: PersistentModel {
    associatedtype Domain
    var id: String { get }
    func toDomain() -> Domain
}

/// Domain
protocol DomainWithEntityConvertable {
    associatedtype UnderlyingEntity: EntityWithDomainConvertible
        where UnderlyingEntity.Domain == Self

    static var entityType: UnderlyingEntity.Type { get }
    func makeEntity() -> UnderlyingEntity
}
