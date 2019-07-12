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
    func showLoadingHub(viewController:UIViewController) {
        MBProgressHUD.showAdded(to: viewController.view, animated: true)
    }
    func hideLoadingHub(viewController:UIViewController) {
        MBProgressHUD.hide(for: viewController.view, animated: true)
    }
    
}
