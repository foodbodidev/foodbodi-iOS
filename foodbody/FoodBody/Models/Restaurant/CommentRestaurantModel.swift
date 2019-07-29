//
//  CommentRestaurantModel.swift
//  FoodBody
//
//  Created by Toan Tran on 7/29/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import ObjectMapper

class CommentRestaurantModel: NSObject,Mappable {
    var restaurant_id: String = ""
    var message: String = ""
    var creator: String = ""
    var created_date: NSInteger = 0
    var isSuccess: Bool = false
    var status_code: Int = -1
    init(restaurant_id: String, message: String) {
        self.restaurant_id = restaurant_id
        self.message = message
    }
    
    override init() {
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        restaurant_id <- map["data.restaurant_id"]
        message <- map["data.message"]
        creator <- map["data.creator"]
        created_date <- map["data.created_date"]
        message <- map["message"]
        status_code <- map["status_code"]
        isSuccess = (status_code == 0) ? true : false
    }
    
}

class CommentRequest: Mappable  {
    
    
    var restaurant_id: String = ""
    var message: String = ""
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        restaurant_id <- map["restaurant_id"]
        message <- map["message"]
    }
    
}
