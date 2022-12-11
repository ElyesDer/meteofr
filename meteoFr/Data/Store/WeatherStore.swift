//
//  WeatherStore.swift
//  meteoFr
//
//  Created by Elyes Derouich on 11/12/2022.
//

import Foundation

typealias CountryCoordinates = (lat: Double, lon: Double)

protocol WeatherStoreProtocol {
    func getWeatherInfo(for country: CountryCoordinates) async throws -> WeatherInfo
}

class WeatherStore: WeatherStoreProtocol {
    
    var requester: DataServiceProviderProtocol = Requester()
    
    func getWeatherInfo(for country: CountryCoordinates) async throws -> WeatherInfo {
        
        let endPoint: APIEndpoint = .init(
            method: .get,
            endURL: .latlong(lat: country.lat, lon: country.lon))
        
        let data = try await requester.request(from: endPoint, of: WeatherInfo.self)
        
        return data
    }
}
