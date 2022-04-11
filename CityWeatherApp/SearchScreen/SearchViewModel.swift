//
//  SearchViewModel.swift
//  CityWeatherApp
//
//  Created by Andrew_Alekseyuk on 11.04.22.
//

import Foundation
import MapKit
import RxSwift

class SearchViewModel {
    
    let viewController: SearchViewController!
    
    init(viewController: SearchViewController) {
        self.viewController = viewController
        setUpRX()
    }
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var savedSearchResults: [SavedSearchResult] = [] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(savedSearchResults) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "data")
            }
        }
    }
    // var cancellable = Set<AnyCancellable>()
    var selectedCell: ResultTableViewCell?
    
    func setUpRX() {
        _ = Observable.zip(
            Networking.shared.rxCurrent,
            Networking.shared.rxForecast,
            Networking.shared.rxBackgroundImage
        )
        .subscribe(onNext: { current, forecast, backgroundImage  in
            self.viewController.navigateToDetails(currentWeather: current, forecastWeather: forecast, backgroundImage: backgroundImage)
        })
        
        _ =  Networking.shared.rxError
            .subscribe( onNext: { error in
                self.viewController.showAlert(error: error.localizedDescription)
            })
    }
    
    func requestData(lat: String, lon: String) {
        Networking.shared.getCurrentWeather(
            lat: lat,
            lon: lon
        )
        Networking.shared.getForecastWeather(
            lat: lat,
            lon: lon
        )
        Networking.shared.getBackgroundImage()
    }
}
