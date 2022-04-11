//
//  SavedSearchResult.swift
//  CityWeatherApp
//
//  Created by Andrew_Alekseyuk on 7.04.22.
//

import Foundation

class SavedSearchResult: Codable {
   
    var title: String
    var lat: Double
    var lon: Double
    
    init(title: String, lat: Double, lon: Double) {
        self.title = title
        self.lat = lat
        self.lon = lon
    }
}
