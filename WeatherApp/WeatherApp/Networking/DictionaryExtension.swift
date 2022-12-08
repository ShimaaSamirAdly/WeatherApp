//
//  DictionaryExtension.swift
//  WeatherApp
//
//  Created by Shimaa on 08/12/2022.
//

import Foundation

extension Dictionary {
    var queryString: String {
        var outputString: String = "?"
        for (key, value) in self {
            outputString += "\(key)=\(value)&"
        }
        outputString = String(outputString.dropLast())
        return outputString
    }
    
    var subueryString: String {
        var outputString: String = "&"
        for (key, value) in self {
            outputString += "\(key)=\(value)&"
        }
        outputString = String(outputString.dropLast())
        return outputString
    }
}
