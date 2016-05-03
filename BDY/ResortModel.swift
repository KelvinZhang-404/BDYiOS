//
//  ResortModel.swift
//  BDY
//
//  Created by 张联学 on 7/01/2016.
//  Copyright © 2016 gdt. All rights reserved.
//

import UIKit

class Resort {
    var name: String
    var location: String
    var website: String
    var image: UIImage?
    var latitude: Double
    var longitude: Double
    var distance: String
    
    init(name: String, location: String, website: String, image: UIImage?, latitude: Double, longitude: Double, distance: String) {
        self.name = name
        self.location = location
        self.website = website
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
        self.distance = distance
    }
}