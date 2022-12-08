//
//  CitySearchTableViewCell.swift
//  WeatherApp
//
//  Created by Shimaa on 08/12/2022.
//

import UIKit

class CitySearchTableViewCell: UITableViewCell {

    @IBOutlet weak var cityTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCityTitle(city: String, area: String) {
        let cityString = NSMutableAttributedString(string: city, attributes: [NSAttributedString.Key.foregroundColor: UIColor.blueColor, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        let areaString = NSMutableAttributedString(string: " - \(area)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.blueColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        cityString.append(areaString)
        cityTitle.attributedText = cityString
    }
}
