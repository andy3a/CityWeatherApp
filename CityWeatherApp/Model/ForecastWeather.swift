//
//  ForecastWeather.swift
//  CityWeatherApp
//
//  Created by Andrew_Alekseyuk on 6.04.22.
//

import Foundation

class ForecastWeather: Decodable {
    var timezone_offset: Int?
    var hourly: [HourlyForecast]?
    var daily: [DailyForecast]?
}

class HourlyForecast: Decodable {
    var dt: Int?
    var temp: Double?
    var feels_like: Double?
    var pressure: Int?
    var humidity: Int?
    var dew_point: Double?
    var uvi: Double?
    var clouds: Int?
    var visibility: Int?
    var wind_speed: Double?
    var wind_deg: Int?
    var weather: [WeatherInfo]?
    var pop: Double?
}

class DailyForecast: Decodable {
    var dt: Int?
    var sunrise: Int?
    var sunset: Int?
    var temp: Temperature?
    var feels_like: FeelsLike?
    var pressure: Int?
    var humidity: Int?
    var dew_point: Double?
    var wind_speed: Double?
    var wind_deg: Int?
    var weather:[WeatherInfo]?
    var clouds: Int?
    var pop: Double?
    var rain: Double?
    var uvi: Double?
}

class WeatherInfo: Decodable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}

class Temperature: Decodable {
    var day: Double?
    var min: Double?
    var max: Double?
    var night: Double?
    var eve: Double?
    var morn: Double?
}

class FeelsLike: Decodable {
    var day: Double?
    var night: Double?
    var eve: Double?
    var morn: Double?
}
