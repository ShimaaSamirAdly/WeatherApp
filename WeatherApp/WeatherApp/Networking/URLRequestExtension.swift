//
//  URLRequestExtension.swift
//  WeatherApp
//
//  Created by Shimaa on 08/12/2022.
//

import Foundation

extension URLRequest {
    mutating func setRequestParameters(parametersType: ParametersType) {
        switch parametersType {
        case .requestBody(let parameters):
            self.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        case .requestQuery(parameters: let parameters):
            self.url = URL(string: self.url?.absoluteString.appending(parameters.queryString) ?? "")
        case .requestPlain:
            return
        }
    }
}
