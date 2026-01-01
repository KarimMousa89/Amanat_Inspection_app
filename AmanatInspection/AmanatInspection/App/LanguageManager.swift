//
//  Bundle+Ext.swift
//  ForthDemo
//
//  Created by TWI on 17/12/2024.
//

import Foundation

enum Language: String {
    case arabic = "ar-SA"
    case english = "en"
}

// TODO: - optimize, not all methods needs MainActor
@MainActor
final class LanguageManager {
    static let shared: LanguageManager = LanguageManager()
    
    private let defaultAppLanguage: Language  = Language.english
    private var bundle: Bundle = .main
    private var currentLanguage: Language? = nil

    var appLanguage: Language {
        set {
            guard let path = Bundle.main.path(forResource: newValue.rawValue, ofType: "lproj"),
                  let newBundle = Bundle(path: path) else {
                return
            }
            bundle = newBundle
            currentLanguage = newValue
            UserDefaults.standard.setValue(newValue.rawValue, forKey: "appLanguage")
            UserDefaults.standard.set([newValue.rawValue], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
        get {
            if let currentLanguage {
                return currentLanguage
            } else { // app just opened
                var lang: String = ""
                let loadedLang = UserDefaults.standard.value(forKey: "appLanguage") as? String
                if let loadedLang {
                    lang = loadedLang
                } else { // first time launch
                    // TODO: - read phone language, if it's one from the supported langs then use it otherwise use the default language
                    lang = defaultAppLanguage.rawValue
                }
                if let desiredLanguage = Language(rawValue: lang),
                   let path = Bundle.main.path(forResource: lang, ofType: "lproj"),
                   let newBundle = Bundle(path: path) {
                    bundle = newBundle
                    currentLanguage = desiredLanguage
                    if loadedLang == nil {
                        UserDefaults.standard.setValue(lang, forKey: "appLanguage")
                        UserDefaults.standard.set([lang], forKey: "AppleLanguages")
                        UserDefaults.standard.synchronize()
                    }
                    if let currentLanguage {
                        return currentLanguage
                    }
                }
                return defaultAppLanguage
            }
        }
    }
    // TODO: - take caching manager, don't use user defaults by default
    init() {
        
    }
    
    func localizedString(_ key: String) -> String {
        return bundle.localizedString(forKey: key, value: nil, table: nil)
    }
}
