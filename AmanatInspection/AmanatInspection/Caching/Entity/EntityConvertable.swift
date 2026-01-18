//
//  DomainModel.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 17/01/2026.
//

import Foundation
import SwiftData

protocol EntityConvertable {
    func makeEntity() -> any PersistentModel
}
