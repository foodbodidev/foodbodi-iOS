//
//  ListDataSearchFodiMapModel.swift
//  FoodBody
//
//  Created by Toan Tran on 8/21/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import ObjectMapper
class ListDataSearchFodiMapModel: Mappable {
    var isSuccess: Bool = false
    var status_code: Int = -1
    var message: String = ""
    var data: [SearchFodiMapModel] = []
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        
        message <- map["message"]
        status_code <- map["status_code"]
        isSuccess = (status_code == 0) ? true : false
        data <- map["data"]
    }
}
