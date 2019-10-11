//
//  RestaurantModel.swift
//  FoodBody
//
//  Created by Toan Tran on 7/7/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import ObjectMapper

class RestaurantModel: NSObject,Mappable {
    /*
     {
     "type" : "RESTAURANT",
     "category" : "FAST_FOOD",
     "name" : "ABC",
     "address" : "Chung cu phu hoa",
     "creator" : "String",
     "lat" : 10.986536,
     "lng" : 106.676812,
     "geohash" : "GeoHash",
     "open_hour" : "7:00",
     "close_hour" : "9:00"
     
     }
 */
    var type: String = ""
    var category: String = ""
    var name: String = ""
    var address: String = ""
    var creator: String = ""
    var lat: Double = -1
    var lng: Double = -1
    var geohash: String = ""
    var open_hour: String = ""
    var close_hour: String = ""
    var message: String = ""
    var priority: Int = -1
    var id: NSString = ""
    var isSuccess: Bool = false
    var status_code: Int = -1
    
    init(type: String, category: String, name: String,
         address: String, creator: String, lat: Double,
         lng: Double, geohash: String,open_hour:String,close_hour: String) {
        self.type = type
        self.category = category
        self.name = name
        self.address = address
        self.creator = creator
        self.lat = lat
        self.lng = lng
        self.geohash = geohash
        self.open_hour = open_hour
        self.close_hour = close_hour
    }
    
    override init() {
    }
    
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        type <- map["data.type"]
        category <- map["data.category"]
        name <- map["data.name"]
        address <- map["data.address"]
        creator <- map["data.creator"]
        lat <- map["data.lat"]
        lng <- map["data.lng"]
        geohash <- map["data.geohash"]
        open_hour <- map["data.open_hour"]
        close_hour <- map["data.close_hour"]
        status_code <- map["status_code"]
        priority <- map["priority"]
        id <- map["id"]
        message <- map["message"]
        isSuccess = (status_code == 0) ? true : false
    }
}
class RestaurantRequest: Mappable  {
    
    var id: String = ""
    var type: String = ""
    var category: String = ""
    var photos:[String] = [];
    var creator: String = ""
    var geohash: String = ""
    var open_hour: String = ""
    var close_hour: String = ""
    var lat:Double = 0;
    var lng:Double = 0;
	
	var isValidTime: Bool = false 
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapDataFromMyRestaurant(myRestaurant: MyRestaurant) {
        self.category = myRestaurant.category ?? ""
        self.photos = myRestaurant.photos
        self.open_hour = myRestaurant.open_hour ?? ""
        self.close_hour = myRestaurant.close_hour ?? ""
        self.type = myRestaurant.type ?? ""
        self.isValidTime = true // because this time has been validated
        self.lat = myRestaurant.lat ?? 0;
        self.lng = myRestaurant.lng ?? 0;
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        category <- map["category"]
        creator <- map["creator"]
        geohash <- map["geohash"]
        open_hour <- map["open_hour"]
        close_hour <- map["close_hour"]
		photos <- map["photos"]
    }
    
}


