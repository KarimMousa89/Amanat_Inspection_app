//
//  NetworkManager.swift
//  Appetizers
//
//  Created by Sean Allen on 11/12/20.
//
import Foundation

final class NetworkManager {
    //    static let shared = NetworkManager()
    //    private init() {}
    
    func requestData(_ request: NetworkRequest) async throws(NetworkError) -> Data {
        
        var urlString = request.urlString
        if let queryParams = request.queryParams, !queryParams.isEmpty {
            urlString += "?"
            for (index, param) in queryParams.enumerated() {
                if index != 0 {
                    urlString += "&"
                }
                urlString += "\(param.key)=\(param.value)"
            }
        }
        
        guard let url = URL(string: urlString) else {
            throw .invalidURL
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
                throw NetworkError.invalidResponseStatus(httpStatusCode: response.statusCode)
            }
            
            //            guard let data = data else {
            //                completed(.failure(.invalidData))
            //                return
            //            }
            return data
        } catch (let error) {
            throw .transportFailure(error: error)
        }
    }
    
    func requestResult(_ request: NetworkRequest) async -> Result<Data, NetworkError> {
        do {
            let data = try await self.requestData(request)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
    
    func requestJson<T: Decodable>(_ request: NetworkRequest) async throws(NetworkError) -> T{
        let data = try await self.requestData(request)
        do {
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(T.self, from: data)
            return decodedResponse
        } catch (let error) {
            throw .decodingFailure(error: error)
        }
    }

    func requestJsonResult<T: Decodable>(_ request: NetworkRequest) async -> Result<T, NetworkError> {
        do {
            let data:T = try await self.requestJson(request)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
}

