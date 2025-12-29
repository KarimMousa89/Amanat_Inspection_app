//
//  MyAppSettings.swift
//  ForthDemo
//
//  Created by Karim Mousa on 16/10/1446 AH.
//

import Foundation
import SwiftUI

@MainActor
final class MyAppSettings: ObservableObject {
    var appID = UUID()
    
    var appLanguage: String = LanguageManager.shared.appLanguage {
        willSet {
            print("will set currentLocale \(newValue)")
            LanguageManager.shared.appLanguage = newValue
        }
    }
    
    func change(language: String) {
        appLanguage = language
        appID = UUID()
        objectWillChange.send()
    }
}

extension EnvironmentValues {
    @MainActor var appSettings: MyAppSettings {
        get { MyAppSettings() }
    }
}

// TODO:: Cleanup
//@MainActor
//extension EnvironmentValues {
//    @Entry var appSettings: MyAppSettings = MyAppSettings()
//}

//private struct MyAppSettingsKey: @preconcurrency EnvironmentKey {
//    @MainActor static let defaultValue: MyAppSettings = MyAppSettings()
//}
//
//extension EnvironmentValues {
//    var appSettings: MyAppSettings {
//        get { self[MyAppSettingsKey.self] }
//        set { self[MyAppSettingsKey.self] = newValue }
//    }
//}
