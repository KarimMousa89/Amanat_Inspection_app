//
//  NetworkManager.swift
//  Appetizers
//
//  Created by Sean Allen on 11/12/20.
//
import Foundation

final class NetworkManager {
    /// To catch the Error
    /// catch is CancellationError {
    ///     print("Request was cancelled")
    /// } catch let error as NetworkError {
    ///     print("Network error: \(error)")
    /// }
    func requestData(_ request: NetworkRequest) async throws -> (Int, Data, HTTPURLResponse) {
        var attempt = 0

        while true {
            // Check for cancellation at the start of each loop
            try Task.checkCancellation()
            do {
                let result =  try await performData(request)
                return (attempt, result.0, result.1)
            } catch let error {
                // transport Error, no reposne or data
                // not valid response HTTPURLResponse, no response or data
                // http status outside 200..<299, response exist and data may exist
                attempt += 1

                guard let policy = request.retryPolicy else {
                    throw error
                }

                var data: Data?
                var response: HTTPURLResponse?
                
                if case NetworkError.invalidResponseStatus(let response1, let data1) = error{
                    response = response1
                    data = data1
                }
                
                if let decision = policy.shouldRetry(
                    attempt: attempt,
                    error: error,
                    response: response,
                    data: data,
                    considerContent : .nonContentBasedOnly
                ) {
                    switch decision {
                    case .retryImmediately:
                        continue
                    case .retry(let delay):
                        try await Task.cancellableSleep(seconds: delay)
                        continue
                    }
                } else {
                    throw error
                }
            }
        }
    }
    
    func requestResult(_ request: NetworkRequest) async -> Result<Data, Error> {
        do {
            let (_, data, _) = try await self.requestData(request)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
    
    func requestJson<T: Decodable>(_ request: NetworkRequest) async throws -> T{
        var attempt = 0
        
        while true {
            try Task.checkCancellation()
            let (currentAttempt ,data, response) = try await self.requestData(request)
            attempt = currentAttempt
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(T.self, from: data)
                return decodedResponse
            } catch (let error) {
                // decoding error, data and response exist
                 attempt += 1
                
                guard let policy = request.retryPolicy else {
                    throw error
                }
                
                if let decision = policy.shouldRetry(
                    attempt: attempt,
                    error: NetworkError.decodingFailure(error: error),
                    response: response,
                    data: data,
                    considerContent : .contentBasedOnly
                ) {
                    switch decision {
                    case .retryImmediately:
                        continue
                    case .retry(let delay):
                        try await Task.cancellableSleep(seconds: delay)
                        continue
                    }
                } else {
                    throw NetworkError.decodingFailure(error: error)
                }
            }
        }
    }

    func requestJsonResult<T: Decodable>(_ request: NetworkRequest) async -> Result<T, Error> {
        do {
            let data:T = try await self.requestJson(request)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
}

private extension NetworkManager {
    func performData(_ request: NetworkRequest) async throws(NetworkError) -> (Data, HTTPURLResponse) {
        guard var components = URLComponents(string: request.urlString) else {
            throw .invalidURL
        }
        if let queryParams = request.queryParams, !queryParams.isEmpty {
            components.queryItems = queryParams.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        if let headers = request.headers {
            urlRequest.allHTTPHeaderFields = headers
        }
        urlRequest.httpBody = request.body
        urlRequest.timeoutInterval = request.timeoutInterval
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        
        do {
            let (data, response) =  try await URLSession.shared.data(for: urlRequest)
            
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard (200...299).contains(response.statusCode) else {
                throw NetworkError.invalidResponseStatus(response: response, data: data)
            }
            
            return (data, response)
        } catch (let error) {
            throw .transportFailure(error: error)
        }
    }
}

