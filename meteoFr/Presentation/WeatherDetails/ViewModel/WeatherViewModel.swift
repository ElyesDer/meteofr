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

    let animals: [String] = [
        "Ten horses:  horse horse horse horse horse horse horse horse horse horse ",
        "Three cows:  cow, cow, cow",
        "One camel:  camel",
        "Ninety-nine sheep:  sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep baaaa sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep sheep",
        "Thirty goats:  goat goat goat goat goat goat goat goat goat goat goat goat goat goat goat goat goat goat goat goat goat goat goat goat goat goat goat goat goat goat "]

    
    init(countryName: String, weatherInfo: WeatherInfo) {
        self.countryName = animals.randomElement()! // countryName
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
