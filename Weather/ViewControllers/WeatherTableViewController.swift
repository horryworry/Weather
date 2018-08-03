//
//  WeatherTableViewController.swift
//  Weather
//
//  Created by Atay Sultangaziev on 7/30/18.
//  Copyright © 2018 Atay Sultangaziev. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherTableViewController: UITableViewController, CLLocationManagerDelegate, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    var locationManager: CLLocationManager!
    var forecastData = [Weather]()
    var currentLocation: CLLocation!
    var startingViewController = StartingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = LocationManager.shared
        
        searchBar.delegate = self
        
        setupLocation()
        getForecastData()
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func listOfCities(_ sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextScene = storyboard.instantiateViewController(withIdentifier: "CitiesTableView") as! ListOfCities
        nextScene.vc = self
        self.navigationController?.pushViewController(nextScene, animated: true)
    }
    
    func getForecastData() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // Get the location from the device
            currentLocation = locationManager?.location
            Weather.forecast(withLocation: currentLocation.coordinate, completion: { (results:[Weather]!) in
                
                if let weatherData = results {
                    self.forecastData = weatherData
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
                
            })
        }
    }
    
    func setupLocation() {
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization() // Take Permission from the user
        locationManager.startUpdatingLocation()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty {
            updateWeatherForLocation(location: locationString)
        }
    }
    
    func updateWeatherForLocation (location:String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    Weather.forecast(withLocation: location.coordinate, completion: { (results:[Weather]?) in
                        
                        if let weatherData = results {
                            self.forecastData = weatherData
                            
                            self.reloadData()
                            
                        }
                        
                    })
                }
            }
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return forecastData.count - 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd"
        if section == 0 {
            return "Today"
        }
        return dateFormatter.string(from: date!)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let weatherObject = forecastData[indexPath.section]
        
        self.navigationTitle.title = weatherObject.timezone
        self.searchBar.placeholder = weatherObject.timezone
        cell.textLabel?.textColor = .black
        cell.textLabel?.text = weatherObject.summary
        cell.textLabel?.font = UIFont(name: "AmericanTypewriter-CondensedLight", size: 15)
        cell.textLabel?.numberOfLines = 1
        let temperatureCelsius = (Double(weatherObject.temperature) - 32) / 1.8
        cell.detailTextLabel?.textColor = .black
        cell.detailTextLabel?.text = "\(Int(temperatureCelsius)) °C"
        cell.detailTextLabel?.font = UIFont(name: "AmericanTypewriter-CondensedLight", size: 15)
        cell.imageView?.image = UIImage(named: weatherObject.icon)
        return cell
    }
}
