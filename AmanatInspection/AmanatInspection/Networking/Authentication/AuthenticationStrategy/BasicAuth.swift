//
//  BasicAuth.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 15/01/2026.
//

import Foundation

struct BasicAuth: AuthenticationStrategy {
    let username: String
    let password: String

    func apply(to request: inout URLRequest) async throws {
        let credentials = "\(username):\(password)"
        let encoded = Data(credentials.utf8).base64EncodedString()
        request.setValue("Basic \(encoded)", forHTTPHeaderField: "Authorization")
    }
}
