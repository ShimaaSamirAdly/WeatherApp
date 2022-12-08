//
//  CityModel.swift
//  WeatherApp
//
//  Created by Shimaa on 08/12/2022.
//

import Foundation

struct CityModel: Codable {
    var id: Int?
    var name: String?
    var region: String?
    var country: String?
    var lat: Double?
    var lon: Double?
    var url: String?
}
