//
//  Location.swift
//  FashionForecast
//
//  Created by Owner on 5/2/18.
//  Copyright © 2018 Michela. All rights reserved.
//

import Foundation

class Location {
    
    static var sharedInstance = Location() //We will only have one object across the whole app
    
    var longitude: Double!
    var latitude: Double!
    
}
