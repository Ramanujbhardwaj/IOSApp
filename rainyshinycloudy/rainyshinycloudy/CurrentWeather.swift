//
//  CurrentWeather.swift
//  rainyshinycloudy
//
//  Created by Ramanuj Bhardwaj on 12/1/17.
//  Copyright © 2017 Ramanuj Bhardwaj. All rights reserved.
//

import WebKit
import Alamofire

class CurrentWeather {
    
    var _cityName: String!
    var _date: String!
    var _weatherType: String!
    var _currentTemp: Double!
    
    var cityName:String{
        if _cityName == nil{
            _cityName = ""
        }
        return _cityName
    }
    
    
    var currentTemp:Double{
        if _currentTemp == nil{
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    var weatherType:String{
        if _weatherType == nil{
            _weatherType = ""
        }
        return _weatherType
    }
    
    var date:String{
        if _date == nil{
            _date = ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        return _date
    }
    
    func downloadWeatherDetails(completed: @escaping DownloadComplete){
        //Alamofire Download
        Alamofire.request(CURRENT_WEATHER_URL).responseJSON { response in
            
            
            if let dict = response.value as? Dictionary<String, AnyObject>{
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                    print(self._cityName)
                }
                
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>]{
                    if let main = weather[0]["main"] as? String{
                        self._weatherType = main
                        print(self._weatherType)
                    }
                }
                
                if let main = dict["main"] as? Dictionary<String, AnyObject>{
                    
                    if let currentTemp = main["temp"] as? Double{
                        
                        let kelvinToFarhenheithPreDivision = (currentTemp * (9/5) - 459.67)
                        let kelvinToFarhenheith = Double (round(10 * kelvinToFarhenheithPreDivision/10))
                        self._currentTemp = kelvinToFarhenheith
                        print(self._currentTemp)
                    }
                }
                
                }
            completed()
            }
        
        
        
        
    
    }
    
    
}
