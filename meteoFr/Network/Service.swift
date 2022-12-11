//
//  Service.swift
//  meteoFr
//
//  Created by Elyes Derouich on 11/12/2022.
//

import Foundation

public protocol NetworkProvider {
    var method: HTTPMethods { get }
    var endURL: APIProvider { get }
    
    func buildURLRequest() throws -> URLRequest
}

public enum APIProvider {
    
    private static let token = Bundle.main.infoDictionary?["API_KEY"] as? String ?? "NO_TOKEN"
    
    private var baseUrl: String {
        "https://api.openweathermap.org/data/2.5/weather"
    }
    
    case latlong(lat: Double, lon: Double)
    
    var rawValue: String {
        switch self {
        case .latlong(let lat, let lon):
            return baseUrl + "?lat=\(lat)&lon=\(lon)&appid=\(APIProvider.token)&units=metric"
        }
    }
}

public enum HTTPMethods: String {
    case get = "GET"
}

public struct APIEndpoint: NetworkProvider {
    
    enum NetworkProviderError: Error {
        case urlBuilder
        case urlRequest
    }
    
    public var method: HTTPMethods
    public let endURL: APIProvider
    
    public init(method: HTTPMethods,
                endURL: APIProvider) {
        self.method = method
        self.endURL = endURL
    }
    
    public func buildURLRequest() throws -> URLRequest {
        guard let url = URL(string: self.endURL.rawValue) else { throw NetworkProviderError.urlBuilder }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
