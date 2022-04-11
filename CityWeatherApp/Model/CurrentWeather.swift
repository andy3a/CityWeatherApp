//
//  CurrentWeather.swift
//  CityWeatherApp
//
//  Created by Andrew_Alekseyuk on 6.04.22.
//

import Foundation

class CurrentWeather: Decodable {
    var coordinates: Coordinates?
    var weather: [Weather]?
    var base: String?
    var main: Main?
    var visibility: Int?
    var wind: Wind?
    var clouds: Clouds?
    var dt: Int?
    var sys: Sys?
    var timezone: Int?
    var id: Int?
    var name: String?
    var cod: Int?
}

class Coordinates: Decodable {
    var lon: Double?
    var lat: Double?
}

class Weather: Decodable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
    init (description: String?) {
        self.description = description
    }
}

class Main: Decodable {
    var temp: Double?
    var feels_like: Double?
    var temp_min: Double?
    var temp_max: Decimal?
    var pressure: Int?
    var humidity: Int?
}
class Wind: Decodable {
    var speed: Double?
    var deg: Int?
}

class Clouds: Decodable {
    var all: Int?
}

class Sys: Decodable {
    var type: Int?
    var id: Int?
    var country: String?
    var sunrise: Int?
    var sunset: Int?
}
