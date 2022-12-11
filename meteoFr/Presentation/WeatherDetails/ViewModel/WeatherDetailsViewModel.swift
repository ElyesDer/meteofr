//
//  WeatherDetailsViewModel.swift
//  meteoFr
//
//  Created by Elyes Derouich on 11/12/2022.
//

import Foundation

enum ViewStatus {
    case loading
    case idle
    case error(String)
    case loaded
}

protocol WeatherDetailViewModelProtocol {
    var currentStatus: ViewStatus { get }
    
    func performRequest() -> Void
}

class WeatherDetailsViewModel: WeatherDetailViewModelProtocol {
    
    @Published
    var currentStatus: ViewStatus = .idle
    
    func performRequest() {
        Task {
            currentStatus = .idle
        }
    }
}
