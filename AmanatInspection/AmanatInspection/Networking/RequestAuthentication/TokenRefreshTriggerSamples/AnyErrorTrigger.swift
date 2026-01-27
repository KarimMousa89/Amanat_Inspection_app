//
//  AnyErrorTrigger.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 15/01/2026.
//

import Foundation

struct AnyErrorTrigger: TokenRefreshTrigger {
    func shouldRefresh(
        attempt: Int,
        error: NetworkError?,
        response: HTTPURLResponse?,
        data: Data?
    ) -> (Bool, Bool) {
        (error != nil, true)
    }
}
