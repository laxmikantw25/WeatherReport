//
//  SelectedCitiesWeatherViewController.swift
//  WeatherState
//
//  Created by SDB01 on 28/12/19.
//

import UIKit
import CoreLocation

class SelectedCitiesWeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var weatherListTableView: UITableView!
    var selectedCitiesIds:String!
    var userLocation:CLLocationCoordinate2D?
    
    let cityWeatherModel = CityWeatherModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        userLocation == nil ? getSelectedCitiesWeather():getCurrentCityWeather()
    }
    func registerCell(){
        let nib = UINib.init(nibName: "weatherDetailsTableViewCell", bundle: nil)
        self.weatherListTableView.register(nib, forCellReuseIdentifier: "weatherDetailsCell")
    }
    
    func getSelectedCitiesWeather(){
        self.title = "Selected citites weather"
        if let selectedCities = selectedCitiesIds {
            cityWeatherModel.fetchSelectedCitiesWeather(cities: selectedCities) { isSuccess in
                DispatchQueue.main.async {
                    
                    self.weatherListTableView.reloadData()
                }
                
            }
        }
    }
    
    func getCurrentCityWeather(){
        self.title = "My city weather"
        if let location = userLocation {
            cityWeatherModel.fetchCurrentCityWeather(cityLocation: location) { isSuccess in
                DispatchQueue.main.async {
                    self.weatherListTableView.reloadData()
                }
                
            }
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        if userLocation != nil {
            return self.cityWeatherModel.groupedMweatherByDate.keys.count
        } else {
            return 1
        }
    }
    
    // MARK: - UITableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if userLocation != nil {
            let weatherDate = Array(self.cityWeatherModel.groupedMweatherByDate.keys)[section]
            return (self.cityWeatherModel.groupedMweatherByDate[weatherDate]?.count)!
        } else {
            return self.cityWeatherModel.list.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if userLocation != nil {
            return Array(self.cityWeatherModel.groupedMweatherByDate.keys)[section]
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let list:List!
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherDetailsCell", for: indexPath) as! weatherDetailsTableViewCell
        if userLocation != nil{
            let weatherDate = Array(self.cityWeatherModel.groupedMweatherByDate.keys)[indexPath.section]
            list = (self.cityWeatherModel.groupedMweatherByDate[weatherDate]?[indexPath.row])!
        } else {
            list = self.cityWeatherModel.list[indexPath.row]
        }
        cell.cityNameLabel.text = userLocation == nil ? list.name!: DateTimeUtil.UTCtoTimeLocal(date: list.dtTxt!, format: DateTimeUtil.TIME_ONLY_FORMAT)!
        cell.weatherDescriptionLabel.text = "Weather: \(String(describing: list.weather![0].main!))"
        cell.windSpeedLabel.text = "Wind: \(String(describing: list.wind!.speed!)) m/s"
        cell.temperatureLabel.text = "Temp. min: \(String(describing: list.main!.tempMin!)) °C / max: \(String(describing: list.main!.tempMax!)) °C"
        return cell
    }
}
