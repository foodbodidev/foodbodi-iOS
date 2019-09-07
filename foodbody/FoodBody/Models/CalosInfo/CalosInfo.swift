//
//  CalosInfo.swift
//  FoodBody
//
//  Created by Toan Tran on 9/7/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class CalosInfo: NSObject {
    var foodId: String = ""
    var label: String = ""
    var category: String = ""
    var categoryLabel: String = ""
    var amount:NSInteger = 0;
    var nutrients: Nutrients = Nutrients();
    
    init(dict: NSDictionary) {
        if (dict["foodId"] != nil){
            self.foodId = dict["foodId"] as! String;
        }
        if (dict["label"] != nil){
            self.label = dict["label"] as! String;
        }
        if (dict["category"] != nil){
            self.category = dict["category"] as! String;
        }
        if (dict["categoryLabel"] != nil){
            self.categoryLabel = dict["categoryLabel"] as! String;
        }
        if (dict["label"] != nil){
            self.label = dict["label"] as! String;
        }
        if (dict["nutrients"] != nil){
            let dict2:NSDictionary = dict["nutrients"] as! NSDictionary;
            self.nutrients = Nutrients.init(dict: dict2);
        }
    }
}
