//
//  NetworkRequest.swift
//  ForthDemo
//
//  Created by Karim Mousa on 18/10/1446 AH.
//

import Foundation

enum NetworkRequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class NetworkRequest {
    var urlString: String
    var method: NetworkRequestMethod
    var timeoutInterval: TimeInterval = 10
    var headers: [String: String]?
    var body: Data?
    var queryParams: [String: String]?
    
    init(urlString: String, method: NetworkRequestMethod, timeoutInterval: TimeInterval = 10, headers: [String: String]? = nil, body: Data? = nil, queryParams: [String: String]? = nil) {
        self.urlString = urlString
        self.method = method
        self.headers = headers
        self.body = body
        self.timeoutInterval = timeoutInterval
        self.queryParams = queryParams
    }
}
