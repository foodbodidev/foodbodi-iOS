//
//  FoodbodyUtils.swift
//  FoodBody
//
//  Created by Toan Tran on 6/17/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import MBProgressHUD

class FoodbodyUtils: NSObject {
    static let shared = FoodbodyUtils();
    private override init(){};
    
    func checkDataString(dict:NSDictionary,key:String) -> String {
        if let actionString = dict[key] as? String {
            // action is not nil, is a String type, and is now stored in actionString
            return actionString;
        } else {
            // action was either nil, or not a String type
            return "";
        }
    }
    func checkDataFloat(dict:NSDictionary, key:String) -> Double {
        if let actionFloat = dict[key] as? Double {
            return actionFloat;
        } else {
            return -1;
        }
    }
    func checkDataArray(dict:NSDictionary, key:String) -> NSMutableArray {
        if let listObject = dict[key] as? NSMutableArray {
            return listObject;
        } else {
            return NSMutableArray.init();
        }
    }
    func showLoadingHub(viewController:UIViewController) {
        MBProgressHUD.showAdded(to: viewController.view, animated: true)
    }
    func hideLoadingHub(viewController:UIViewController) {
        MBProgressHUD.hide(for: viewController.view, animated: true)
    }
    func dateFromTimeInterval(timeInterval:NSInteger) -> String {
        let dateFormartor = DateFormatter.init();
        dateFormartor.dateFormat = "yyyy-MM-dd";
        let date = NSDate.init(timeIntervalSince1970: TimeInterval(timeInterval))
        
        let time:String = dateFormartor.string(from: date as Date);
        return time;
    }
    
    func dateStringFromDate(date:NSDate) -> String{
        let dateFormartor = DateFormatter.init();
        dateFormartor.dateFormat = "yyyy-MM-dd";
        let time:String = dateFormartor.string(from: date as Date);
        return time;
    }
    func setStatusLoadingFodiMap(hasLoading:Bool){
        UserDefaults.standard.set(hasLoading, forKey:"loadingFodiMap" );
    }
    func getStatusLoadingFodiMap()->Bool{
        let result:Bool = UserDefaults.standard.bool(forKey: "loadingFodiMap");
        return result;
    }
}
