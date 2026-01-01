//
//  MyAppSettings.swift
//  ForthDemo
//
//  Created by Karim Mousa on 16/10/1446 AH.
//

import Foundation
import SwiftUI
import Observation

@MainActor
@Observable
final class MyAppSettings {
    @ObservationIgnored
    private var _appLang: Language = LanguageManager.shared.appLanguage

    private(set) var appID = UUID()
    private(set) var appLanguage: Language {
        get {
            access(keyPath: \.appLanguage) //.. inform observation framework about the read operation, otherwise the observers won't be registered.
            return _appLang
        }
        set {
            print("will set currentLocale \(newValue.rawValue)")
            LanguageManager.shared.appLanguage = newValue
            _appLang = newValue //.. no notifying for observers here, you want to notify observers when both appLanguage and appID changes together.
        }
    }
    
    func change(language: Language) {
        withMutation(keyPath: \.self) { //.. inform observation framework about the write operation for the whole MyAppSettings object not only appLanguage property
            appLanguage = language
            appID = UUID()
        }
    }
}



// TODO: - Cleanup
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
