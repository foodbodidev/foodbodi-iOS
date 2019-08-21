//
//  DocumentModel.swift
//  FoodBody
//
//  Created by Toan Tran on 8/21/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import ObjectMapper
class DocumentModel: Mappable {
    var restaurant_id: String = ""
    var name: String = ""
    var photo: String = ""
    var address:String = ""
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        
        name <- map["name"]
        restaurant_id <- map["restaurant_id"]
        photo <- map["photo"]
        address <- map["address"]
    }
}
