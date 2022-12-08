//
//  ForcastViewModel.swift
//  WeatherApp
//
//  Created by Shimaa on 07/12/2022.
//

import Foundation
import Combine

class ForcastViewModel {
    
    var weatherData = CurrentValueSubject<ForcastModel?, Never>(nil)
    var selectedCity = CurrentValueSubject<String, Never>("")
    var isLoading = PassthroughSubject<Bool, Never>()
    var showError = PassthroughSubject<String, Never>()
    var cancellableSet = Set<AnyCancellable>()
    
    init() {
        LocationManager.shared.enableLocation()
        setUpObservers()
//        getWeatherData()
    }
    
    func setUpObservers() {
        selectedCity.dropFirst().sink { [weak self] _ in
            guard let self = self else { return }
            self.getWeatherData()
        }.store(in: &cancellableSet)
        
        LocationManager.shared.currentCity.sink { [weak self] currentCity in
            guard let self = self else { return }
            self.selectedCity.send(currentCity)
        }.store(in: &cancellableSet)
    }
    
    func getCityName() -> String {
        weatherData.value?.location?.name ?? ""
    }
    
    func getCurrentTime() -> String {
        DateHelper.getTimeStringFromInterval(timeInterval: weatherData.value?.current?.lastUpdatedStamp ?? Date().timeIntervalSince1970)
    }
    
    func getCurrentDate() -> String {
        DateHelper.getDateStringFromInterval(timeInterval: weatherData.value?.current?.lastUpdatedStamp ?? Date().timeIntervalSince1970)
    }
    
    func getWeatherImg() -> String {
        weatherData.value?.current?.condition?.getIconName() ?? ""
    }
    
    func getWeatherStatus() -> String {
        weatherData.value?.current?.condition?.text ?? ""
    }
    
    func getCurrentCDegree() -> String {
        "\(weatherData.value?.current?.tempC ?? 0.0)°"
    }
    
    func getCurrentFDegree() -> String {
        "\(weatherData.value?.current?.tempF ?? 0.0)°F"
    }
    
    func getHumidity() -> String {
        "\(weatherData.value?.current?.humidity ?? 0.0)%"
    }
    
    func getWind() -> String {
        "\(weatherData.value?.current?.windMph ?? 0.0) mph"
    }
    
    func getTodayAvgTemp() -> String {
        weatherData.value?.forecast?.getAvgTempForDay(index: 0) ?? ""
    }
    
    func getTomorrowAvgTemp() -> String {
        weatherData.value?.forecast?.getAvgTempForDay(index: 1) ?? ""
    }
    
    func getThirdDayAvgTemp() -> String {
        weatherData.value?.forecast?.getAvgTempForDay(index: 2) ?? ""
    }
    
    func getTodayImg() -> String {
        weatherData.value?.forecast?.forecastday?.first?.day?.condition?.getIconName() ?? ""
    }
    
    func getTomorrowImg() -> String {
        weatherData.value?.forecast?.forecastday?[1].day?.condition?.getIconName() ?? ""
    }
    
    func getThirdDayImg() -> String {
        weatherData.value?.forecast?.forecastday?[2].day?.condition?.getIconName() ?? ""
    }
    
    func getThirdDayName() -> String {
        let dateString = DateHelper.getDateStringFromInterval(timeInterval: weatherData.value?.forecast?.forecastday?[2].dateTimeStamp ?? 0.0)
        let dayName = dateString.split(separator: ",").first
        return "\(dayName ?? "")"
    }
    
    func getWeatherData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isLoading.send(true)
        }
        Task {
            await excuteWeatherData()
        }
    }
    
    private func excuteWeatherData() async {
        let response = await NetworkHandler.shared.requestAsync(target: .getForcast(city: selectedCity.value), model: ForcastModel.self)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isLoading.send(false)
            if response.error == nil {
                self.weatherData.send(response.responseModel as? ForcastModel)
            } else {
                var errorMsg = ""
                if response.error == .badRequest {
                    errorMsg = "City is not provided"
                } else {
                    errorMsg = response.error?.errorDescription ?? ""
                }
                self.showError.send(errorMsg)
            }
        }
    }
}
