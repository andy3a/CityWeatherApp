//
//  DailyTableViewCell.swift
//  CityWeatherApp
//
//  Created by Andrew_Alekseyuk on 7.04.22.
//

import Foundation
import UIKit
import Kingfisher

class DailyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dailyIcon: UIImageView!
    @IBOutlet weak var dayTemp: UILabel!
    @IBOutlet weak var nightTemp: UILabel!
    
    func configure (object: DailyForecast) {
        let date = Date(timeIntervalSince1970: TimeInterval(object.dt!))
        let dayOfWeek = Calendar.current.component(.weekday, from: date)
        let dayOfWeekString = dayOfWeek.defineDayOfWeek()
        dayLabel.text = String(dayOfWeekString)
        
        if let icon = object.weather?[0].icon {
            let URLstring = "http://openweathermap.org/img/wn/" + icon + "@2x.png"
            let url = URL(string: URLstring)
            dailyIcon.contentMode = .scaleAspectFill
            dailyIcon.kf.setImage(with: url)
            
            dayTemp.text = String(object.temp!.day!) + "°"
            nightTemp.text = String(object.temp!.night!) + "°"
            
        }
    }
}
