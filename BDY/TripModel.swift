//
//  TripModel.swift
//  BDY
//
//  Created by 张联学 on 18/12/2015.
//  Copyright © 2015 gdt. All rights reserved.
//

import UIKit

class Trip: NSObject {
    
    // Mark: Properties
    var id: Int
    var image: UIImage?
    var name: String
    var locations: [String]
    var coverHint: NSAttributedString
    
    // Mark: Initialization
    init?(id: Int, image: UIImage?, name: String, locations: [String], coverHint: NSAttributedString) {
        self.id = id
        self.image = image
        self.name = name
        self.locations = locations
        self.coverHint = coverHint
        super.init()
        
        // Initialization should fail if there is no name.
        if name.isEmpty || locations.isEmpty{
            return nil
        }
    }
}