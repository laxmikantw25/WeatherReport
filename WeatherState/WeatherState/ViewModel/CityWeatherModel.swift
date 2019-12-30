//
//  CityWeatherModel.swift
//  WeatherState
//
//  Created by SDB01 on 28/12/19.
//

import Foundation
import CoreLocation

public class CityWeatherModel {
    var cityWeather:Weather?
    var groupedMweatherByDate = [String: [List?]]()
    var list:[List] = []
    
    
    func fetchSelectedCitiesWeather(cities:String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        WeatherManager.sharedInstance.fetchCityWeather(cities: cities,completion: { isSuccess in
            self.cityWeather = WeatherManager.sharedInstance.cityWeather
            self.list = (self.cityWeather!.list)!            
            completion(isSuccess)
        })
    }
    
    func groupWeatherByDate(){
        groupedMweatherByDate = Dictionary(grouping:list,
                                           by: { list2 in DateTimeUtil.UTCToLocal(date: list2.dtTxt!, format: DateTimeUtil.DATE_ONLY_FORMAT)! } )
    }
    
    func fetchCurrentCityWeather(cityLocation:CLLocationCoordinate2D, completion: @escaping (_ isSuccess: Bool) -> Void) {
        WeatherManager.sharedInstance.fetchCurrentCityWeather(cityLocation:cityLocation,completion: { isSuccess in
            self.cityWeather = WeatherManager.sharedInstance.cityWeather
            self.list = (self.cityWeather!.list)!
            self.groupWeatherByDate()
            completion(isSuccess)
        })
    }
}
