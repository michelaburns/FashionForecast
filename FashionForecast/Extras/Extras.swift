//
//  Extras.swift
//  FashionForecast
//
//  Created by Owner on 5/1/18.
//  Copyright © 2018 Michela. All rights reserved.
//

import Foundation

let api_url = "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&appid=6d587caae0a41f63ce8ae0c636386eae"

//Completion Handler
typealias DownloadComplete = () -> ()
