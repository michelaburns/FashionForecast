//
//  ViewController.swift
//  FashionForecast
//
//  Created by Owner on 4/22/18.
//  Copyright © 2018 Michela. All rights reserved.
//

import UIKit
import CoreLocation //Allows us to use GPS

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //Outlets
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var OutfitSuggestionsLabel: UILabel!
    @IBOutlet weak var doubleBorder: UIImageView!
    @IBOutlet weak var outfitImage: UIImageView!
    
    //Constants
    let locationManager = CLLocationManager()
    
    //Variables
    var currentWeather:CurrentWeather!
    var currentLocation:CLLocation!
    var outfitArray: [UIImage] = []
    var arrayIndex = 0
    var myCloset: [UIImage] = []

    var snowOutfits = [#imageLiteral(resourceName: "snow1"), #imageLiteral(resourceName: "snow2"), #imageLiteral(resourceName: "snow3"), #imageLiteral(resourceName: "snow4"), #imageLiteral(resourceName: "snow5"), #imageLiteral(resourceName: "snow6"), #imageLiteral(resourceName: "snow7"), #imageLiteral(resourceName: "snow8"), #imageLiteral(resourceName: "snow9"),#imageLiteral(resourceName: "snow10"), #imageLiteral(resourceName: "snow11"), #imageLiteral(resourceName: "snow12")]
    var sunnyOutfits = [#imageLiteral(resourceName: "sunny1"), #imageLiteral(resourceName: "sunny2"), #imageLiteral(resourceName: "sunny3"), #imageLiteral(resourceName: "sunny4"), #imageLiteral(resourceName: "sunny5"), #imageLiteral(resourceName: "sunny6"), #imageLiteral(resourceName: "sunny7"), #imageLiteral(resourceName: "sunny8"), #imageLiteral(resourceName: "sunny9"), #imageLiteral(resourceName: "sunny10"), #imageLiteral(resourceName: "sunny11"), #imageLiteral(resourceName: "sunny12"), #imageLiteral(resourceName: "sunny13"), #imageLiteral(resourceName: "sunny14"), #imageLiteral(resourceName: "sunny15"), #imageLiteral(resourceName: "sunny16"), #imageLiteral(resourceName: "sunny17"), #imageLiteral(resourceName: "sunny18"), #imageLiteral(resourceName: "sunny19"), #imageLiteral(resourceName: "sunny20"), #imageLiteral(resourceName: "sunny21"), #imageLiteral(resourceName: "sunny22"), #imageLiteral(resourceName: "sunny23"), #imageLiteral(resourceName: "sunny24"), #imageLiteral(resourceName: "sunny25"), #imageLiteral(resourceName: "sunny26"), #imageLiteral(resourceName: "sunny27"), #imageLiteral(resourceName: "sunny28"), #imageLiteral(resourceName: "sunny29"), #imageLiteral(resourceName: "sunny30"), #imageLiteral(resourceName: "sunny31"), #imageLiteral(resourceName: "sunny32"), #imageLiteral(resourceName: "sunny33"), #imageLiteral(resourceName: "sunny34"), #imageLiteral(resourceName: "sunny35"), #imageLiteral(resourceName: "sunny36"), #imageLiteral(resourceName: "sunny27")]
    var mildOutfits = [#imageLiteral(resourceName: "mild1"), #imageLiteral(resourceName: "mild2"), #imageLiteral(resourceName: "mild3"), #imageLiteral(resourceName: "mild4"), #imageLiteral(resourceName: "mild5"), #imageLiteral(resourceName: "mild6"), #imageLiteral(resourceName: "mild7"), #imageLiteral(resourceName: "mild8"), #imageLiteral(resourceName: "mild9"), #imageLiteral(resourceName: "mild10"), #imageLiteral(resourceName: "mild11"), #imageLiteral(resourceName: "mild12"), #imageLiteral(resourceName: "mild13"), #imageLiteral(resourceName: "mild14"), #imageLiteral(resourceName: "mild15"), #imageLiteral(resourceName: "mild16"), #imageLiteral(resourceName: "mild17"), #imageLiteral(resourceName: "mild18"), #imageLiteral(resourceName: "mild19"), #imageLiteral(resourceName: "mild20"), #imageLiteral(resourceName: "mild21"), #imageLiteral(resourceName: "mild22"), #imageLiteral(resourceName: "mild23"), #imageLiteral(resourceName: "mild24"), #imageLiteral(resourceName: "mild25"), #imageLiteral(resourceName: "mild26"), #imageLiteral(resourceName: "mild27"), #imageLiteral(resourceName: "mild28")]
    var rainOutfits = [#imageLiteral(resourceName: "rain1"), #imageLiteral(resourceName: "rain2"), #imageLiteral(resourceName: "rain3"), #imageLiteral(resourceName: "rain4"), #imageLiteral(resourceName: "rain5"), #imageLiteral(resourceName: "rain6"), #imageLiteral(resourceName: "rain7"), #imageLiteral(resourceName: "rain8"), #imageLiteral(resourceName: "rain9"), #imageLiteral(resourceName: "rain10"), #imageLiteral(resourceName: "rain11"), #imageLiteral(resourceName: "rain12")]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI hardcoding
        
        //Borders
        doubleBorder.layer.borderColor = UIColor.black.cgColor
        doubleBorder.layer.borderWidth = 3
        
        //Swipe functionality
        outfitImage.isUserInteractionEnabled = true
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        outfitImage.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        outfitImage.addGestureRecognizer(swipeLeft)
        
        callDelegates()
        currentWeather = CurrentWeather()
        setupLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationAuthCheck() //App has opened so it's time to ask for permission
        
        
    }
    
    func callDelegates() {
        locationManager.delegate = self
    }
    
    func setupLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() //Ask to run the GPS when the app is open and when user grants permission
        locationManager.startMonitoringSignificantLocationChanges() //Inform location manager that it can use GPS and only pull it when big changes in location occur
    }
    
    //Check whether user has authorized app to get their location
    func locationAuthCheck() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse { //User did allow location services
            
            //Get the location from the device
            currentLocation = locationManager.location
            
            //Pass device's coordinates to the API
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            
            //Download the API data
            currentWeather.downloadCurrentWeather {
                self.updateUI() //Update the UI after the download is complete
            }
        }
            
        else { //User did not allow location services, so request for permission again
            locationManager.requestWhenInUseAuthorization()
            locationAuthCheck() //Make a check
        }
    }
    
    @objc func swipeGesture(sender: UISwipeGestureRecognizer) {
        if let swipeGesture = sender as? UISwipeGestureRecognizer
        {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swipe right")
                myCloset.append(outfitArray[arrayIndex]) //add right swiped items to closet
                outfitImage.image = outfitArray[arrayIndex+1]
                
            case UISwipeGestureRecognizerDirection.left:
                print("Swipe left")
                outfitImage.image = outfitArray[arrayIndex+1]
            default:
                break
            }
        }
    }
    
    func updateUI(){
        temperatureLabel.text = "\(currentWeather.currentTemp)" + " °F" + " | " + currentWeather.weatherType
        //weatherIcon.image = currentWeather.weatherImage
        
        //Rainy Outfits
        if (currentWeather.weatherType.contains("Rain") || currentWeather.weatherType.contains("Mist"))
        {
            outfitArray = rainOutfits
            outfitImage.image = outfitArray[arrayIndex]
        }
        
        //Mild Outfits
        else if (currentWeather.weatherType.contains("Cloud") || currentWeather.currentTemp<70)
        {
            outfitArray = mildOutfits
            outfitImage.image = outfitArray[arrayIndex]
        }

        //Sunny Outfits
        else if (currentWeather.currentTemp>=70 || currentWeather.weatherType.contains("Clear"))
        {
            outfitArray = sunnyOutfits
            outfitImage.image = outfitArray[arrayIndex]
        }
        
        //Snow Outfits
        else if (currentWeather.weatherType.contains("Snow"))
        {
            outfitArray = snowOutfits
            outfitImage.image = outfitArray[arrayIndex]
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

