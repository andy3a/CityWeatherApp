//
//  DetailsViewModel.swift
//  CityWeatherApp
//
//  Created by Andrew_Alekseyuk on 11.04.22.
//

import UIKit

class DetailsViewModel {
    
    var currentWeather: CurrentWeather?
    var hourlyWeatherArray: [HourlyForecast] = []
    var dailyWeatherArray: [DailyForecast] = []
    var providedBackgroundImage: UIImage?
}
