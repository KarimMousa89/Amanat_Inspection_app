//
//  BusinessUnauthorizedTrigger.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 15/01/2026.
//

import Foundation

struct BusinessUnauthorizedTrigger: TokenRefreshTrigger {
    func shouldRefresh(
        error: NetworkError?,
        response: HTTPURLResponse?,
        data: Data?
    ) -> Bool {
        guard let data,
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else { return false }

        return json["status"] as? String == "User is not authorized"
    }
}
