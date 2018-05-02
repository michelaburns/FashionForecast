//
//  WeatherAPI.swift
//  FashionForecast
//
//  Created by Emily Koagedal on 4/24/18.
//  Documented by Michela Burns on 4/25/18.
//  Copyright © 2018 Michela. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

struct Weather: Hashable {
    
    
    static func ==(lhs: Weather, rhs: Weather) -> Bool {
            return lhs.summary == rhs.summary && lhs.temperature == rhs.temperature
    }
    
    let summary: String         //Summaries of what weather is like (ex: sunny)
    let temperature: Double     //Temperature (ex: 98 degrees)
    
    var hashValue: Int {
        return summary.hashValue
    }
    
    enum SerializationError: Error {
        case missing(String)            //If were are looking for a key, but it is missing
        case invalid(String, Any)       //They data that we received does not work
    }
    
    //Serialization: Converts the json data into a dictionary
    init(json:[String:Any]) throws {
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("summary is missing")}
        guard let temperature = json["temperatureMax"] as? Double else {throw SerializationError.missing("temperature is missing")}
        
        //Initializes properties
        self.summary = summary
        self.temperature = temperature
    }
    
    //Base path for our API
    static let basePath = "https://api.darksky.net/forecast/f4931bea6d6133b0de50e7b810394aae/"
    
    //Function that gets forecast information and returns an array of weather objects
    static func forecast (withLocation location: CLLocation, completion: @escaping([Weather]) -> ()) {
        let lat = String(format: "%f", location.coordinate.latitude)
        let long = String(format: "%f", location.coordinate.longitude)

        let url = basePath + lat + "," + long
        let request = URLRequest(url: URL(string: url)!)
        
        //A data task that returns an array of weather objects
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            var forecastArray:[Weather] = []
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let hourlyForecast = json["hourly"] as? [String:Any] {
                            if let hourlyData = hourlyForecast["data"] as? [[String:Any]] {
                                for dataPoint in hourlyData {
                                    if let weatherObject = try? Weather(json: dataPoint) {
                                        forecastArray.append(weatherObject)
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
                completion(forecastArray)
            }
        }
        task.resume()
    }
}
