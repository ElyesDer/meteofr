//
//  WeatherDetailsViewModel.swift
//  meteoFr
//
//  Created by Elyes Derouich on 11/12/2022.
//

import Foundation
import Combine

enum ViewStatus {
    case loading
    case idle
    case error(String)
    case loaded
}

// Rennes, à 10 secondes Paris, à 20 secondes Nantes, etc pour Bordeaux et Lyon
let rennes: CountryCoordinates = (lat: 0.0, lon: 0.0)
let lyon: CountryCoordinates = (lat: 0.0, lon: 0.0)
let paris: CountryCoordinates = (lat: 0.0, lon: 0.0)
let nantes: CountryCoordinates = (lat: 0.0, lon: 0.0)
let bordeaux: CountryCoordinates = (lat: 0.0, lon: 0.0)

let globalCountriesToRequest: [CountryCoordinates] = [rennes, paris, nantes, bordeaux, lyon]

protocol WeatherDetailViewModelProtocol: AnyObject {
    
    var currentStatus: ViewStatus { get }
    var dataSource: [WeatherInfo] { get }
    var progress: Float { get }
    
    func reset()
    func performRequest(with country: CountryCoordinates)
}

class WeatherDetailsViewModel: WeatherDetailViewModelProtocol {
    
    @Published
    var currentStatus: ViewStatus
    
    @Published
    var dataSource: [WeatherInfo] = []
    
    @Published
    var progress: Float = 0.0
    
    private var index: Int = globalCountriesToRequest.count - 1
    private var timer: AnyCancellable?
    private var cancellable = Set<AnyCancellable>()
    
    let countriesToRequest: [CountryCoordinates] = globalCountriesToRequest
    var weatherStore: WeatherStoreProtocol
    
    init(weatherStore: WeatherStoreProtocol) {
        self.weatherStore = weatherStore
        self.currentStatus = .idle
    }
    
    func reset() {
        index = globalCountriesToRequest.count
        timer?.cancel()
        timer = nil
    }
    
    func startFetchJob() {
        currentStatus = .loading
        timer?.cancel()
        timer = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                let currentProgress = self.progress * 10
                self.progress = min(1, self.progress + 0.01)
                
                if currentProgress.truncatingRemainder(dividingBy: 10) == 0 {
                    self.performRequest(with: self.countriesToRequest[self.index])
                    self.index -= 1
                }
                
                if self.index == 0 {
                    self.reset()
                }
            }
    }
    
    func performRequest(with country: CountryCoordinates) {
        Task {
            do {
                let weatherInfo = try await weatherStore.getWeatherInfo(for: country)
                dataSource.append(weatherInfo)
            } catch let error {
                currentStatus = .error(error.localizedDescription)
            }
        }
    }
}
