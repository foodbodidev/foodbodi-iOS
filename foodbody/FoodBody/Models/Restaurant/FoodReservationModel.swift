//
//  FoodReservationModel.swift
//  FoodBody
//
//  Created by Toan Tran on 8/6/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import ObjectMapper
class FoodReservationModel: Mappable {
    var food_id: String = ""
    var amount:Int = 0;
    
    required init?(map: Map) {
        
    }
    
    init(food_id: String, amount: Int) {
        self.food_id = food_id
        self.amount = amount
    }
    
    
    func mapping(map: Map) {
        food_id <- map["food_id"]
        amount <- map["amount"]
        
    }
}
