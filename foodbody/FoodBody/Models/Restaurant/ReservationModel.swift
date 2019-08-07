//
//  ReservationModel.swift
//  FoodBody
//
//  Created by Toan Tran on 8/6/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import ObjectMapper

class ReservationResponse: Mappable {
    var restaurant_id: String = ""
    var owner: String = ""
    var created_date: NSInteger = 0
    var restaurant_name: String = ""
    var total: NSInteger = 0
    var foods: [FoodReservationModel] = []
    var id: String = ""
    var isSuccess: Bool = false
    var status_code: Int = -1
    var message: String = ""
    init(restaurant_id: String, message: String) {
        self.restaurant_id = restaurant_id
        self.message = message
    }
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        restaurant_id <- map["restaurant_id"]
        owner <- map["owner"]
        created_date <- map["created_date"]
        restaurant_name <- map["restaurant_name"]
        total <- map["total"]
        foods <- map["foods"]
        id <- map["id"]
        message <- map["message"]
        status_code <- map["status_code"]
        isSuccess = (status_code == 0) ? true : false
    }

}
class ReservationRequest: Mappable  {
    
    
    var restaurant_id: String = ""
    var foods: [FoodReservationModel] = []
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        restaurant_id <- map["restaurant_id"]
        foods <- map["foods"]
    }
    
}
