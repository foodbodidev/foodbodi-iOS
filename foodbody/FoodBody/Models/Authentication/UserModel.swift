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
  
    
    init(token: String, email: String, sex: String,
         height: Int, weight: Int, target_weight: Int,
         first_name: String, last_name: String, age: Int) {
        self.token = token
        self.email = email
        self.sex = sex
        self.height = height
        self.weight = weight
        self.target_weight = target_weight
        self.first_name = first_name
        self.last_name = last_name
        self.age = age
    }
    
    override init() {
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
        
        self.init(token: token, email: email, sex: sex, height: height, weight: weight, target_weight: target_weight, first_name: first_name, last_name: last_name, age: age)
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
    }
    
    func mapping(map: Map) {
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
        isSuccess = (status_code == 0) ? true : false
    }
    
}

class UserProfile: User { // user to map user when get user profile
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
		isSuccess = (status_code == 0) ? true : false
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
    }
    
}
