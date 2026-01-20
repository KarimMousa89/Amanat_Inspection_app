//
//  GenericEntity.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 17/01/2026.
//

import Foundation
import SwiftData

@Model
final class GenericEntity {
    @Attribute(.unique) var id: String
    var data: Data
    
    init(id: String, data: Data) {
        self.id = id
        self.data = data
    }
}
