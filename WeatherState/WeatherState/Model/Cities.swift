//
//  Cities.swift
//  WeatherState
//
//  Created by SDB01 on 26/12/19.
//

import Foundation

struct Cities: Codable {
    let coord : Coord?
    let country : String?
    let id : Int?
    let name : String?
    
    enum CodingKeys: String, CodingKey {
        
        case coord = "coord"
        case country = "country"
        case id = "id"
        case name = "name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coord = try values.decodeIfPresent(Coord.self, forKey: .coord)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
    
}

struct Coord : Codable {
    let lat : String?
    let lon : String?
    
    enum CodingKeys: String, CodingKey {
        
        case lat = "lat"
        case lon = "lon"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lat = try values.decodeIfPresent(String.self, forKey: .lat)
        lon = try values.decodeIfPresent(String.self, forKey: .lon)
    }
    
}
