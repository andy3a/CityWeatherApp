//
//  DetailsViewController.swift
//  CityWeatherApp
//
//  Created by Andrew_Alekseyuk on 6.04.22.
//

import Foundation
import UIKit
import Kingfisher

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var loactionLabel: UILabel!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunriseValue: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var sunsetValue: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var pressureValue: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var humidityValue: UILabel!
    @IBOutlet weak var windspeedLabel: UILabel!
    @IBOutlet weak var windspeedValue: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var visibilityValue: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var lastUpdatedValue: UILabel!
    
    @IBOutlet weak var hourlyWeather: UICollectionView!
    @IBOutlet weak var dailyWeather: UITableView!
    @IBOutlet weak var backgroudImage: UIImageView!
    
    let viewModel = DetailsViewModel()
    
//    var currentWeather: CurrentWeather?
//    var hourlyWeatherArray: [HourlyForecast] = []
//    var dailyWeatherArray: [DailyForecast] = []
//    var providedBackgroundImage: UIImage?
     
    let timeFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeFormatter.dateFormat = "HH:mm"
        
        fillTheLabels()
        setUpBackground()
    }
    
    func fillTheLabels() {
        guard let temperatureUnwrapped = viewModel.currentWeather?.main?.temp else {return}
        temperature.text = "\(temperatureUnwrapped)" + "°"
        temperature.textColor = temperatureUnwrapped.colorizedTemp

        guard let locationUnwrapped = viewModel.currentWeather?.name else {return}
        self.loactionLabel?.text = "\(locationUnwrapped)"
        
        guard let weatherTypeUnwrapped = viewModel.currentWeather?.weather?[0].description else {return}
        self.weatherType?.text = "\(weatherTypeUnwrapped)"

        guard let feelsLikeUnwrapped = viewModel.currentWeather?.main?.feels_like else {return}
        self.feelsLike?.text = "czuje się" + " \(feelsLikeUnwrapped)" + "°"
    
        guard let sunriseUnwrapped = viewModel.currentWeather?.sys?.sunrise else {return}
        let humanReadableSunrise = Date(timeIntervalSince1970: TimeInterval(sunriseUnwrapped))
        let humanReadableFormatedSunrise = timeFormatter.string(from: humanReadableSunrise)
        self.sunriseLabel.text = "Wschód"
        self.sunriseValue.text = humanReadableFormatedSunrise
        
        guard let sunsetUnwrapped = viewModel.currentWeather?.sys?.sunset else {return}
        let humanReadableSunset = Date(timeIntervalSince1970: TimeInterval(sunsetUnwrapped))
        let humanReadableFormatedSunset = timeFormatter.string(from: humanReadableSunset)
        self.sunsetLabel.text = "Zachód"
        self.sunsetValue.text = humanReadableFormatedSunset
        
        guard let pressureUnwrapped = viewModel.currentWeather?.main?.pressure else {return}
        self.pressureLabel.text = "Nacisk"
        self.pressureValue.text = "\(pressureUnwrapped)" + " hPa"
        
        guard let humidityUnwrapped = viewModel.currentWeather?.main?.humidity else {return}
        self.humidityLabel.text = "Wilgotność"
        self.humidityValue.text = "\(humidityUnwrapped)" + " %"
        
        guard let windSpeedUnwrapped =  viewModel.currentWeather?.wind?.speed else {return}
        self.windspeedLabel.text = "Prędkość wiatru"
        self.windspeedValue.text = "\(windSpeedUnwrapped)" + " km/h"
            
        guard let visibilityUnwrapped = viewModel.currentWeather?.visibility else {return}
        self.visibilityLabel.text = "Widoczność"
        self.visibilityValue.text = "\(visibilityUnwrapped)" + " m"
        
        let date = Date()
        let dateFormmater = DateFormatter()
        dateFormmater.timeZone = TimeZone.current
        dateFormmater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.lastUpdatedLabel.text = "Zaktualizowane"
        self.lastUpdatedValue.text = "\(dateFormmater.string(from: date))"
    }
    
    func setUpBackground() {
        self.backgroudImage.contentMode = .scaleToFill
        UIView.animate(withDuration: 1) {
            self.backgroudImage.image = self.viewModel.providedBackgroundImage
            self.backgroudImage.alpha = 0
            self.backgroudImage.alpha = 1
        }
    }
}

extension DetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dailyWeatherArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "DailyTableViewCell",
            for: indexPath
        ) as? DailyTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(object: viewModel.dailyWeatherArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DetailsViewController: UICollectionViewDelegate,
                                 UICollectionViewDataSource,
                                 UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.hourlyWeatherArray.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "HourlyCollectionViewCell",
            for: indexPath) as? HourlyCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(object: viewModel.hourlyWeatherArray[indexPath.item])
        return cell
    }
}


