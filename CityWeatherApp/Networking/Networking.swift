//
//  Networking.swift
//  CityWeatherApp
//
//  Created by Andrew_Alekseyuk on 6.04.22.
//

import Foundation
import Alamofire
// import Combine
import RxSwift
import Kingfisher
import UIKit

class Networking {
    static let shared = Networking()
    //    @available(iOS 13.0, *)
    //    var currentWeatherSubject: CurrentValueSubject<CurrentWeather?, Error> {
    //        return  CurrentValueSubject<CurrentWeather?, Error>(nil)
    //    }
    
    //    @available(iOS 13.0, *)
    //    var forecastWeatherSubject: CurrentValueSubject<ForecastWeather?, Error> {
    //        return  CurrentValueSubject<ForecastWeather?, Error>(nil)
    //    }
    
    // let passErrorSubject = PassthroughSubject<Error, Error>()
    
    let rxCurrent = PublishSubject<CurrentWeather>()
    let rxForecast = PublishSubject<ForecastWeather>()
    let rxBackgroundImage = PublishSubject<UIImage>()
    let rxError = PublishSubject<Error>()
    
    let apiURL =  "https://api.openweathermap.org/data/2.5/"
    let currentWeatherSuffix = "weather?"
    let forecastWeatherSuffix = "onecall?exclude=minutely&"
    let key = "&appid=933feb1376f96226595f5a0c52d37cfc"
    let units = "&units=metric"
    
    func getCurrentWeather (lat: String, lon: String) {
        let latConponent = "lat=\(lat)"
        let lonConponent = "&lon=\(lon)"
        let deviceLanguage = String().languageComponent
        
        let requestURL = URL(string: apiURL + currentWeatherSuffix + latConponent + lonConponent + units + deviceLanguage + key)!
        print(requestURL)
        AF.request(
            requestURL,
            method: .get
        )
        .responseData { response in
            switch response.result {
            case .success (let data):
                do {
                    let recievedCurrentWeather = try JSONDecoder().decode(CurrentWeather.self, from: data)
                    // self.currentWeatherSubject.send(recievedCurrentWeather)
                    self.rxCurrent.onNext(recievedCurrentWeather)
                } catch (let error) {
                    self.rxError.onNext(error)
                }
            case .failure(let error):
                print(error.localizedDescription)
                // self.passErrorSubject.send(error)
                self.rxError.onNext(error)
            }
            
        }
    }
    
    func getForecastWeather (lat: String, lon: String) {
        let latConponent = "lat=\(lat)"
        let lonConponent = "&lon=\(lon)"
        let deviceLanguage = String().languageComponent
        
        let requestURL = URL(string: apiURL + forecastWeatherSuffix + latConponent + lonConponent + units + deviceLanguage + key)!
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            AF.request(
                requestURL,
                method: .get
            )
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let recievedForecastWeather = try JSONDecoder().decode(ForecastWeather.self, from: data)
                        // self.forecastWeatherSubject.send(recievedForecastWeather)
                        self.rxForecast.onNext(recievedForecastWeather)
                    } catch(let error) {
                        self.rxError.onNext(error)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    // self.passErrorSubject.send(error)
                    self.rxError.onNext(error)
                }
            }
        }
    }
    
    func getBackgroundImage() {
        KingfisherManager.shared.retrieveImage(with: URL(string: "https://picsum.photos/500/1200?blur=2")!, options: [.forceRefresh]) { result in
            switch result {
            case .success(let recievedImage):
                self.rxBackgroundImage.onNext(recievedImage.image.makeImageDarker())
            case .failure(let error):
                self.rxError.onNext(error)
            }
        }
    }
}
