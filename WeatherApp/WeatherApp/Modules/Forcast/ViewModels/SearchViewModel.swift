//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by Shimaa on 08/12/2022.
//

import Foundation
import Combine

class SearchViewModel {
    var citiesList = CurrentValueSubject<[CityModel]?, Never>([])
    var selectedCity: CurrentValueSubject<String, Never>?
    var searchedString = ""
    var cancellableSet = Set<AnyCancellable>()
    
    init(selectedCity: CurrentValueSubject<String, Never>? = nil) {
        self.selectedCity = selectedCity
    }
    
    func getFilteredCityName(index: Int) -> String {
       citiesList.value?[index].name ?? ""
    }
    
    func getFilteredRegionName(index: Int) -> String {
       citiesList.value?[index].region ?? ""
    }
    
    func getCityList() {
        Task {
            await excuteGetCityList()
        }
    }
    
    private func excuteGetCityList() async {
        let response = await NetworkHandler.shared.requestAsync(target: .searchCities(cityQuery: searchedString), model: [CityModel].self)
        if response.error == nil {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.citiesList.send(response.responseModel as? [CityModel])
            }
        }
    }
}
