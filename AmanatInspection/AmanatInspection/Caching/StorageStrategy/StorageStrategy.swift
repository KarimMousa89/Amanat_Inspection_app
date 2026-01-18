//
//  StorageStrategy.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 17/01/2026.
//

import Foundation

protocol StorageStrategy {
    func save<T>(_ value: T, idOrKey: String?) //TODO: return bool or throw if wrong inpute
    func get<T>(_ type: T.Type?, idOrKey: String?) -> [T]? //TODO: throw if wrong inpute
    func remove<T>(_ type: T.Type?, idOrKey: String?)
    func clearAll()
}
