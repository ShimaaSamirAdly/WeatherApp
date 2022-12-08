//
//  ForcastViewController.swift
//  WeatherApp
//
//  Created by Shimaa on 07/12/2022.
//

import UIKit
import Kingfisher

class ForcastViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var weatherStatus: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var windLbl: UIButton!
    @IBOutlet weak var humidityLbl: UIButton!
    @IBOutlet weak var todayWeatherImg: UIImageView!
    @IBOutlet weak var todayTempLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var tomorrowWeatherImg: UIImageView!
    @IBOutlet weak var tomorrowTempLbl: UILabel!
    @IBOutlet weak var tomorrowLbl: UILabel!
    @IBOutlet weak var thirdDayWeatherImg: UIImageView!
    @IBOutlet weak var thirdDayTempLbl: UILabel!
    @IBOutlet weak var thirdDayLbl: UILabel!
    
    private let viewModel = ForcastViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpObservers()
    }
    
    func setUpObservers() {
        viewModel.isLoading.sink { [weak self] isLoading in
            guard let self = self else { return }
            isLoading ? self.showLoader() : self.hideLoader()
        }.store(in: &viewModel.cancellableSet)
        
        viewModel.weatherData.sink { [weak self] forecastModel in
            guard let self = self else { return }
            self.updateUI()
        }.store(in: &viewModel.cancellableSet)
        
        viewModel.showError.sink { [weak self] error in
            guard let self = self else { return }
            self.showErrorMsg(errorMsg: error)
        }.store(in: &viewModel.cancellableSet)
    }
    
    func setUpUI() {
        setUpPullToRefresh()
    }
    
    func setUpPullToRefresh() {
        let refreshView = UIRefreshControl()
        refreshView.addTarget(self, action: #selector(refreshWeather), for: .valueChanged)
        scrollView.addSubview(refreshView)
    }
    
    func updateUI() {
        setUpImages()
        timeLbl.text = viewModel.getCurrentTime()
        countryLbl.text = viewModel.getCityName()
        dateLbl.text = viewModel.getCurrentDate()
        weatherStatus.text = viewModel.getWeatherStatus()
        tempLbl.text = viewModel.getCurrentFDegree()
        humidityLbl.setTitle(viewModel.getHumidity(), for: .normal)
        windLbl.setTitle(viewModel.getWind(), for: .normal)
        todayTempLbl.text = viewModel.getTodayAvgTemp()
        tomorrowTempLbl.text = viewModel.getTomorrowAvgTemp()
        thirdDayTempLbl.text = viewModel.getThirdDayAvgTemp()
        thirdDayLbl.text = viewModel.getThirdDayName()
    }
    
    func setUpImages() {
        weatherImg.image = UIImage(named: viewModel.getWeatherImg())
        todayWeatherImg.image = UIImage(named: viewModel.getTodayImg())
        tomorrowWeatherImg.image = UIImage(named: viewModel.getTomorrowImg())
        thirdDayWeatherImg.image = UIImage(named: viewModel.getThirdDayImg())
    }
    
    @objc func refreshWeather(sender: UIRefreshControl) {
        viewModel.getWeatherData()
        sender.endRefreshing()
    }

    @IBAction func searchBtnPressed(_ sender: Any) {
        navigateToSearhView()
    }
    
    func navigateToSearhView() {
        let searchVC = SearchResultsViewController.loadFromNib()
        searchVC.viewModel = SearchViewModel(selectedCity: viewModel.selectedCity)
        searchVC.modalPresentationStyle = .overCurrentContext
        searchVC.modalTransitionStyle = .crossDissolve
        present(searchVC, animated: true)
    }
}
