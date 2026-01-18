//
//  SwiftDataUnifiedStorage.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 17/01/2026.
//

import Foundation
import SwiftData

class SwiftDataStorage: StorageStrategy {
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }

    func save<T>(_ value: T, idOrKey: String?) {
        if let domain = value as? any EntityConvertable {
            // DomainModel -> use Entity
            context.insert(domain.makeEntity())
        } else if let codable = value as? Codable {
            // Primitive / Codable -> GenericEntity
            guard let key = idOrKey,
                  let data = try? JSONEncoder().encode(codable) else { return }
            if let entity = getEntities(type: GenericEntity.self, predicate: #Predicate { $0.key == key })?.first {
                entity.data = data
            } else {
                let entity = GenericEntity(key: key, data: data)
                context.insert(entity)
            }
        } else {
            debugPrint("Type \(T.self) is not supported")
        }
    }
    
    func get<T>(_ type: T.Type?, idOrKey: String?) -> [T]? {
        if let domainType = type as? (any DomainConvertible.Type),
           let entities = getEntities(type: domainType, predicate: #Predicate { idOrKey == nil || $0.id.uuidString == idOrKey!}),
           !entities.isEmpty {
            
            if entities.count > 1,
               let idOrKey,
               let match = entities.first(where: { "\($0.id)" == idOrKey }) {
                return [match] as? [T]
            }
            return entities as? [T]
        } else if let decodableType = type as? Decodable.Type,
                  var entities = getEntities(type: GenericEntity.self, predicate: #Predicate {idOrKey == nil || $0.key == idOrKey!}),
                          !entities.isEmpty {
            
            if entities.count > 1,
               let idOrKey,
                let match = entities.first(where: { "\($0.id)" == idOrKey }){
                entities = [match]
            }
            
            let result: [T] = entities.compactMap(\.data).compactMap({ try? JSONDecoder().decode(decodableType, from: $0) as? T })
            return result
        }
        return nil
    }
    
    func remove<T>(_ value: T?, idOrKey: String?) {
        if let domainType = value as? (any DomainConvertible.Type),
           let entities = getEntities(type: domainType, predicate: #Predicate { idOrKey == nil || $0.id.uuidString == idOrKey!}),
           !entities.isEmpty {
            entities.forEach { context.delete($0) }
        } else if let entities = getEntities(type: GenericEntity.self, predicate: #Predicate { idOrKey == nil || $0.key == idOrKey!}),
                  !entities.isEmpty {
            entities.forEach { context.delete($0) }
        }
    }
    
    func clearAll() {
        if let entities = getEntities(type: GenericEntity.self),
           !entities.isEmpty {
            entities.forEach { context.delete($0) }

        }
        // TODO: Optionally clear all DomainModels if needed
    }
}

private extension SwiftDataStorage {
    func getEntities<T: PersistentModel>(type: T.Type, predicate: Predicate<T>? = nil) -> [T]? {
        let descriptor = FetchDescriptor<T>(predicate: predicate)
        return try? context.fetch(descriptor)
    }
}
