//
//  qqq.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 07/08/2025.
//

import Foundation

actor CacheManager {
    
    let shared = CacheManager()
    
    private let userDefaults: UserDefaults
    private var memoryCache: [String: Any] = [:]
    private var diskCacheURL: URL? = nil
    
    init(userDefaults: UserDefaults = .standard, diskCacheName: String = "AppCache") {
        self.userDefaults = userDefaults
        
        if let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            self.diskCacheURL = cachesDirectory.appendingPathComponent(diskCacheName)
            if let diskCacheURL {
                try? FileManager.default.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
            }
        }
    }
    
    // MARK: - Unified Interface
    
    func set<T: Codable>(_ value: T, forKey key: String, storagePolicy: CacheStoragePolicy = .default) async {
        setInMemory(value, forKey: key)
        setInUserDefaults(value, forKey: key)
        /*
        switch storagePolicy {
        case .memoryOnly:
            setInMemory(value, forKey: key)
        case .diskOnly:
            await setOnDisk(value, forKey: key)
        case .userDefaultsOnly:
            setInUserDefaults(value, forKey: key)
        case .default:
            setInMemory(value, forKey: key)
            if shouldPersistToDisk(type: T.self) {
                await setOnDisk(value, forKey: key)
            }
        }
         */
    }
    
    func get<T: Codable>(_ type: T.Type, forKey key: String) async -> T? {
        // Check memory first
        if let memoryValue: T = getFromMemory(forKey: key) {
            return memoryValue
        }
        /*
        // Check disk next
        if let diskValue: T = await getFromDisk(forKey: key) {
            // Populate memory cache for faster access next time
            setInMemory(diskValue, forKey: key)
            return diskValue
        }
        */
        // Check UserDefaults last
        return getFromUserDefaults(type, forKey: key)
    }
    
    func remove(forKey key: String) async {
        memoryCache.removeValue(forKey: key)
        if let fileURL = diskCacheURL?.appendingPathComponent(key) {
            try? FileManager.default.removeItem(at: fileURL)
        }
        userDefaults.removeObject(forKey: key)
    }
    
    func clearAll() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.clearMemory() }
            group.addTask { await self.clearDisk() }
            group.addTask { await self.clearUserDefaults() }
        }
    }
    
    // MARK: - Storage Specific Methods
    
    private func setInMemory<T>(_ value: T, forKey key: String) {
        memoryCache[key] = value
    }
    
    private func getFromMemory<T>(forKey key: String) -> T? {
        return memoryCache[key] as? T
    }
    
    private func clearMemory() {
        memoryCache.removeAll()
    }
    
    private func setOnDisk<T: Codable>(_ value: T, forKey key: String) async {
        guard let fileURL = diskCacheURL?.appendingPathComponent(key) else {
            print("Failed to save to disk cache")
            return
        }
        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Failed to save to disk cache: \(error)")
        }
    }
    
    private func getFromDisk<T: Codable>(_ type: T.Type = T.self, forKey key: String) async -> T? {
        
        guard let fileURL = diskCacheURL?.appendingPathComponent(key),
              FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
        
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Failed to load from disk cache: \(error)")
            return nil
        }
    }
    
    private func clearDisk() async {
        guard let diskCacheURL = diskCacheURL else { return }
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: diskCacheURL, includingPropertiesForKeys: nil)
            for fileURL in contents {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch {
            print("Failed to clear disk cache: \(error)")
        }
    }
    
    private func setInUserDefaults<T: Codable>(_ value: T, forKey key: String) {
        if let primitive = value as? AnyPrimitive {
            userDefaults.set(primitive.value, forKey: key)
        } else {
            do {
                let data = try JSONEncoder().encode(value)
                userDefaults.set(data, forKey: key)
            } catch {
                print("Failed to save to UserDefaults: \(error)")
            }
        }
    }
    
    private func getFromUserDefaults<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        if let primitiveType = type as? AnyPrimitive.Type {
            guard let value = userDefaults.object(forKey: key) else { return nil }
            return primitiveType.init(value: value) as? T
        } else {
            guard let data = userDefaults.data(forKey: key) else { return nil }
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                print("Failed to decode from UserDefaults: \(error)")
                return nil
            }
        }
    }
    
    private func clearUserDefaults() {
        userDefaults.dictionaryRepresentation().keys.forEach { key in
            userDefaults.removeObject(forKey: key)
        }
    }
    
    // MARK: - Helpers
    
    private func shouldPersistToDisk<T>(type: T.Type) -> Bool {
        // Don't persist primitives to disk - they should go to UserDefaults
        return !(type is AnyPrimitive.Type)
    }
}

// MARK: - Cache Storage Policy

enum CacheStoragePolicy {
    case `default`     // Memory for all, disk for non-primitives
    case memoryOnly    // Only in-memory
    case diskOnly      // Only on disk (for non-primitives)
    case userDefaultsOnly // Only in UserDefaults (best for primitives)
}

// MARK: - Primitive Values Support

protocol AnyPrimitive {
    init?(value: Any)
    var value: Any { get }
}

extension String: AnyPrimitive {
    init?(value: Any) {
        guard let string = value as? String else { return nil }
        self = string
    }
    
    var value: Any { self }
}

extension Int: AnyPrimitive {
    init?(value: Any) {
        guard let number = value as? NSNumber else { return nil }
        self = number.intValue
    }
    
    var value: Any { NSNumber(value: self) }
}

extension Double: AnyPrimitive {
    init?(value: Any) {
        guard let number = value as? NSNumber else { return nil }
        self = number.doubleValue
    }
    
    var value: Any { NSNumber(value: self) }
}

extension Bool: AnyPrimitive {
    init?(value: Any) {
        guard let number = value as? NSNumber else { return nil }
        self = number.boolValue
    }
    
    var value: Any { NSNumber(value: self) }
}

extension Float: AnyPrimitive {
    init?(value: Any) {
        guard let number = value as? NSNumber else { return nil }
        self = number.floatValue
    }
    
    var value: Any { NSNumber(value: self) }
}

extension Data: AnyPrimitive {
    init?(value: Any) {
        guard let data = value as? Data else { return nil }
        self = data
    }
    
    var value: Any { self }
}

extension Date: AnyPrimitive {
    init?(value: Any) {
        guard let date = value as? Date else { return nil }
        self = date
    }
    
    var value: Any { self }
}

extension Array: AnyPrimitive where Element: AnyPrimitive {
    init?(value: Any) {
        guard let array = value as? [Any] else { return nil }
        self = array.compactMap { Element(value: $0) }
    }
    
    var value: Any { self.map { ($0 as AnyPrimitive).value } }
}

extension Dictionary: AnyPrimitive where Key == String, Value: AnyPrimitive {
    init?(value: Any) {
        guard let dict = value as? [String: Any] else { return nil }
        self = dict.compactMapValues { Value(value: $0) }
    }
    
    var value: Any { self.mapValues { ($0 as AnyPrimitive).value } }
}
