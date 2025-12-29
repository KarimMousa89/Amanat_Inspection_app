//
//  Util.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 08/08/2025.
//

import Foundation

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    var result: String = ""
    while result.count < length {
        if let letter = letters.randomElement(),
            !result.contains(letter) {
            result.append(letter)
        }
    }
    return result
}
