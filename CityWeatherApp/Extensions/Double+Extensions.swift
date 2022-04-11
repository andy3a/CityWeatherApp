//
//  Double+Extensions.swift
//  CityWeatherApp
//
//  Created by Andrew_Alekseyuk on 11.04.22.
//

import UIKit

extension Double {
    
    var colorizedTemp: UIColor {
        switch self {
        case ..<10.0:
            return .blue
        case 10.0...20.0:
            return .black
        case 20.0...:
            return .red
        default:
            return .white
        }
    }
}
