//
//  WeatherManager.swift
//  WeatherState
//
//  Created by SDB01 on 28/12/19.
//

import Foundation
import CoreLocation

class WeatherManager {
    static let sharedInstance = WeatherManager()
    var cityWeather:Weather?
    
    private init() {
        
    }
    
    func fetchCityWeather(cities: String,completion: @escaping (_ isSuccess: Bool) -> Void) {
        
        NetworkManager.shared.fetchData(urlString: "group?id=\(cities)&units=metric&appid=\(apiKey)") {(weatherResponse: Weather?, isSuccess, errorMessage)  in
            if isSuccess{
                self.cityWeather = weatherResponse
            }
            completion(isSuccess)
        }
    }
    
    func fetchCurrentCityWeather(cityLocation:CLLocationCoordinate2D,completion: @escaping (_ isSuccess: Bool) -> Void) {
        
        NetworkManager.shared.fetchData(urlString: "forecast?lat=\(cityLocation.latitude)&lon=\(cityLocation.longitude)&appid=\(apiKey)") {(weatherResponse: Weather?, isSuccess, errorMessage)  in
            if isSuccess{
                self.cityWeather = weatherResponse
            }
            completion(isSuccess)
        }
    }
}
