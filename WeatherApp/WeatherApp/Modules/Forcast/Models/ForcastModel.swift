//
//  ForcastModel.swift
//  WeatherApp
//
//  Created by Shimaa on 08/12/2022.
//

import Foundation

struct ForcastModel: Codable {
    var location: WeatherLocation?
    var current: CurrentWeather?
    var forecast: Forecast?
}

struct WeatherLocation: Codable {
    var name: String?
    var region: String?
    var country: String?
    var lat: Double?
    var lon: Double?
    var localeTimeStamp: Double?
    var localDate: String?
    
    private enum CodingKeys: String, CodingKey {
        case name, region, country, lat, lon
        case localeTimeStamp = "localtime_epoch"
        case localDate = "localtime"
    }
}

struct CurrentWeather: Codable {
    var lastUpdatedStamp: Double?
    var lastUpdated: String?
    var tempC: Double?
    var tempF: Double?
    var windMph: Double?
    var humidity: Double?
    var condition: Condition?
    
    private enum CodingKeys: String, CodingKey {
        case humidity, condition
        case lastUpdatedStamp = "last_updated_epoch"
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case tempF = "temp_f"
        case windMph = "wind_mph"
    }
}

struct Condition: Codable {
    var text: String?
    var icon: String?
    var code: Int?
}

struct Forecast: Codable {
    var forecastday: [ForecastDay]?
    
    func getAvgTempForDay(index: Int) -> String {
        "\(forecastday?[index].day?.avgTempC ?? 0.0)°/\(forecastday?[index].day?.avgTempF ?? 0.0)°F"
    }
}

struct ForecastDay: Codable {
    var date: String?
    var dateTimeStamp: Double?
    var day: Day?
    
    private enum CodingKeys: String, CodingKey {
        case date, day
        case dateTimeStamp = "date_epoch"
    }
}
    
struct Day: Codable {
    var avgTempC: Double?
    var avgTempF: Double?
    var condition: Condition?
    
    private enum CodingKeys: String, CodingKey {
        case condition
        case avgTempC = "avgtemp_c"
        case avgTempF = "avgtemp_f"
    }
}
