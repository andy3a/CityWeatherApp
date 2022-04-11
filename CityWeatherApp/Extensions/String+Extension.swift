//
//  String+Extension.swift
//  CityWeatherApp
//
//  Created by Andrew_Alekseyuk on 8.04.22.
//

import Foundation

extension String {

    var languageComponent: String {
        guard let langStr = Locale.current.languageCode else {return "&lang=en"}
        return "&lang=" + langStr
    }
}
