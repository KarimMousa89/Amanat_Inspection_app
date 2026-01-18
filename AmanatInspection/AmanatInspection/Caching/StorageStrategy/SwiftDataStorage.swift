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
    
    func get<T>(_ type: T.Type?, idOrKey: String?) -> [T]? { return nil }
    func get<T>(_ type: T.Type?, idOrKey: String?) -> [T]? where T: Decodable{
        if let type,
           var entities = getEntities(type: GenericEntity.self, predicate: #Predicate {idOrKey == nil || $0.key == idOrKey!}),
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
        if let entities = getEntities(type: type, predicate: #Predicate { idOrKey == nil || $0.id.uuidString == idOrKey!}),
           !entities.isEmpty {
            
            if entities.count > 1,
               let idOrKey,
               let match = entities.first(where: { "\($0.id)" == idOrKey }) {
                return [match] as? [T]
            }
            return entities
        }
        return nil
    }
    
    func remove<T>(_ type: T.Type?, idOrKey: String?) {}
    func remove<T>(_ type: T.Type?, idOrKey: String?) where T: Decodable{
        if let entities = getEntities(type: GenericEntity.self, predicate: #Predicate { idOrKey == nil || $0.key == idOrKey!}),
                  !entities.isEmpty {
            entities.forEach { context.delete($0) }
        }
    }
    func remove<T>(_ type: T.Type?, idOrKey: String?) where T: DomainType{
        if let type,
           let entities: [T] = getEntities(type: type, idOrKey: idOrKey),
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
    
    func getEntities<T>(type: T.Type, idOrKey: String?) -> [T]? where T: DomainType{
        let descriptor = FetchDescriptor<T>(predicate:  #Predicate { idOrKey == nil || $0.id.uuidString == idOrKey!})
        return try? context.fetch(descriptor)
    }
}
