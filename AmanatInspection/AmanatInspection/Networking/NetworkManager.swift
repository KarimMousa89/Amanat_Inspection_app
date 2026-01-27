//
//  NetworkManager.swift
//  Appetizers
//
//  Created by Sean Allen on 11/12/20.
//
import Foundation

protocol NetworkManager{
    func requestData(_ request: NetworkRequest) async throws -> Data
    func requestResult(_ request: NetworkRequest) async -> Result<Data, Error>
    func requestJson<T: Decodable>(_ request: NetworkRequest) async throws -> T
    func requestJsonResult<T: Decodable>(_ request: NetworkRequest) async -> Result<T, Error>
}

struct NetworkManagerImp: NetworkManager {
    func requestData(_ request: NetworkRequest) async throws -> Data {
        var attempts = 0
        return try await self.requestData(request, executions: &attempts).0
    }
    
    func requestResult(_ request: NetworkRequest) async -> Result<Data, Error> {
        do {
            let (data) = try await self.requestData(request)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
    
    func requestJson<T: Decodable>(_ request: NetworkRequest) async throws -> T{
        var executions = 0
        
        while true {
            try Task.checkCancellation()
            let (data, response) = try await self.requestData(request, executions: &executions)
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(T.self, from: data)
                return decodedResponse
            } catch (let error) {
                // decoding error, data and response exist
                guard let policy = request.retryPolicy else {
                    throw error
                }
                
                if let decision = policy.shouldRetry(
                    attempt: executions,
                    error: NetworkError.invalidResponse(httpCode: nil, response: nil, data:nil, error: error),
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
                    throw NetworkError.invalidResponse(httpCode: nil, response: nil, data:nil, error: error)
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
    /// To catch the Error
    /// catch is CancellationError {
    ///     print("Request was cancelled")
    /// } catch let error as NetworkError {
    ///     print("Network error: \(error)")
    /// }
    func requestData(_ request: NetworkRequest, executions: inout Int) async throws -> (Data, HTTPURLResponse) {
        while true {
            // Check for cancellation at the start of each loop
            try Task.checkCancellation()
            do {
                // attempts counts actual network executions (performData calls)
                executions += 1
                let result =  try await performData(request)
                return (result.0, result.1)
            } catch let error {
                // transport Error, no reposne or data
                // sslpinning Error, no reposne or data
                // not valid response HTTPURLResponse, no response or data
                // http status outside 200..<299, response exist and data may exist
                // can't construct the Auth header
                // TODO: check if more errors coming here and document it
                if case NetworkError.invalidRequest(error: _) = error{
                    throw error
                }
                
                var data: Data?
                var response: HTTPURLResponse?
                
                if case NetworkError.invalidResponse(_, let response1, let data1, _) = error{
                    response = response1
                    data = data1
                }
                
                if let trigger = request.authorizationGroup?.refreshTrigger,
                   let coordinator = request.authorizationGroup?.refreshCoordinator{
                    let (shouldRetry, authIssueExist) = trigger.shouldRefresh(attempt: executions, error: error, response: response, data: data)
                    
                    if shouldRetry {
                        try await coordinator.refresh()
                        continue // retry original request
                    } else if authIssueExist {// auth issue exist but can't retry because for example i exceeded number of allowes attempts
                        throw NetworkError.autherizationFailed
                    }
                }

                guard let policy = request.retryPolicy else {
                    throw error
                }

                if let decision = policy.shouldRetry(
                    attempt: executions,
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
    
    func performData(_ request: NetworkRequest) async throws(NetworkError) -> (Data, HTTPURLResponse) {
        
        let urlRequest = try await request.buildURLRequest()
                
        do {
            let (data, response) =  try await URLSessionProvider().session(for: request).data(for: urlRequest)
            
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse(httpCode: nil, response: nil, data: nil, error: nil)
            }
            let statusCode = response.statusCode
            guard (200...299).contains(statusCode) else {
                if statusCode == 404 {
                    throw NetworkError.noDataFound
                }
                throw NetworkError.invalidResponse(httpCode: statusCode, response: response, data: data, error: nil)
            }
            return (data, response)
        } catch (let error) {
            if let error = error as? NetworkError {
                throw error
            } else if let urlError = error as? URLError {
                switch urlError.code {
                case .cancelled:// SSL pinning failed
                    throw NetworkError.autherizationFailed
                case .notConnectedToInternet,
                        .networkConnectionLost:
                    throw NetworkError.noInternetConnection
                case .timedOut:
                    throw NetworkError.requestTimeout
                default:
                    break
                }
            }
            print("Network Transport Error: \(error.localizedDescription)")
            throw NetworkError.transportFailure(error: error)
        }
    }
}

