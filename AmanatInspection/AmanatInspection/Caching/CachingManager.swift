//
//  CachingManager.swift
//  Tahakom
//
//  Created by Karim Mousa on 19/08/2025.
//  Copyright © 2025 Tahakom. All rights reserved.
//

import Foundation

protocol CachingManagerProtocol {
    func set<T: Codable>(_ value: T, forKey key: String)
    func get<T: Codable>(forKey key: String) -> T?
    func remove(forKey key: String)
    func clearAll()
}

class CachingManagerImp: CachingManagerProtocol{
    @MainActor static let shared = CachingManagerImp()
    
    private init(){
        createCachingFileIfNeeded()
    }
    
    func set<T: Codable>(_ value: T, forKey key: String) {
        setOnDisk(value, forKey: key)
    }

    func get<T: Codable>(forKey key: String) -> T? {
        return getFromDisk(forKey: key)
    }
    
    func remove(forKey key: String) {
        removeFromDisk(key)
    }
    
    func clearAll() {
        self.clearDisk()
    }
}

private extension CachingManagerImp {
    private func setOnDisk<T: Codable>(_ value: T?, forKey key: String) {
        // Encode, Encrypt, base64 String
        do {
            var data = try JSONEncoder().encode(value)
            var allDict = loadAllFromDisk()
            allDict[key] = data.base64EncodedString()
            saveAllToDisk(dict: allDict)
        } catch (let error){
            debugPrint("failed to set data: \(error)")
        }
    }
    
    private func getFromDisk<T: Codable>(forKey key: String) -> T? {
        let allDict = loadAllFromDisk()
        // Data from base64 String, Decrypt, Decode
        guard let base64String = allDict[key] as? String,
              var data = Data(base64Encoded: base64String) else {
            return nil
        }
        
        do {
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value
        } catch let error{
            debugPrint("failed to get data: \(error)")
            return nil
        }
    }
    
    private func removeFromDisk(_ key: String) {
        var allDict = loadAllFromDisk()
        allDict.removeValue(forKey: key)
        saveAllToDisk(dict: allDict)
    }
    
    private func clearDisk() {
        saveAllToDisk(dict: [:])
    }
    
    // MARK: - Storage Specific Methods
    private func loadAllFromDisk() -> [String: Any] {
        var result: [String: Any] = [:]
        guard let fileURL: URL = cachingFileURL() else { return result}
        guard FileManagerWrapper().fileExists(fileURL: fileURL) else { return result}

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: fileURL.path))
            
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            if let dictionary = jsonObject as? [String: Any] {
                result = dictionary
            } else {
                debugPrint("File content is not a dictionary")
            }
        } catch (let error) {
            debugPrint("Error reading file: \(error)")
        }
        return result
    }
    
    private func saveAllToDisk(dict: [String: Any]) {
        guard let fileURL: URL = cachingFileURL() else { return}
        guard FileManagerWrapper().fileExists(fileURL: fileURL) else { return }
    
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            try jsonData.write(to: fileURL)
        } catch {
            debugPrint("Error saving dictionary as JSON: \(error)")
        }
    }
    
    //MARK: initialization
    
    func createCachingFileIfNeeded() {
        guard let fileURL: URL = cachingFileURL(),
                !FileManagerWrapper().fileExists(fileURL: fileURL) else { return }
        FileManagerWrapper().createFile(url: fileURL)
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: [:], options: .prettyPrinted)
            try jsonData.write(to: fileURL)
        } catch {
            debugPrint("Failed to create empty json file: \(error)")
        }
    }
    
    //MARK: Helper
    func cachingFileURL() -> URL? {
        guard let cachesDirectory = FileManagerWrapper().getAppSupportDirectory() else { return nil}
        return cachesDirectory.appendingPathComponent("TahakomSecureCache.txt")
    }
}
