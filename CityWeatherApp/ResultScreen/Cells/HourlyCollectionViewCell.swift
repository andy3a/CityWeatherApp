//
//  HourlyCollectionViewCell.swift
//  CityWeatherApp
//
//  Created by Andrew_Alekseyuk on 7.04.22.
//

import Foundation
import UIKit
import Kingfisher

class HourlyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    func configure(object: HourlyForecast) {
        guard let epochtime = object.dt else {return}
        let time = Date(timeIntervalSince1970: TimeInterval(epochtime))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        
        let timeString = formatter.string(from: time)
        timeLabel.text = timeString

        if let icon = object.weather?[0].icon {
            let URLstring = "http://openweathermap.org/img/wn/" + icon + "@2x.png"
            let url = URL(string: URLstring)
            imageView.contentMode = .scaleAspectFill
            imageView.kf.setImage(with: url)
            guard let temperature = object.temp else {return}
            temperatureLabel.text = String(Int(temperature)) + "°"
            
        }
    }
}
