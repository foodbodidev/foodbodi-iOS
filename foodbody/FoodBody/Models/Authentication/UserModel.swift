//
//  UserModel.swift
//  FoodBody
//
//  Created by Phuoc on 6/23/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import Foundation
import ObjectMapper


class User: NSObject, Mappable, NSCoding { 
    
    var token: String = ""
    var email: String = ""
    var sex: String = ""
    var height: Int = 0
    var weight: Int = 0
    var age: Int = 0
    var target_weight: Int = 0
    var last_name: String = ""
    var first_name: String = ""
    var isSuccess: Bool = false
    var status_code: Int = -1
    var message: String = ""
    var restaurantId: String = ""
    var daily_calo: Double = 2500
  
    
    init(token: String, email: String, sex: String,
         height: Int, weight: Int, target_weight: Int,
         first_name: String, last_name: String, age: Int,
         restaurantId: String,
         daily_calo: Double) {
        self.token = token
        self.email = email
        self.sex = sex
        self.height = height
        self.weight = weight
        self.target_weight = target_weight
        self.first_name = first_name
        self.last_name = last_name
        self.age = age
        self.restaurantId = restaurantId
        self.daily_calo = daily_calo
    }
    
    required init?(map: Map) {
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let token = aDecoder.decodeObject(forKey: "token") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let sex = aDecoder.decodeObject(forKey: "sex") as! String
        let first_name = aDecoder.decodeObject(forKey: "first_name") as! String
        let last_name = aDecoder.decodeObject(forKey: "last_name") as! String
        
        let age = aDecoder.decodeInteger(forKey: "age")
        let height = aDecoder.decodeInteger(forKey: "height")
        let weight = aDecoder.decodeInteger(forKey: "weight")
        let target_weight = aDecoder.decodeInteger(forKey: "target_weight")
        
        let restaurantId = aDecoder.decodeObject(forKey: "restaurantId") as! String
        
        let daily_calo = aDecoder.decodeDouble(forKey: "daily_calo")
        
        self.init(token: token, email: email, sex: sex, height: height, weight: weight, target_weight: target_weight, first_name: first_name, last_name: last_name, age: age,
                  restaurantId: restaurantId, daily_calo: daily_calo)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(token, forKey: "token")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(sex, forKey: "sex")
        aCoder.encode(first_name, forKey: "first_name")
        aCoder.encode(last_name, forKey: "last_name")
        aCoder.encode(age, forKey: "age")
        aCoder.encode(height, forKey: "height")
        aCoder.encode(weight, forKey: "weight")
        aCoder.encode(target_weight, forKey: "target_weight")
        aCoder.encode(restaurantId, forKey: "restaurantId")
        aCoder.encode(daily_calo, forKey: "daily_calo")
    }
    
    func mapping(map: Map) {
        token <- map["data.token"]
        email <- map["data.user.email"]
        sex <- map["data.user.sex"]
        height <- map["data.user.height"]
        weight <- map["data.user.weight"]
        target_weight <- map["data.user.target_weight"]
        age <- map["data.user.age"]
        first_name <- map["data.user.first_name"]
        last_name <- map["data.user.last_name"]
        status_code <- map["status_code"]
        message <- map["message"]
        daily_calo <- map["data.user.daily_calo"]
        isSuccess = (status_code == 0) ? true : false
    }
    
}

class UserProfile: User { // user to map user when get user profile
    var myRestaurant: [MyRestaurant] = []
    
	override func mapping(map: Map) {
		token <- map["data.token"]
		email <- map["data.email"]
		sex <- map["data.sex"]
		height <- map["data.height"]
		weight <- map["data.weight"]
		target_weight <- map["data.target_weight"]
		age <- map["data.age"]
		first_name <- map["data.first_name"]
		last_name <- map["data.last_name"]
		status_code <- map["status_code"]
		message <- map["message"]
        myRestaurant <- map["data.restaurants"]
		isSuccess = (status_code == 0) ? true : false
        daily_calo <- map["data.daily_calo"]
	}
}



class UserRequest: Mappable  {
    
    
    var email: String?
    var password: String?
    var sex: String?
    var height: Int?
    var weight: Int?
    var age: Int?
    var firstName: String?
    var lastName: String?
    var target_weight: Int?
    var facebook_access_token: String?
    var userId: String?
    var google_id_token: String?
    var daily_calo: Int?
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    //login.
    init(email:String, password:String) {
        self.email = email;
        self.password = password;
    }
    
    func mapping(map: Map) {
        email <- map["email"]
        password <- map["password"]
        sex <- map["sex"]
        height <- map["height"]
        weight <- map["weight"]
        age <- map["age"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        target_weight <- map["target_weight"]
        facebook_access_token <- map["facebook_access_token"]
        userId <- map["user_id"]
        google_id_token <- map["google_id_token"]
        daily_calo <- map["daily_calo"]
    }
    
}


class MyRestaurant: NSObject, NSCoding, Mappable {
    
    
    required init?(map: Map) {
        self.photos = Array.init();
    }
    

    var name: String?
    var creator: String?
    var priority: Int?
    var created_date: String?
	var address: String?
	var lat: Float?
	var lng: Float?
	var id: String?
	var type: String?
	var category: String?
	var open_hour: String?
	var close_hour: String?
    var photos:[String]
    
    
    
    func mapping(map: Map) {
        name <- map["name"]
        creator <- map["creator"]
        priority <- map["priority"]
        created_date <- map["created_date"]
		address <- map["address"]
		lat <- map["lat"]
		lng <- map["lng"]
		type <- map["type"]
		category <- map["category"]
		open_hour <- map["open_hour"]
		close_hour <- map["close_hour"]
		id <- map["id"]
		created_date <- map["created_date"]
        photos <- map["photos"]
    }
    
    init(category: String?,type: String?,photos:[String], name: String?, address: String?, open_hour: String?, close_hour: String?) {
        self.category = category
        self.photos = photos
        self.name = name
        self.address = address
        self.open_hour = open_hour
        self.close_hour = close_hour
        self.type = type
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let category = aDecoder.decodeObject(forKey: "category") as? String
        let photos = aDecoder.decodeObject(forKey: "photos") as? [String] ?? Array.init()
        let name = aDecoder.decodeObject(forKey: "name") as? String
        let address = aDecoder.decodeObject(forKey: "address") as? String
        let open_hour = aDecoder.decodeObject(forKey: "open_hour") as? String
        let close_hour = aDecoder.decodeObject(forKey: "close_hour") as? String
        let type = aDecoder.decodeObject(forKey: "type") as? String
        
        
        self.init(category: category, type: type, photos: photos,name: name, address: address, open_hour: open_hour, close_hour: close_hour)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(category, forKey: "category")
        aCoder.encode(photos, forKey: "photos")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(open_hour, forKey: "open_hour")
        aCoder.encode(close_hour, forKey: "close_hour")
        aCoder.encode(type, forKey: "type")
    }
}
