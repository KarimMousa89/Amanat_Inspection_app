//
//  EntityConvertible.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 17/01/2026.
//

import Foundation
import SwiftData

protocol DomainConvertible {
    associatedtype Domain
    var id: UUID { get }
    func toDomain() -> Domain
}
