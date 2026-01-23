////
////  FileCodableStorage.swift
////  AmanatInspection
////
////  Created by Karim Mousa on 17/01/2026.
////
//
//import Foundation
//
//class FileCodableStorage {
//    private let fileURL: URL
//    private var store: [String: Data] = [:]
//    
//    init(filename: String = "genericCache.json") {
//        let fm = FileManager.default
//        let docs = fm.urls(for: .cachesDirectory, in: .userDomainMask).first!
//        fileURL = docs.appendingPathComponent(filename)
//        loadFromDisk()
//    }
//}
//
//extension FileCodableStorage: StorageStrategy{
//    func save<T>(_ value: T, idOrKey: String?) {
//        if let idOrKey,
//           let value = value as? Codable,
//           let data = try? JSONEncoder().encode(value){
//            store[idOrKey] = data
//            saveToDisk()
//        }
//    }
//    
//    func get<T>(_ type: T.Type, idOrKey: String?) -> [T]? {
//        guard let idOrKey,
//              let decodableType = type as? Decodable.Type,
//              let data = store[idOrKey],
//              let result = try? JSONDecoder().decode(decodableType, from: data) else { return nil }
//        return  [result] as? [T]
//    }
//    
//    func remove<T>(_ value: T?, idOrKey: String?) {
//        guard let idOrKey else { return }
//        store.removeValue(forKey: idOrKey)
//        saveToDisk()
//    }
//
//    func clearAll() {
//        store.removeAll()
//        saveToDisk()
//    }
//}
//
//private extension FileCodableStorage {
//    private func saveToDisk() {
//        if let data = try? JSONEncoder().encode(store) {
//            try? data.write(to: fileURL)
//        }
//    }
//    
//    private func loadFromDisk() {
//        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }
//        if let data = try? Data(contentsOf: fileURL),
//           let decoded = try? JSONDecoder().decode([String: Data].self, from: data) {
//            store = decoded
//        }
//    }
//}
