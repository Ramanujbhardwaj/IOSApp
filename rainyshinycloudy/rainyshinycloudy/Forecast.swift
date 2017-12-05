//
//  Forecast.swift
//  rainyshinycloudy
//
//  Created by Ramanuj Bhardwaj on 12/3/17.
//  Copyright © 2017 Ramanuj Bhardwaj. All rights reserved.
//

import UIKit



class Forecast{
    
    var _date: String!
    
    var _weatherType: String!
    
    var _highTemp: String!
    
    var _lowTemp: String!
    
    
    var highTemp:String{
        if _highTemp == nil{
            _highTemp = ""
        }
        return _highTemp
    }
    
    var lowTemp:String{
        if _lowTemp == nil{
            _lowTemp = ""
        }
        return _lowTemp
    }
    
    var weatherType:String{
        if _weatherType == nil{
            _weatherType = ""
        }
        return _weatherType
    }
    
    var date:String{
        
        if _date == nil {
            _date = ""
        }
        return _date
    }
    
    init(weatherDictionary: Dictionary<String, AnyObject>){
        
        if let temp = weatherDictionary["main"] as? Dictionary<String, AnyObject>{
            
            if let min = temp["temp_min"] as? Double{
                let kelvinToFarhenheithPreDivision = (min * (9/5) - 459.67)
                let kelvinToFarhenheith = Double (round(10 * kelvinToFarhenheithPreDivision/10))
                self._lowTemp = "\(kelvinToFarhenheith)"

            }
            
            if let max = temp["temp_max"] as? Double{
                let kelvinToFarhenheithPreDivision = (max * (9/5) - 459.67)
                let kelvinToFarhenheith = Double (round(10 * kelvinToFarhenheithPreDivision/10))
                self._highTemp = "\(kelvinToFarhenheith)"
                
            }
        }
        
        if let weather = weatherDictionary["weather"] as? [Dictionary<String, AnyObject>]{
            if let main = weather[0]["main"] as? String{
                self._weatherType = main
            }
        }
        
        if let date = weatherDictionary["dt"] as? Double{
            let unixDateConverter = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.timeStyle = .none
            self._date = unixDateConverter.dayOfTheWeek()
        }
    }
}

extension Date{
    func dayOfTheWeek() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // This is the code which says i want full name of day of the week.
        return dateFormatter.string(from: self) //Returning from self since we are getting the date from the same controller and not from somewhere else from.
    }
    
}






