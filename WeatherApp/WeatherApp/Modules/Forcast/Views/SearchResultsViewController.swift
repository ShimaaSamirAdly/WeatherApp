//
//  SearchResultsViewController.swift
//  WeatherApp
//
//  Created by Shimaa on 08/12/2022.
//

import UIKit

class SearchResultsViewController: UIViewController {
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var expandBtn: UIButton!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    
    var viewModel: SearchViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpObservers()
    }
    
    func setUpUI() {
        setUpSearchView()
        searchTableView.register(UINib(nibName: "CitySearchTableViewCell", bundle: nil), forCellReuseIdentifier: "cityCell")
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }
    
    func setUpSearchView() {
        searchView.layer.cornerRadius = 20
        searchView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        setUpTextField()
    }
    
    func setUpTextField() {
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.blueColor.cgColor
        searchTextField.layer.cornerRadius = 15
        searchTextField.text = viewModel?.searchedString
        if let clearButton = searchTextField.value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.setImage(UIImage(named:"ic_clear"), for: .normal)
        }
    }
    
    func setUpObservers() {
        guard let viewModel = viewModel else { return }
        let textFieldPublisher = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: searchTextField)
            .map( {
                ($0.object as? UITextField)?.text
            })
                
        textFieldPublisher
            .receive(on: RunLoop.main)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] query in
                guard let self = self else { return }
                self.viewModel?.searchedString = query ?? ""
                self.viewModel?.getCityList()
            }).store(in: &viewModel.cancellableSet)
        
        viewModel.citiesList.sink { [weak self] _ in
            guard let self = self else { return }
            self.updateUI()
        }.store(in: &viewModel.cancellableSet)
    }
    
    func updateUI() {
        if viewModel?.citiesList.value?.isEmpty ?? true {
            expandBtn.isHidden = true
            searchTableView.isHidden = true
            mainViewHeight.constant = 130
        }else if mainViewHeight.constant != view.frame.height - 20 {
            mainViewHeight.constant = view.frame.height / 2
            expandBtn.isHidden = false
            searchTableView.isHidden = false
        }else {
            expandBtn.isHidden = false
            searchTableView.isHidden = false
        }
        searchTableView.reloadData()
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func expandBtnPressed(_ sender: Any) {
        if mainViewHeight.constant != view.frame.height - 20 {
            mainViewHeight.constant = view.frame.height - 20
            expandBtn.setImage(UIImage(imageLiteralResourceName: "ic_up_arrow"), for: .normal)
        } else {
            mainViewHeight.constant = view.frame.height / 2
            expandBtn.setImage(UIImage(imageLiteralResourceName: "ic_down_arrow"), for: .normal)
        }
    }
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.citiesList.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell") as? CitySearchTableViewCell else { return UITableViewCell() }
        cell.setCityTitle(city: viewModel?.getFilteredCityName(index: indexPath.row) ?? "", area: viewModel?.getFilteredRegionName(index: indexPath.row) ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.viewModel?.selectedCity?.send(self.viewModel?.getFilteredCityName(index: indexPath.row) ?? "")
        }
    }
}
