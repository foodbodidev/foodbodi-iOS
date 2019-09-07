//
//  Nutrients.swift
//  FoodBody
//
//  Created by Toan Tran on 9/7/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class Nutrients: NSObject {
    var ENERC_KCAL: Double = 0
    var PROCNT: Double = 0
    var FAT: Double = 0
    var CHOCDF: Double = 0
    var FIBTG: Double = 0
    
    init(dict: NSDictionary) {
        super.init();
        if (dict["ENERC_KCAL"] != nil){
            self.ENERC_KCAL = dict["ENERC_KCAL"] as! Double;
        }
        if (dict["PROCNT"] != nil){
            self.PROCNT = dict["PROCNT"] as! Double;
        }
        if (dict["FAT"] != nil){
            self.FAT = dict["FAT"] as! Double;
        }
        if (dict["CHOCDF"] != nil){
            self.CHOCDF = dict["CHOCDF"] as! Double;
        }
        if (dict["FIBTG"] != nil){
            self.FIBTG = dict["FIBTG"] as! Double;
        }
    }
    override init(){
        super.init();
    }
}

