//
//  CitiesWeatherViewController.swift
//  WeatherState
//
//  Created by SDB01 on 26/12/19.
//

import UIKit
import CoreLocation


class CitiesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var citiesTableView: UITableView!
    
    var cities:[Dictionary<String, Any>] = []
    var selectCities:[Int] = []
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Cities"
        createNavBarButtons()
        getCities()
        citiesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
    }
    
    func createNavBarButtons(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetCities))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "My City", style: .plain, target: self, action: #selector(currentCity))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func getCities(){
        let citiesPListURL: URL = URL(fileURLWithPath:Bundle.main.path(forResource: "Cities", ofType: "plist")!)
        cities = NSArray(contentsOf:citiesPListURL) as! [Dictionary<String, Any>]
        cities = (cities as NSArray).sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)]) as! [[String:AnyObject]]
        
    }
    @objc func resetCities(){
        selectCities.removeAll()
        citiesTableView.reloadData()
        let indexPath = IndexPath(item: 0, section: 0)
        citiesTableView.scrollToRow(at: indexPath, at: .none, animated: false)
    }
    
    @objc func currentCity(){
        resetCities()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        if let location = locationManager.location?.coordinate {
            let viewController = SelectedCitiesWeatherViewController(nibName: "SelectedCitiesWeatherViewController", bundle: nil)
            viewController.userLocation = location
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let _: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (cities.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        cell.selectionStyle = .none
        
        let city:Dictionary = (cities[indexPath.row]) as Dictionary
        
        if selectCities.contains(city["id"] as! Int) {
            cell.backgroundColor = UIColor.lightGray
        } else {
            cell.backgroundColor = UIColor.white
        }
        
        cell.textLabel?.text = (city["name"] as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let city:Dictionary = (cities[indexPath.row]) as Dictionary
        
        if let index = selectCities.index(of: city["id"] as! Int) {
            selectCities.remove(at: index)
        } else {
            selectCities.count < 7 ? selectCities.append(city["id"] as!Int) : displayAlert(alertTitle: "Selection limit exceed",alertMeassage: "Maximum 7 cities you can choose")
        }
        let indexPath = IndexPath(item: indexPath.row, section: indexPath.section)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func displayAlert(alertTitle:String, alertMeassage:String){
        let alert = UIAlertController(title: alertTitle, message: alertMeassage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        if selectCities.count < 3 {
            displayAlert(alertTitle: "Atleast 3 cities", alertMeassage: "Atleast 3 ciities should be choosen")
            return
        }
        
        let viewController = SelectedCitiesWeatherViewController(nibName: "SelectedCitiesWeatherViewController", bundle: nil)
        viewController.selectedCitiesIds = (selectCities.map{String($0)}).joined(separator: ",")
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
}
