//
//  NetworkApis.swift
//  WeatherApp
//
//  Created by Shimaa on 08/12/2022.
//

import Foundation

enum NetworkApis {
    case getForcast(city: String)
    case searchCities(cityQuery: String)
}

extension NetworkApis {
    var baseURL: URL {
        return URL(string: Constants.baseUrl)!
    }

    var path: String {
        switch self {
        case .getForcast:
            return "/forecast.json"
        case .searchCities:
            return "/search.json"
        }
    }

    var method: HttpMethods {
        switch self {
        default:
            return .get
        }
    }

    var header: [String: String] {
        switch self {
        default:
            return [:]
        }
    }

    var parameters: ParametersType {
        switch self {
        case .getForcast(let city):
            return .requestQuery(parameters: ["key": Constants.apiKey, "q": city, "days": 3])
        case .searchCities(let cityQuery):
            return .requestQuery(parameters: ["key": Constants.apiKey, "q": cityQuery])
        }
    }
}

extension NetworkApis {
    var request: URLRequest {
        let targetUrl = self.baseURL.appendingPathComponent(self.path)
        var request = URLRequest(url: targetUrl)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = self.header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setRequestParameters(parametersType: parameters)
        request.timeoutInterval = 30
        return request
    }
}
