//
//  LicenseModel.swift
//  FoodBody
//
//  Created by Phuoc on 7/30/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import Foundation
import ObjectMapper


class CompanyInfoModel: Mappable  {
    
    var company_name: String = ""
    var registration_number: String = ""
    var representative_name: [String] = []
    var address: String = ""
    var lat: Double = -1
    var lng: Double = -1
    
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        company_name <- map["name"]
        registration_number <- map["license.registration_number"]
        representative_name <- map["license.representative_name"]
        address <- map["address"]
        lat <- map["lat"]
        lng <- map["lng"]
    }
    
}

struct LicenseResponse: Mappable {
   
    var status_code: Int = -1
    var id: String = ""
    var isSuccess: Bool = false
    var message: String = ""
   
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        status_code <- map["status_code"]
        id <- map["data.id"]
        message <- map["message"]
        if status_code == 0 {
            isSuccess = true
        } else {
            isSuccess = false
        }
    }
}

