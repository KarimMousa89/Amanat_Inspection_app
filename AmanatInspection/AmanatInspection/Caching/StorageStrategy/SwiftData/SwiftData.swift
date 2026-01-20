//
//  SwiftData.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 19/01/2026.
//

import Foundation
import SwiftData
/// PersistentModel
protocol DomainConvertible {
    associatedtype Domain
    var id: UUID { get }
    func toDomain() -> Domain
}
/// Domain
protocol EntityConvertable {
    func makeEntity() -> any PersistentModel
}
