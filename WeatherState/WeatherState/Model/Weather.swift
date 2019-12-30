//
//  Weather.swift
//  WeatherState
//
//  Created by SDB01 on 28/12/19.
//

import Foundation

// MARK: - Weather
struct Weather: Codable {
    let cod: String?
    let message: Double?
    let cnt: Int?
    let list: [List]?
    let city: City?
}

// MARK: - City
struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coordinate?
    let country: String?
}

// MARK: - Coord
struct Coordinate: Codable {
    let lat, lon: Double?
}

// MARK: - List
struct List: Codable {
    let dt: Int?
    let name: String?
    let main: Main?
    let weather: [WeatherElement]?
    let clouds: Clouds?
    let wind: Wind?
    let snow: Snow?
    let sys: Sys?
    let dtTxt: String?
    
    enum CodingKeys: String, CodingKey {
        case dt,name, main, weather, clouds, wind, snow, sys
        case dtTxt
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

// MARK: - Main
struct Main: Codable {
    let temp, tempMin, tempMax, pressure: Double?
    let seaLevel, grndLevel: Double?
    let humidity: Int?
    let tempKf: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin
        case tempMax
        case pressure
        case seaLevel
        case grndLevel
        case humidity
        case tempKf
    }
}

// MARK: - Snow
struct Snow: Codable {
}

// MARK: - Sys
struct Sys: Codable {
    let pod: String?
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int?
    let main, weatherDescription, icon: String?
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed, deg: Double?
}
