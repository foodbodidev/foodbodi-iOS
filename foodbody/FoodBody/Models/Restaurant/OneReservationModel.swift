//
//  OneReservationModel.swift
//  FoodBody
//
//  Created by Toan Tran on 8/8/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import ObjectMapper

class OneReservationModel: Mappable {
    var restaurant: RestaurantRequest = RestaurantRequest()
    
    
    var foods: [String: FoodModel] = [:]
    var reservation: ReservationRequest = ReservationRequest()
    var isSuccess: Bool = false
    var status_code: Int = -1
    var message: String = ""
    
    required init?(map: Map) {
        
    }
    init() {
        
    }
    func mapping(map: Map) {
        restaurant <- map["data.restaurant"]
        foods <- map["data.foods"]
        reservation <- map["data.reservation"]
        message <- map["message"]
        status_code <- map["status_code"]
        isSuccess = (status_code == 0) ? true : false
    }
}
