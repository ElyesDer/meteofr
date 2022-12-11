//
//  Requester.swift
//  meteoFr
//
//  Created by Elyes Derouich on 11/12/2022.
//

import Foundation
import Combine

protocol ResponseWrapper: Decodable { }

protocol DataServiceProviderProtocol {
    func request<T: Decodable>(from provider: NetworkProvider, of type: T.Type) async throws -> T
}

class Requester: DataServiceProviderProtocol {
    
    enum ServiceError: Error {
        case urlRequest
        case statusCode
        case responseError
        case unauthorized
        case unhandled
    }
    
    /// Perform `HTTP` `GET` Request using a Generic Network Provider
    /// - Parameters:
    ///   - provider: conform to `NetworkProvider`, a generic API Endpoint configuration
    ///   - type: Expected Type from the Endpoint
    /// - Returns: T
    func request<T>(from provider: NetworkProvider, of type: T.Type) async throws -> T where T: Decodable {
        
        guard let urlRequest: URLRequest = try? provider.buildURLRequest() else {
            throw ServiceError.urlRequest
        }
        
        let sessionResponse = try await URLSession.shared.data(for: urlRequest)
        
        // handle errors
        guard let response = sessionResponse.1 as? HTTPURLResponse else {
            throw ServiceError.responseError
        }
        
        switch response.statusCode {
        case 200:
            return try JSONDecoder().decode(T.self, from: sessionResponse.0)
        case 401:
            throw ServiceError.unauthorized
        default:
            throw ServiceError.unhandled
        }
    }
}
