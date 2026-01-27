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

protocol NetworkRequest: Sendable {
    var urlString: String? { get }
    var method: NetworkRequestMethod { get }
    var timeoutInterval: TimeInterval { get }
    var headers: [String: String]? { get}
    var bodyAsJson: [String: Any]? { get }
    var bodyAsData: Data?{ get }
    var queryParams: [String: String]? { get }
    var retryPolicy: RetryPolicy? { get }
    var authorizationGroup: AuthorizationGroup? { get }
    var serverTrustEvaluator: ServerTrustEvaluating? { get }
    
    func buildURLRequest() async throws(NetworkError) -> URLRequest
}

extension NetworkRequest {
    var timeoutInterval: TimeInterval { 10 }
    
    func buildURLRequest() async throws(NetworkError) -> URLRequest {
        guard let urlString = urlString,
              var components = URLComponents(string: urlString) else {
            throw NetworkError.invalidRequest(error: nil)
        }
        /// queryParams
        if let queryParams = queryParams, !queryParams.isEmpty {
            components.queryItems = queryParams.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        guard let url = components.url else {
            throw NetworkError.invalidRequest(error: nil)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        /// Headers
        if let headers = headers {
            urlRequest.allHTTPHeaderFields = headers
        }
        /// Body
        if let bodyAsData = bodyAsData {
            urlRequest.httpBody = bodyAsData
        } else if let bodyAsJson = bodyAsJson {
            do {
                let data = try JSONSerialization.data(withJSONObject: bodyAsJson, options: [])
                urlRequest.httpBody = data
            } catch {
                print("Error Body serializing JSON: \(error)")
                throw NetworkError.invalidRequest(error: nil)
            }
        }
        
        urlRequest.timeoutInterval = timeoutInterval
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        
        if let auth = authorizationGroup?.authenticator {
            do{
                try await auth.apply(to: &urlRequest)
            } catch {
                throw NetworkError.invalidRequest(error: error)
            }
        }
        
        return urlRequest
    }
}
