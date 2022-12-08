//
//  ParametersTypeEnum.swift
//  WeatherApp
//
//  Created by Shimaa on 08/12/2022.
//

import Foundation

public enum ParametersType {
    case requestBody(parameters: [String: Any])
    case requestQuery(parameters: [String: Any])
    case requestPlain
}
