//
//  TripProductModel.swift
//  BDY
//
//  Created by 张联学 on 20/01/2016.
//  Copyright © 2016 gdt. All rights reserved.
//

import Foundation

class TripProduct: Equatable {
    var name: String
    var unitPrice: Double = 0.0
    var departureTime: String
    var unitNumber: Int = 0
    
    init(name: String, departureTime: String) {
        self.name = name
//        self.unitPrice = unitPrice
        self.departureTime = departureTime
//        self.unitNumber = unitNumber
    }
    
    func getProduct() -> TripProduct {
        return self
    }
}

func ==(lhs: TripProduct, rhs: TripProduct) -> Bool {
    return lhs.name == rhs.name && lhs.departureTime == rhs.departureTime
//    return lhs.name == rhs.name
}