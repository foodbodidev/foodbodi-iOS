//
//  CategoryModel.swift
//  FoodBody
//
//  Created by Phuoc on 7/13/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import Foundation
import ObjectMapper


class CategoryModelData: Mappable  {
    
    
    var data: [String: CategoryModel]?
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        data <- map["data"]
    }
    
}



class CategoryModel: Mappable  {
    
    
    var key: String = ""
    var name: String = ""
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        key <- map["key"]
        name <- map["name"]
    }
    
}

