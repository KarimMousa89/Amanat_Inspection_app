//
//  APError.swift
//  Appetizers
//
//  Created by Sean Allen on 11/12/20.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest(error: Error?)
    case invalidResponse(httpCode: Int?, response: HTTPURLResponse?, data: Data?, error: Error?) // Most probably Underlying Error is DecodingError
    case noInternetConnection
    case noDataFound
    case requestTimeout
    case autherizationFailed
    case transportFailure(error: Error)//.. couldn't reach the server, SSL pinning issue, Most probably Underlying Error is URLError
}
