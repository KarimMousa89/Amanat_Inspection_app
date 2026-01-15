//
//  UnauthorizedStatusTrigger.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 15/01/2026.
//

import Foundation

struct UnauthorizedStatusTrigger: TokenRefreshTrigger {
    func shouldRefresh(
        error: NetworkError?,
        response: HTTPURLResponse?,
        data: Data?
    ) -> Bool {
        response?.statusCode == 401
    }
}
