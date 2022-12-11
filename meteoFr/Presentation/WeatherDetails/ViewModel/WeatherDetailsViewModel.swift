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
}

// Rennes, à 10 secondes Paris, à 20 secondes Nantes, etc pour Bordeaux et Lyon
let rennes: CountryCoordinates = (name: "Rennes", lat: 48.1173, lon: 1.6778) // 48.1173° N, 1.6778° W
let lyon: CountryCoordinates = (name: "Lyon", lat: 45.7640, lon: 4.8357) // 45.7640° N, 4.8357° E
let paris: CountryCoordinates = (name: "Paris", lat: 48.8566, lon: 2.3522) // 48.8566° N, 2.3522° E
let nantes: CountryCoordinates = (name: "Nantes", lat: 47.2184, lon: 1.5536) // 47.2184° N, 1.5536° W
let bordeaux: CountryCoordinates = (name: "Bordeaux", lat: 44.8378, lon: 0.5792) // 44.8378° N, 0.5792° W

let globalCountriesToRequest: [CountryCoordinates] = [rennes, paris, nantes, bordeaux, lyon]

let globalWaitMessage: [String] = [
    "Nous téléchargeons les données…",
    "C’est presque fini…",
    "Plus que quelques secondes avant d’avoir le résultat…"
]

protocol WeatherDetailViewModelProtocol: AnyObject {
    
    var currentStatus: ViewStatus { get }
    var dataSource: [WeatherViewModel] { get }
    var progress: Float { get }
    
    func reset()
    func performRequest(with country: CountryCoordinates)
}

class WeatherDetailsViewModel: WeatherDetailViewModelProtocol {
    
    @Published
    var currentStatus: ViewStatus
    
    @Published
    var dataSource: [WeatherViewModel] = []
    
    @Published
    var progress: Float = 0.0
    
    @Published
    var loadingMessage: String? = globalWaitMessage.randomElement()
    
    private var index: Int = globalCountriesToRequest.count - 1
    private var timer: AnyCancellable?
    private var requestTimer: AnyCancellable?
    private var labelTimer: AnyCancellable?
    private var cancellable = Set<AnyCancellable>()
    
    let countriesToRequest: [CountryCoordinates] = globalCountriesToRequest
    var weatherStore: WeatherStoreProtocol
    
    init(weatherStore: WeatherStoreProtocol) {
        self.weatherStore = weatherStore
        self.currentStatus = .idle
    }
    
    func reset() {
        currentStatus = .idle
        index = globalCountriesToRequest.count - 1
        timer?.cancel()
        requestTimer?.cancel()
        labelTimer?.cancel()
        progress = 0
    }
    
    @MainActor
    func startFetchJob() {
        currentStatus = .loading
        dataSource = []
        
        timer?.cancel()
        requestTimer?.cancel()
        labelTimer?.cancel()
        
        timer = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.progress = min(1, self.progress + 0.02)
            }
        
        requestTimer = Timer.publish(every: 10, on: .main, in: .default)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                self.performRequest(with: self.countriesToRequest[self.index])
                self.index -= 1
                
                if self.index < 0 {
                    self.reset()
                }
            }
        
        labelTimer = Timer.publish(every: 6, on: .main, in: .default)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadingMessage = globalWaitMessage.randomElement()
            }
    }
    
    func performRequest(with country: CountryCoordinates) {
        Task { @MainActor in
            do {
                let weatherInfo = try await weatherStore.getWeatherInfo(for: country)
                    self.dataSource.append(WeatherViewModel(countryName: country.name, weatherInfo: weatherInfo))
            } catch let error {
                currentStatus = .error(error.localizedDescription)
                reset()
            }
        }
    }
}
