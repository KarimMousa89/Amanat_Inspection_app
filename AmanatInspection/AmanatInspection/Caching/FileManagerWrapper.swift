//
//  FileManagerWrapper.swift
//  Tahakom
//
//  Created by Karim Mousa on 19/08/2025.
//  Copyright © 2025 Tahakom. All rights reserved.
//

import Foundation

class FileManagerWrapper {
    func fileExists(fileURL: URL) -> Bool {
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: fileURL.path)
    }
    
    func createFile(url: URL) {
        var fileURL = url
        let fileManager = FileManager.default
        guard fileExists(fileURL: url) == false else { return }
        
        fileManager.createFile(atPath: fileURL.path, contents: nil)
        var resourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = true
        do {
            try fileURL.setResourceValues(resourceValues)
        } catch {
            debugPrint("failed to exclude from icloud backup: \(error)")
        }
    }
    
    func getAppSupportDirectory() -> URL? {
        let fileManager = FileManager.default
        guard let url = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        do{
            // Create directory if needed, applicationSupportDirectory not exist in the app sandbox by default
            try fileManager.createDirectory(at: url,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
        } catch (let error) {
            debugPrint("failed to create directory: \(error)")
        }
        return url
    }
}
