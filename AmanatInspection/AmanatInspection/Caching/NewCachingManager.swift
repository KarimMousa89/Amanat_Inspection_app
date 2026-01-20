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
    
    func save<T>(_ value: T, idOrKey: String?) {
        storage.save(value, idOrKey: idOrKey)
    }
    
    func get<T>(_ type: T.Type, idOrKey: String?) -> [T]? {
        storage.get(type, idOrKey: idOrKey)
    }
    
    func remove<T>(_ value: T?, idOrKey: String?) {
        storage.remove(type(of: value), idOrKey: idOrKey)
    }
    
    func clearAll() {
        storage.clearAll()
    }
}

//extension NewCachingManager: @preconcurrency StorageStrategy {}
