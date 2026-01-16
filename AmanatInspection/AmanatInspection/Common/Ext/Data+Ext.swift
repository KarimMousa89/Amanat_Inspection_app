//
//  Data+Ext.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 15/01/2026.
//

import Foundation
import CryptoKit

extension Data {
    func hmacSHA256(secret: Data) -> Data {
        let key = SymmetricKey(data: secret)
        let hmac = HMAC<SHA256>.authenticationCode(for: self, using: key)
        return Data(hmac)
    }
    
    // Data input
    func sha256Base64() -> String {
        let hashed = SHA256.hash(data: self)
        return Data(hashed).base64EncodedString()
    }
}
