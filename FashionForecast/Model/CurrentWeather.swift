//
//  CurrentWeather.swift
//  FashionForecast
//
//  Created by Owner on 5/1/18.
//  Copyright © 2018 Michela. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CurrentWeather {
    
    //Private Variables
    private var _currentTemp: Double!
    private var _weatherType: String!
    //private var _weatherImage: String!
    
    //Data (which is accesible to other classes)
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
 
    
    /*
    var weatherImage: String {
        if _weatherImage == nil {
            _weatherImage = ""
        }
        return _weatherImage
    }
    */
    
    func downloadCurrentWeather(completed: @escaping DownloadComplete) {
        Alamofire.request(api_url).responseJSON { (response) in
            let result = response.result
            let json = JSON(result.value)
            
            let downloadedTemp = json["main"]["temp"].double
           //conversion to degrees fahrenheit
            self._currentTemp = (1.8 * (downloadedTemp!-273) + 32).rounded(toPlaces: 1)
            
            self._weatherType = json["weather"][0]["main"].stringValue
            
            print(self._weatherType)
            
            //self._weatherImage = json["weather"][0]["icon"].stringValue
            
            completed()
        }
        
    }
    
}
