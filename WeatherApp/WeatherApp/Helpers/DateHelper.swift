//
//  DateHelper.swift
//  WeatherApp
//
//  Created by Shimaa on 08/12/2022.
//

import Foundation

class DateHelper {
    static func getTimeStringFromInterval(timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }

    static func getDateStringFromInterval(timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "EEEE, dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
}
