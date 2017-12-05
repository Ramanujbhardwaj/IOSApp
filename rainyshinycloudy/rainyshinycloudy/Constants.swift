//
//  Constants.swift
//  rainyshinycloudy
//
//  Created by Ramanuj Bhardwaj on 12/1/17.
//  Copyright © 2017 Ramanuj Bhardwaj. All rights reserved.
//

import Foundation

let BASE_URL = "http://samples.openweathermap.org/data/2.5/"

let BASE_CURRENT_URL = "http://api.openweathermap.org/data/2.5/"

let CURRENT_WEATHER = "weather?"

let FORECAST_WEATHER = "forecast?"

let LATITUDE = "lat="

let LONGITUDE = "&lon="

let WEATHER_COUNT = "&cnt="

let APP_ID = "&appid="

let API_KEY = "838ec84b0d0f78df02e181eb6581e9df"

let CURRENT_WEATHER_URL = "\(BASE_CURRENT_URL)\(CURRENT_WEATHER)\(LATITUDE)\(Location.sharedInstance.latitute!)\(LONGITUDE)\(Location.sharedInstance.longitude!)\(APP_ID)\(API_KEY)"

let FORECAST_WEATHER_URL = "\(BASE_CURRENT_URL)\(FORECAST_WEATHER)\(LATITUDE)\(Location.sharedInstance.latitute!)\(LONGITUDE)\(Location.sharedInstance.longitude!)\(APP_ID)\(API_KEY)"

typealias DownloadComplete = () -> ()


