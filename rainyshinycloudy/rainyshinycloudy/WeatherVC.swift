//
//  WeatherVC.swift
//  rainyshinycloudy
//
//  Created by Ramanuj Bhardwaj on 11/28/17.
//  Copyright © 2017 Ramanuj Bhardwaj. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var currentDateLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentCityLabel: UILabel!
    
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var currentWeatherImageLabel: UIImageView!
    
    let locationManger = CLLocationManager()
    var currentLocation: CLLocation!
    
    var currentWeather: CurrentWeather!
    var forecast: Forecast!
    var forcasts = [Forecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        locationManger.startMonitoringSignificantLocationChanges()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }

 
    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            locationManger.requestLocation()
            //Here we are setting the location co-ordinates in currentLocation variable.
            //We will be changing the info.plist for location i.e. privacylocation when in use.
        }else{
            locationManger.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let userLocation = locations[0] as CLLocation
        

        Location.sharedInstance.latitute = userLocation.coordinate.latitude
        Location.sharedInstance.longitude = userLocation.coordinate.longitude
        //update UI with new data
        currentWeather = CurrentWeather()
        currentWeather.downloadWeatherDetails{
            //update ui
            self.downloadForecastData{
                //Update UI
                self.tableView.reloadData()
                self.updateMainUI()
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //If requestLocation() fails then default to San Francisco Coordinates
        Location.sharedInstance.latitute = 37.785834
        Location.sharedInstance.longitude = -122.406417
        
        //Update UI with default data
        currentWeather = CurrentWeather()
        currentWeather.downloadWeatherDetails{
            //update ui
            self.downloadForecastData{
                //Update UI
                self.tableView.reloadData()
                self.updateMainUI()
            }
        }
    }
    
    
    
    func downloadForecastData(completed: @escaping DownloadComplete){
        //Downloading Forecast data for our tableview.
        Alamofire.request(FORECAST_WEATHER_URL).responseJSON { response in
            
            
            if let dict = response.value as? Dictionary<String, AnyObject>{
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    for obj in list{
                        let forecast = Forecast(weatherDictionary : obj)
                        self.forcasts.append(forecast)
                        
                    }
                }
                self.forcasts.remove(at: 0)// removing the first index since forecast shld display from next day.
                self.tableView.reloadData()
            }
            completed()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forcasts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell{
            let forecast = forcasts[indexPath.row]
            cell.configureCellForecast(forecast: forecast)
            return cell
        }else{
            return WeatherCell()
        }
        
        
    }
    func updateMainUI(){
        print( "\(currentWeather.currentTemp)")
        currentDateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)"
        currentCityLabel.text = currentWeather.cityName
        currentWeatherLabel.text = currentWeather.weatherType
        currentWeatherImageLabel.image = UIImage(named: currentWeather._weatherType)
    }
    
}

