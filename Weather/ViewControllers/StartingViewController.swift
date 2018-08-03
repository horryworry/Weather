//
//  StartingViewController.swift
//  Weather
//
//  Created by Atay Sultangaziev on 7/30/18.
//  Copyright © 2018 Atay Sultangaziev. All rights reserved.
//
import UIKit
import CoreLocation

class StartingViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var forecastData = [Weather]()
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocation()
        
    }
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        getInfo()
    }
    
    func getInfo() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            Weather.forecast(withLocation: currentLocation.coordinate, completion: { (results:[Weather]!) in
                
                if let weatherData = results {
                    self.forecastData = weatherData
                    
                    let weatherObject = self.forecastData[0]
                    let temperatureCelsius = (Double(weatherObject.temperature) - 32) / 1.8
                    
                    DispatchQueue.main.async {
                        self.cityLabel.text = weatherObject.timezone
                        self.temperatureLabel.text = "\(Int(temperatureCelsius))"
                    }
                }
                
            })
        }
    }
    

}
