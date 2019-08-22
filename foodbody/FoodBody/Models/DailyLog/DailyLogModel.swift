//
//  DailyLogModel.swift
//  FoodBody
//
//  Created by Phuoc on 8/12/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import Foundation
import ObjectMapper

class DailyLogModel: Mappable  {
    
    var step: Int?
    var calo_threshold: Double?
    var remain_calo: Double?
    var date: String?
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        step <- map["step"]
        calo_threshold <- map["calo_threshold"]
        remain_calo <- map["remain_calo"]
        date <- map["date"]
    }
    
}

class DailyLogResponseModel: Mappable  {
    
    var step: Int?
    var calo_threshold: Double?
    var total_eat: Double?
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        step <- map["data.step"]
        calo_threshold <- map["data.calo_threshold"]
        total_eat <- map["data.total_eat"]
    }
    
}


