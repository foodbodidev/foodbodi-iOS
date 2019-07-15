//
//  FoodModel.swift
//  FoodBody
//
//  Created by Phuoc on 7/15/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import Foundation
import ObjectMapper


class FoodResponse: Mappable  {
    
    var isSuccess: Bool = false
    var status_code: Int = -1
    var message: String = ""
    var data: [FoodModel] = []
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        status_code <- map["status_code"]
        data <- map["data.foods"]
        message <- map["message"]
        isSuccess = (status_code == 0) ? true : false
    }
    
}

class FoodModel: Mappable  {
    var name: String = ""
    var restaurant_id: String = ""
    var creator: String = ""
    var calo: Int = 0
    var price: Int = 0
    var description: String = ""
    var created_date: String = ""
    var photo: String = ""
    var id: String = ""
    
    
    required init?(map: Map) {
        
    }
    
    
    func mapping(map: Map) {
        name <- map["name"]
        restaurant_id <- map["restaurant_id"]
        creator <- map["creator"]
        calo <- map["calo"]
        price <- map["price"]
        description <- map["description"]
        created_date <- map["created_date"]
        photo <- map["photo"]
        id <- map["id"]
    }
}

