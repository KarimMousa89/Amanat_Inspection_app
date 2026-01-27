//
//  UnauthorizedStatusTrigger.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 15/01/2026.
//

import Foundation

struct UnauthorizedStatusTrigger: TokenRefreshTrigger {
    var maxRetries: Int
    var statusCodes: Set<Int>
    
    init(maxRetries: Int, statusCodes: Set<Int>) {
        self.maxRetries = maxRetries
        self.statusCodes = statusCodes
    }
    
    func shouldRefresh(
        attempt: Int,
        error: NetworkError?,
        response: HTTPURLResponse?,
        data: Data?
    ) -> (Bool, Bool)  {
        let allowedToRetry = attempt < (maxRetries + 1)
        var hasAuthIssue = false
        
        if let statusCode = response?.statusCode{
            hasAuthIssue = statusCodes.contains(statusCode)
        }
        
        return (allowedToRetry && hasAuthIssue, hasAuthIssue)
    }
}
