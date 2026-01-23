//
//  StorageStrategy.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 17/01/2026.
//

import Foundation

protocol StorageStrategy: Actor {
    func save<T: Sendable>(_ value: T, idOrKey: String?) async //TODO: return bool or throw if wrong inpute
    func get<T: Sendable>(_ type: T.Type, idOrKey: String?) async -> [T]? //TODO: throw if wrong inpute
    func remove<T>(_ type: T.Type?, idOrKey: String?) async
    func clearAll() async 
}
