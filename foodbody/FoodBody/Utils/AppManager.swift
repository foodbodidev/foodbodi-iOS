//
//  AppManager.swift
//  FoodBody
//
//  Created by Phuoc on 7/1/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import Foundation


struct AppManager {
    
    static var user: User? {
        get {
            guard let decoded = UserDefaults.standard.object(forKey: defaultsKeys.kUserlogin) else {
                return nil
            }
            
            guard let user = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded as! Data) as? User else {
                return nil
            }
            
            return user
        }
        set {
            if newValue == nil {
                UserDefaults.standard.set(nil, forKey: defaultsKeys.kUserlogin)
            } else {
                 let encodeData = NSKeyedArchiver.archivedData(withRootObject: newValue!)
                UserDefaults.standard.set(encodeData, forKey: defaultsKeys.kUserlogin)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    static var restaurant: MyRestaurant? {
        get {
            guard let decoded = UserDefaults.standard.object(forKey: defaultsKeys.kRestaurant) else {
                return nil
            }
            
            guard let restaurant = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded as! Data) as? MyRestaurant else {
                return nil
            }
            
            return restaurant
        }
        set {
            if newValue == nil {
                UserDefaults.standard.set(nil, forKey: defaultsKeys.kRestaurant)
            } else {
                let encodeData = NSKeyedArchiver.archivedData(withRootObject: newValue!)
                UserDefaults.standard.set(encodeData, forKey: defaultsKeys.kRestaurant)
                UserDefaults.standard.synchronize()
            }
        }
    }
	
	static var categoryList: [CategoryModel] = []
}
