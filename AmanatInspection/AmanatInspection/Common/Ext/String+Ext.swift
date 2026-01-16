//
//  String+Ext.swift
//  Appetizers
//
//  Created by Sean Allen on 11/16/20.
//

import Foundation
import RegexBuilder
import CryptoKit


//@MainActor
//func Localized(_ key: String) -> String {
//    LanguageManager.shared.localizedString(key)
//}

private let semaphore = DispatchSemaphore(value: 1)

extension String {
    @MainActor
    var localized: String {
        LanguageManager.shared.localizedString(self)
    }
    
    var isValidEmail: Bool {
//        let emailFormat         = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        let emailPredicate      = NSPredicate(format: "SELF MATCHES %@", emailFormat)
//        return emailPredicate.evaluate(with: self)

        let emailRegex = Regex {
            OneOrMore {
                CharacterClass(
                    .anyOf("._%+-"),
                    ("A"..."Z"),
                    ("0"..."9"),
                    ("a"..."z")
                )
            }
            "@"
            OneOrMore {
                CharacterClass(
                    .anyOf("-"),
                    ("A"..."Z"),
                    ("a"..."z"),
                    ("0"..."9")
                )
            }
            "."
            Repeat(2...64) {
                CharacterClass(
                    ("A"..."Z"),
                    ("a"..."z")
                )
            }
        }
        
        return self.wholeMatch(of: emailRegex) !=  nil
    }
    
    // String input
    func sha256Base64() -> String {
        let data = Data(self.utf8)
        let hashed = SHA256.hash(data: data)
        return Data(hashed).base64EncodedString()
    }
}
