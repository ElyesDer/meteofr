//
//  Cell.swift
//  meteoFr
//
//  Created by Elyes Derouich on 11/12/2022.
//

import Foundation
import UIKit

struct WeatherViewModel {
    var countryName: String
    var temperature: String
    var clounds: UIImage
    
    init(countryName: String, weatherInfo: WeatherInfo) {
        self.countryName = countryName
        self.temperature = "\(Int(weatherInfo.main?.temp ?? 0.0))C°"
        switch weatherInfo.clouds?.all ?? 0 {
        case 0:
            self.clounds = .init(systemName: "sun.max")!
        case 1...50:
            self.clounds = .init(systemName: "cloud.sun.fill")!
        default:
            self.clounds = .init(systemName: "cloud.fill")!
        }
    }
}
