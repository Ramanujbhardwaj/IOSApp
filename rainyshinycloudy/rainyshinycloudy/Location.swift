//
//  Location.swift
//  rainyshinycloudy
//
//  Created by Ramanuj Bhardwaj on 12/4/17.
//  Copyright © 2017 Ramanuj Bhardwaj. All rights reserved.
//

import CoreLocation

class Location{
    static var sharedInstance = Location()
    private init(){
        
    }
    
    var latitute: Double!
    var longitude: Double!
}
