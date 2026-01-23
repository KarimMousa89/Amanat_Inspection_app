//
//  SwiftDataUnifiedStorage.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 17/01/2026.
//

import Foundation
import SwiftData

/// background thread actor that owns ModelContext and safes it from data races,
/// You can have many actors sharing the same container, so use main actor context for UI, and model actor context for heave background work
/// ModelContext (insert, save, delete, fetch, all database operations) is not thread safe, but ModelContainer (database itself, contains the schema of the database, models and how they are linked to each others) is thread safe, models that are in relationship should exist in the same database (container)
@ModelActor
actor SwiftDataStorage{
    private var supportedEntitiesTypes: [any EntityWithDomainConvertible.Type] = []
    
    private init(container: ModelContainer) {
        self.init(modelContainer: container)
    }

    private func configure(supportedEntities: [any EntityWithDomainConvertible.Type]) {
        self.supportedEntitiesTypes = supportedEntities
    }
    
    static func make(domainTypes: [any DomainWithEntityConvertable.Type]) async -> SwiftDataStorage? {
        // Derive sendable metatype arrays outside the actor
        let entityTypes: [any EntityWithDomainConvertible.Type] = domainTypes.map { $0.entityType }
        var models: [any PersistentModel.Type] = entityTypes.map { $0 as any PersistentModel.Type }
        models.append(GenericEntity.self)
        let schema = Schema(models)
        let config = ModelConfiguration("AppData", schema: schema)
        var container:ModelContainer
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch  {
            print("SwiftDataStorage init Error: \(error)")
            return nil
        }
        let storage = SwiftDataStorage(container: container)
        await storage.configure(supportedEntities: entityTypes)
        return storage
    }
}

extension SwiftDataStorage: StorageStrategy {
    func save<T>(_ value: T, idOrKey: String?) async where T : Sendable {
        if let value = value as? any DomainWithEntityConvertable {
            saveModel(value, idOrKey: idOrKey)
        } else if let value = value as? any Codable {
            savePrimitive(value, idOrKey: idOrKey)
        } else {
            print("Empty Save")
        }
    }
    
    func get<T>(_ type: T.Type, idOrKey: String?) async -> [T]? where T : Sendable {
        if let domainConvertibleType = type as? any DomainWithEntityConvertable.Type {
            return getModel(domainConvertibleType, idOrKey: idOrKey) as? [T]
        } else if let decodableType = type as? any Decodable.Type {
            return getPrimitive(decodableType, idOrKey: idOrKey) as? [T]
        } else {
            print("Empty get")
        }
        return nil
    }
    
    func remove<T>(_ type: T.Type?, idOrKey: String?) async {
        if let domainConvertibleType = type as? any DomainWithEntityConvertable.Type {
            removeModel(domainConvertibleType, idOrKey: idOrKey)
        } else if let decodableType = type as? any Decodable.Type {
            removePrimitive(decodableType, idOrKey: idOrKey)
        } else {
            print("Empty remove")
        }
    }
    
    func clearAll() async {
        if let entities = getEntities(type: GenericEntity.self),
           !entities.isEmpty {
            entities.forEach { modelContext.delete($0) }
        }
        
        supportedEntitiesTypes.forEach { type in
            if let entities = getEntities(type: type),
               !entities.isEmpty {
                entities.forEach { modelContext.delete($0) }
            }
        }
        try? modelContext.save()
    }
}

private extension SwiftDataStorage {
    func getEntities<T: PersistentModel>(type: T.Type, predicate: Predicate<T>? = nil) -> [T]? {
        let descriptor = FetchDescriptor<T>(predicate: predicate)
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Get error \(error)")
        }
        return nil
    }
    
    //MARK: Save
    func saveModel<T: DomainWithEntityConvertable>(_ value: T, idOrKey: String?) {
        modelContext.insert(value.makeEntity())
        do {
            try modelContext.save()
        } catch {
            print("Saving Error \(error)")
        }
    }
    
    func savePrimitive<T: Codable>(_ value: T, idOrKey: String?) {
        guard let idOrKey,
              let data = try? JSONEncoder().encode(value) else { return }
        if let entity = getEntities(type: GenericEntity.self, predicate: #Predicate { $0.id == idOrKey })?.first {
            entity.data = data
        } else {
            let entity = GenericEntity(id: idOrKey, data: data)
            modelContext.insert(entity)
        }
        do {
            try modelContext.save()
        } catch  {
            print("Save Error \(error)")
        }
    }
    //MARK: Get
    func getModel<T: DomainWithEntityConvertable>(_ type: T.Type, idOrKey: String?) -> [T.UnderlyingEntity.Domain]? {
        var predicate: Predicate<T.UnderlyingEntity>? = nil
        if let idOrKey {
            predicate = #Predicate { $0.id == idOrKey}
        }
        if var entities = getEntities(type: type.entityType, predicate: predicate),
           !entities.isEmpty {
            
            if entities.count > 1,
               let idOrKey,
               let match = entities.first(where: { "\($0.id)" == idOrKey }) {
                entities = [match]
            }
            return entities.map({ $0.toDomain() })
        }
        return nil
    }
    
    func getPrimitive<T: Decodable>(_ type: T.Type, idOrKey: String?) -> [T]? {
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
    //MARK: Remove
    func removeModel<T: DomainWithEntityConvertable>(_ type: T.Type?, idOrKey: String?){
        var predicate: Predicate<T.UnderlyingEntity>? = nil
        if let idOrKey {
            predicate = #Predicate { $0.id == idOrKey}
        }
        if let type,
           let entities = getEntities(type: type.UnderlyingEntity, predicate: predicate),
           !entities.isEmpty {
            entities.forEach { modelContext.delete($0) }
            try? modelContext.save()
        }
    }
    
    func removePrimitive<T: Decodable>(_ type: T.Type?, idOrKey: String?){
        var predicate: Predicate<GenericEntity>? = nil
        if let idOrKey {
            predicate = #Predicate { $0.id == idOrKey}
        }
        if let entities = getEntities(type: GenericEntity.self, predicate: predicate),
                  !entities.isEmpty {
            entities.forEach { modelContext.delete($0) }
            try? modelContext.save()
        }
    }
}

