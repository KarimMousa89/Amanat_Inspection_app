//
//  NewCachingManager.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 17/01/2026.
//

import Foundation

actor NewCachingManager {
    private let storage: any StorageStrategy
    
    init(storage: any StorageStrategy) {
        self.storage = storage
    }
}

extension NewCachingManager: StorageStrategy {
    func save<T>(_ value: T, idOrKey: String?) async where T : Sendable {
        await storage.save(value, idOrKey: idOrKey)
    }
    
    func get<T>(_ type: T.Type, idOrKey: String?) async -> [T]? where T : Sendable {
        await storage.get(type, idOrKey: idOrKey)
    }
    
    func remove<T>(_ type: T.Type?, idOrKey: String?) async {
        await storage.remove(type, idOrKey: idOrKey)
    }
    
    func clearAll() async {
        await storage.clearAll()
    }
}

//extension NewCachingManager: @preconcurrency StorageStrategy {}
