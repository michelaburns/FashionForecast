//
//  Extensions.swift
//  FashionForecast
//
//  Created by Owner on 5/1/18.
//  Copyright © 2018 Michela. All rights reserved.
//

import Foundation

extension Double {
    ///Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

