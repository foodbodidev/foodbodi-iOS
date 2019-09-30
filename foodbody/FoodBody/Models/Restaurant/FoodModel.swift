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
    var restaurant_id: String = AppManager.restaurant?.id ?? "";
    var creator: String = ""
    var calo: Double = 0
    var price: Double = 0
    var description: String = ""
    var created_date: String = ""
    var photo: String = ""
    var id: String = ""
    var amount:Double = 0;
    
    var image: UIImage?  // use for displaying layout

    
    
    
    required init?(map: Map) {
        
    }
    
    init(name: String, price: Double, calo: Double) {
        self.name = name
        self.price = price
        self.calo = calo
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
        amount <- map["amount"]
    }
}

