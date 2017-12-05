//
//  WeatherCell.swift
//  rainyshinycloudy
//
//  Created by Ramanuj Bhardwaj on 12/4/17.
//  Copyright © 2017 Ramanuj Bhardwaj. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var weatherType: UILabel!
    
    @IBOutlet weak var highTemp: UILabel!
    
    @IBOutlet weak var lowTemp: UILabel!
    
    func configureCellForecast(forecast: Forecast){
        lowTemp.text = forecast.lowTemp
        highTemp.text = forecast.highTemp
        weatherType.text = forecast.weatherType
        dayLabel.text = forecast.date
        weatherIcon.image = UIImage(named: forecast.weatherType)
        
    }
   

}
