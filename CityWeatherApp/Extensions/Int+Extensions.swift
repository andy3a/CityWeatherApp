//
//  Int+Extensions.swift
//  CityWeatherApp
//
//  Created by Andrew_Alekseyuk on 8.04.22.
//

import Foundation

extension Int {
    func defineDayOfWeek() -> String {
        switch self {
        case 1:
            return "Poniedziałek"
        case 2:
            return "Wtorek"
        case 3:
            return "Środa"
        case 4:
            return "Czwartek"
        case 5:
            return "Piątek"
        case 6:
            return "Sobota"
        case 7:
            return "Niedziela"
        
        default:
            print("error defining dayOfWeek")
            return ""
        }
    }
}
