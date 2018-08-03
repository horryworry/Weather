//
//  ListOfCitiesController.swift
//  WeatherApp
//
//  Created by Atay Sultangaziev on 6/2/18.
//  Copyright © 2018 Atay Sultangaziev. All rights reserved.
//

import UIKit

class ListOfCities: UITableViewController {
    
    var vc: WeatherTableViewController = WeatherTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var cities = ["Bishkek", "London", "New York", "Almaty", "Moscow", "Kyiv"]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        
        cell.textLabel?.textColor = .black
        cell.textLabel?.text = cities[indexPath.section]
        cell.textLabel?.font = UIFont(name: "AmericanTypewriter-CondensedLight", size: 17)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
        
        vc.updateWeatherForLocation(location: cities[indexPath.section])
        vc.searchBar.text = "\(cities[indexPath.section])"
    }
    
}
