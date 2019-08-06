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
    var created_date: String = ""
    var restaurant_name: NSInteger = 0
    var total: NSInteger = 0
    var foods:NSMutableArray = NSMutableArray.init();
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
        restaurant_id <- map["data.restaurant_id"]
        owner <- map["data.owner"]
        created_date <- map["data.created_date"]
        restaurant_name <- map["data.restaurant_name"]
        total <- map["data.total"]
        foods <- map["data.foods"]
        id <- map["data.id"]
        message <- map["message"]
        status_code <- map["status_code"]
        isSuccess = (status_code == 0) ? true : false
    }

}
class ReservationRequest: Mappable  {
    
    
    var restaurant_id: String = ""
    var foods: NSMutableArray = NSMutableArray.init();
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        restaurant_id <- map["restaurant_id"]
        foods <- map["foods"]
    }
    
}
