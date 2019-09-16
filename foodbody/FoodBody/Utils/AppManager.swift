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
	
	static var step: Int {
		get {
			guard let decoded = UserDefaults.standard.object(forKey: defaultsKeys.kStepKey) else {
				return 0
			}
			
			guard let steps = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded as! Data) as? Int else {
				return 0
			}
			
			return steps
		}
		set {
			let encodeData = NSKeyedArchiver.archivedData(withRootObject: newValue)
			UserDefaults.standard.set(encodeData, forKey: defaultsKeys.kStepKey)
			UserDefaults.standard.synchronize()
		}
	}
    
    static var latestUpdateStep: String {
        get {
            guard let decoded = UserDefaults.standard.object(forKey: defaultsKeys.kLatestUpdateStep) else {
                return ""
            }
            
            guard let latestUpdate = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded as! Data) as? String else {
                return ""
            }
            
            return latestUpdate
        }
        set {
            let encodeData = NSKeyedArchiver.archivedData(withRootObject: newValue)
            UserDefaults.standard.set(encodeData, forKey: defaultsKeys.kLatestUpdateStep)
            UserDefaults.standard.synchronize()
        }
    }
    //WARNING:
    //App don't change caloLeft because value is static, Please update qickly.
    static var caloLeft: Double = 2500
    
    static func caculateCaloriesLeft()  {
        let yesterday = Date().dayBefore
        let today = Date(timeInterval: 86400, since: yesterday)
       
        
        HealthKitManager.shared.getSteps(dateQuery: today, completion: { step in
            RequestManager.getDailyLog(dateString: today.yyyyMMdd) { (result, error) in
                
            let totalCalo = AppManager.user?.daily_calo ?? 2500
                
            let totalEat = result?.total_eat ?? 0
                
            let caloLeft =  totalCalo + Double(step*20/1000) - totalEat
                
            AppManager.caloLeft = caloLeft
            }
        })
    }
	
}
