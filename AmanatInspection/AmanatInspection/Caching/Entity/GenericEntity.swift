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
    @Attribute(.unique) var key: String
    var data: Data
    
    init(key: String, data: Data) {
        self.key = key
        self.data = data
    }
}
