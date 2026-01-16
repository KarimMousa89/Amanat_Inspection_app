//
//  APError.swift
//  Appetizers
//
//  Created by Sean Allen on 11/12/20.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case authGenerationFailure(error: Error?)
    case invalidResponse
    case invalidResponseStatus(response: HTTPURLResponse, data: Data?)
    case invalidData
    case decodingFailure(error: Error)
    case sslPinningFailure
    case transportFailure(error: Error)//.. couldn't reach the server
}
