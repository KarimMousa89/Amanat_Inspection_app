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

// TODO:: optimize, not all methods needs MainActor
@MainActor
final class LanguageManager {
    static let shared: LanguageManager = LanguageManager()
    
    private let defaultAppLanguage: String  = Language.english.rawValue
    private var currentLanguage: String? = nil
    private var bundle: Bundle? = nil
    
    var appLanguage: String {
        set {
            guard let path = Bundle.main.path(forResource: newValue, ofType: "lproj"),
                  let newBundle = Bundle(path: path) else {
                return
            }
            bundle = newBundle
            currentLanguage = newValue
            UserDefaults.standard.setValue(newValue, forKey: "appLanguage")
            UserDefaults.standard.set([newValue], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
        get {
            if let currentLanguage {
                return currentLanguage
            } else {
                var lang: String = ""
                let loadedLang = UserDefaults.standard.value(forKey: "appLanguage") as? String
                if let loadedLang {
                    lang = loadedLang
                } else { // first time launch
                    // TODO:: read phone language, if it's one from the supported langs then use it otherwise use the default language
                    lang = defaultAppLanguage
                }
                if let path = Bundle.main.path(forResource: lang, ofType: "lproj"),
                      let newBundle = Bundle(path: path) {
                    bundle = newBundle
                    currentLanguage = lang
                    if loadedLang == nil {
                        UserDefaults.standard.setValue(lang, forKey: "appLanguage")
                        UserDefaults.standard.set([lang], forKey: "AppleLanguages")
                        UserDefaults.standard.synchronize()
                    }
                }
                return lang
            }
        }
    }
    
    func localizedString(_ key: String) -> String {
        if bundle == nil {
            bundle = .main
        }
        guard let bundle else { return key }
        return bundle.localizedString(forKey: key, value: nil, table: nil)
    }
}
