//
//  ListReservationResponse.swift
//  FoodBody
//
//  Created by Toan Tran on 8/7/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import ObjectMapper

class ListReservationResponse: Mappable {
    var isSuccess: Bool = false
    var status_code: Int = -1
    var message: String = ""
    var data: [ReservationResponse] = []
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        status_code <- map["status_code"]
        data <- map["data.reservations"]
        message <- map["message"]
        isSuccess = (status_code == 0) ? true : false
    }

}
