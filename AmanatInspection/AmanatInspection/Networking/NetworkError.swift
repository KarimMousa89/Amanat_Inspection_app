//
//  APError.swift
//  Appetizers
//
//  Created by Sean Allen on 11/12/20.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidResponseStatus(httpStatusCode: Int)
    case invalidData
    case decodingFailure(error: Error)
    case transportFailure(error: Error)//.. couldn't reach the server
}
