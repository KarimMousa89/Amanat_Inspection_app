//
//  SwiftDataUnifiedStorage.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 17/01/2026.
//

import Foundation
import SwiftData

class SwiftDataStorage: StorageStrategy{
    typealias DomainType = PersistentModel&DomainConvertible
    
    private let context: ModelContext
    private let domainTypes: [any DomainType.Type]
    
    init(context: ModelContext, domainTypes: [any DomainType.Type]) {
        self.context = context
        self.domainTypes = domainTypes
    }

    func save<T>(_ value: T, idOrKey: String?) {}
    func save<T>(_ value: T, idOrKey: String?) where T: Codable {
        guard let idOrKey,
              let data = try? JSONEncoder().encode(value) else { return }
        if let entity = getEntities(type: GenericEntity.self, predicate: #Predicate { $0.id == idOrKey })?.first {
            entity.data = data
        } else {
            let entity = GenericEntity(id: idOrKey, data: data)
            context.insert(entity)
        }
    }
    func save<T>(_ value: T, idOrKey: String?) where T: EntityConvertable {
        context.insert(value.makeEntity())
    }
    
    func get<T>(_ type: T.Type, idOrKey: String?) -> [T]? { return nil }
    func get<T>(_ type: T.Type, idOrKey: String?) -> [T]? where T: Decodable{
        var predicate: Predicate<GenericEntity>? = nil
        if let idOrKey {
            predicate = #Predicate {$0.id == idOrKey}
        }
        if var entities = getEntities(type: GenericEntity.self, predicate: predicate),
           !entities.isEmpty {
            
            if entities.count > 1,
               let idOrKey,
               let match = entities.first(where: { "\($0.id)" == idOrKey }){
                entities = [match]
            }
            
            let result: [T] = entities.compactMap(\.data).compactMap({ try? JSONDecoder().decode(type, from: $0) })
            return result
        }
        return nil
    }
    func get<T>(_ type: T.Type, idOrKey: String?) -> [T]? where T: DomainType {
        var predicate: Predicate<T>? = nil
        if let idOrKey {
            predicate = #Predicate { $0.id.uuidString == idOrKey}
        }
        if var entities = getEntities(type: type, predicate: predicate),
           !entities.isEmpty {
            
            if entities.count > 1,
               let idOrKey,
               let match = entities.first(where: { "\($0.id)" == idOrKey }) {
                entities = [match]
            }
            return entities.map({ $0.toDomain() as! T}) 
        }
        return nil
    }
    
    func remove<T>(_ type: T.Type?, idOrKey: String?) {}
    func remove<T>(_ type: T.Type?, idOrKey: String?) where T: Decodable{
        var predicate: Predicate<GenericEntity>? = nil
        if let idOrKey {
            predicate = #Predicate { $0.id == idOrKey}
        }
        if let entities = getEntities(type: GenericEntity.self, predicate: predicate),
                  !entities.isEmpty {
            entities.forEach { context.delete($0) }
        }
    }
    func remove<T>(_ type: T.Type?, idOrKey: String?) where T: DomainType{
        var predicate: Predicate<T>? = nil
        if let idOrKey {
            predicate = #Predicate { $0.id.uuidString == idOrKey}
        }
        if let type,
           let entities: [T] = getEntities(type: type, predicate: predicate),
           !entities.isEmpty {
            entities.forEach { context.delete($0) }
        }
    }
    
    func clearAll() {
        if let entities = getEntities(type: GenericEntity.self),
           !entities.isEmpty {
            entities.forEach { context.delete($0) }
        }

        domainTypes.forEach { type in
            if let entities = getEntities(type: type),
               !entities.isEmpty {
                entities.forEach { context.delete($0) }
            }
        }
    }
}

private extension SwiftDataStorage {
    func getEntities<T: PersistentModel>(type: T.Type, predicate: Predicate<T>? = nil) -> [T]? {
        let descriptor = FetchDescriptor<T>(predicate: predicate)
        return try? context.fetch(descriptor)
    }
    
//    func getEntities<T>(type: T.Type, idOrKey: String?) -> [T]? where T: DomainType{
//        let descriptor = FetchDescriptor<T>(predicate:  #Predicate { idOrKey == nil || $0.id.uuidString == idOrKey!})
//        return try? context.fetch(descriptor)
//    }
}
