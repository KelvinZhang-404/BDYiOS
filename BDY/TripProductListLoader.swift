//
//  TripProductListLoader.swift
//  BDY
//
//  Created by 张联学 on 21/01/2016.
//  Copyright © 2016 gdt. All rights reserved.
//

import Foundation

class TripProductListLoader {
    static var tripProductList: [TripProduct] = []
    
    func setList(productList: [TripProduct]) {
        TripProductListLoader.tripProductList = productList
    }
    
    func getList() -> [TripProduct] {
        return TripProductListLoader.tripProductList
    }
}